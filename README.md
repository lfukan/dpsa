# dpsa — Docker PS Advanced

`dpsa` is a Bash helper that turns `docker ps -a` into a clean ASCII table with:

- **IMAGE** split image tag to a second line **only if the tag is longer than 10 characters**
- **HEALTH** separated from **STATUS**
- **Multi-line PORTS**
- **Dynamic column widths**
- Optional live mode via `watch`: `dpsa 1`

Tested on RHEL, Rocky Linux, Oracle Linux, and similar distributions.

---

## 📦 Install (system-wide, 1 line)
```bash
sudo curl -fsSL https://raw.githubusercontent.com/lfukan/dpsa/main/dpsa.sh -o /etc/profile.d/dpsa.sh \
  && sudo chmod +x /etc/profile.d/dpsa.sh \
  && source /etc/profile.d/dpsa.sh
