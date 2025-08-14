# dpsa — Docker PS Advanced

`dpsa` is a Bash helper that turns `docker ps -a` into a clean ASCII table with:

- **Dynamic column widths**
- **HEALTH** separated from **STATUS**
- **Multi-line PORTS**
- **IMAGE** split tag to a second line if the tag is longer than 10 characters
- Optional live mode via `watch`: `dpsa N`
- Clear dependency checks before running

Tested on RHEL, Rocky Linux, Oracle Linux, and similar distributions.

---
## ⚙ Dependencies

`dpsa` requires the following commands to be available:

- `docker`
- `awk` (gawk or mawk)
- `watch` *(only for live mode)*

If any dependency is missing, `dpsa` will print an error message and exit.

---

## 📦 Install (system-wide, one-liner)

```bash
sudo curl -fsSL https://raw.githubusercontent.com/<your-username>/dpsa/main/dpsa.sh -o /etc/profile.d/dpsa.sh   && sudo chmod +x /etc/profile.d/dpsa.sh   && source /etc/profile.d/dpsa.sh
```

---

## 🚀 Usage

```bash
dpsa           # one-shot view
dpsa 1         # live view, refresh every 1s (requires 'watch')
dpsa 5         # live view, refresh every 5s
```

---

## 📋 Example Output

```
+--------------+---------------+-----------------------------------+-------------+-----------+--------------------------+
| CONTAINER ID | NAMES         | IMAGE                             | STATUS      | HEALTH    | PORTS                    |
+--------------+---------------+-----------------------------------+-------------+-----------+--------------------------+
| 9747fdb71eef | task-runner   | ghcr.io/lfukan/container:devel    | Up 2 hours  | unhealthy | 3000/tcp                 |
+--------------+---------------+-----------------------------------+-------------+-----------+--------------------------+
| 43f1c36ae98b | mailhog       | mailhog/mailhog                   | Up 7 months |           | 0.0.0.0:25->1025/tcp     |
|              |               |                                   |             |           | [::]:25->1025/tcp        |
|              |               |                                   |             |           | 127.0.0.1:2525->8025/tcp |
+--------------+---------------+-----------------------------------+-------------+-----------+--------------------------+
```

---

## ❌ Uninstall

```bash
sudo rm -f /etc/profile.d/dpsa.sh   && unset -f dpsa
```
> Log out and back in for a clean environment, or `unset -f dpsa` removes it immediately from your current shell.

---

## 📜 License

This project is licensed under the [MIT License](LICENSE).
