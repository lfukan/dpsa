#!/bin/bash

_check_deps() {
  local missing=0
  for cmd in docker awk; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo -e "\033[31mError:\033[0m Required command '$cmd' is not installed or not in PATH." >&2
      missing=1
    fi
  done
  if [[ -n "$1" && "$1" =~ ^[0-9]+$ ]]; then
    if ! command -v watch >/dev/null 2>&1; then
      echo -e "\033[31mError:\033[0m 'watch' is required for interval mode (dpsa N)." >&2
      missing=1
    fi
  fi
  return $missing
}

_dpsa_table() {
  if [[ -n "$INTERVAL" ]]; then
    local left="Every ${INTERVAL}s: dpsa"
    local right="$(hostname): $(date)"
    local term_width=$(tput cols 2>/dev/null || echo 80)
    local spaces=$(( term_width - ${#left} - ${#right} ))
    (( spaces < 1 )) && spaces=1
    printf "%s%*s%s\n\n" "$left" $spaces "" "$right"
  fi

  docker ps -a --format "{{.ID}}|{{.Names}}|{{.Image}}|{{.Status}}|{{.Ports}}" |
  awk -F"|" '
function rep(n,ch,    i,s){s="";for(i=0;i<n;i++)s=s ch;return s}
BEGIN{
  th_id="CONTAINER ID"; th_name="CONTAINER NAME"; th_img="IMAGE:TAG";
  th_stat="STATUS"; th_health="HEALTH"; th_ports="PORTS";
  w_id=length(th_id); w_name=length(th_name); w_img=length(th_img);
  w_stat=length(th_stat); w_health=length(th_health); w_ports=length(th_ports);
}
{
  row++;
  id[row]=$1; name[row]=$2;

  # Break image into two lines only if tag length > 10
  img_full=$3;
  if (match(img_full, /:/)) {
    tag_part = substr(img_full, RSTART+1);
    if (length(tag_part) > 10) {
      img[row,1] = substr(img_full, 1, RSTART-1);
      img[row,2] = substr(img_full, RSTART); # keep colon
      img_lines[row] = 2;
    } else {
      img[row,1] = img_full;
      img[row,2] = "";
      img_lines[row] = 1;
    }
  } else {
    img[row,1] = img_full;
    img[row,2] = "";
    img_lines[row] = 1;
  }

  s=$4; h="";
  if (match(s, /\([^)]*\)/)) {
    h=substr(s,RSTART+1,RLENGTH-2);
    s1=substr(s,1,RSTART-1); s2=substr(s,RSTART+RLENGTH);
    gsub(/[[:space:]]+$/, "", s1); gsub(/^[[:space:]]+/, "", s2);
    s=(length(s1)&&length(s2))?s1" "s2:s1 s2;
  }
  stat[row]=s; health[row]=h;

  n=split($5,p,/, /); pc[row]=n;
  for(i=1;i<=n;i++){ ports[row,i]=p[i]; if(length(p[i])>w_ports) w_ports=length(p[i]) }

  for(l=1;l<=img_lines[row];l++) if(length(img[row,l])>w_img) w_img=length(img[row,l]);
  if(length($1)>w_id) w_id=length($1);
  if(length($2)>w_name) w_name=length($2);
  if(length(s)>w_stat) w_stat=length(s);
  if(length(h)>w_health) w_health=length(h);
}
END{
  sep = "+" rep(w_id+2,"-") "+" rep(w_name+2,"-") "+" rep(w_img+2,"-") "+" rep(w_stat+2,"-") "+" rep(w_health+2,"-") "+" rep(w_ports+2,"-") "+";
  print sep;
  printf "| %-*s | %-*s | %-*s | %-*s | %-*s | %-*s |\n", w_id, th_id, w_name, th_name, w_img, th_img, w_stat, th_stat, w_health, th_health, w_ports, th_ports;
  print sep;
  for(r=1;r<=row;r++){
    max_lines = (img_lines[r] > pc[r] ? img_lines[r] : pc[r]);
    if (max_lines < 1) max_lines = 1;
    for(line=1; line<=max_lines; line++){
      printf "| %-*s | %-*s | %-*s | %-*s | %-*s | %-*s |\n",
        w_id, (line==1?id[r]:""),
        w_name, (line==1?name[r]:""),
        w_img, (line<=img_lines[r]?img[r,line]:""),
        w_stat, (line==1?stat[r]:""),
        w_health, (line==1?health[r]:""),
        w_ports, (line<=pc[r]?ports[r,line]:"");
    }
    print sep;
  }
}'
}

dpsa() {
  local interval="$1"
  _check_deps "$interval" || return 1
  if [[ -n "$interval" ]]; then
    INTERVAL="$interval" watch -n "$interval" -t bash -c "_dpsa_table"
  else
    _dpsa_table
  fi
}

export -f dpsa
export -f _dpsa_table
