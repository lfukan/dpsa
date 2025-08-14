# dpsa — Docker PS Advanced

`dpsa` is a Bash helper that turns `docker ps -a` into user readable table:

```
+--------------+----------------+-----------------------------------+-------------+-----------+--------------------------+
| CONTAINER ID | CONTAINER NAME | IMAGE:TAG                         | STATUS      | HEALTH    | PORTS                    |
+--------------+----------------+-----------------------------------+-------------+-----------+--------------------------+
| 9747fdb71eef | task-runner    | ghcr.io/lfukan/container:devel    | Up 2 hours  | healthy   | 3000/tcp                 |
+--------------+----------------+-----------------------------------+-------------+-----------+--------------------------+
| 43f1c36ae98b | mailhog        | mailhog/mailhog                   | Up 7 months |           | 0.0.0.0:25->1025/tcp     |
|              |                |                                   |             |           | [::]:25->1025/tcp        |
+--------------+----------------+-----------------------------------+-------------+-----------+--------------------------+
```

- Table has dynamic column widths
- Health status is separated from STATUS into separate column
- PORTS are multi-line - so much more readable then using original command
- IMAGE has split tag to a second line if the tag is longer than 10 characters
- There is also optional live mode made via watch

Tested on RHEL & Rocky Linux distibutions.

---
## ⚙ Dependencies

`dpsa` requires the following commands to be available:

- `docker`
- `awk` (gawk or mawk)
- `watch` *(only for live mode)*

If any dependency is missing, `dpsa` will print an error message and exit.

---

## 📦 Install (system-wide)

```bash
sudo curl -fsSL https://raw.githubusercontent.com/lfukan/dpsa/main/dpsa.sh \
-o /etc/profile.d/dpsa.sh && \
sudo chmod +x /etc/profile.d/dpsa.sh && \
source /etc/profile.d/dpsa.sh

```

---

## 🚀 Usage

```bash
dpsa           # basic view
dpsa N         # live view, refresh every N seconds
```

---

## ❌ Uninstall

```bash
sudo rm -f /etc/profile.d/dpsa.sh && unset -f dpsa
```
> Log out and back in for a clean environment, or `unset -f dpsa` removes it immediately from your current shell.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).
