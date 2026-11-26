# vmware/

**English** | [한국어](README/README.ko.md) | [日本語](README/README.ja.md) | [简体中文](README/README.zh-CN.md) | [Español](README/README.es.md) | [Français](README/README.fr.md)

![Scope](https://img.shields.io/badge/scope-VMware%20test%20only-607078?style=flat-square&logo=vmware&logoColor=white) ![Kernel](https://img.shields.io/badge/kernel-6.16.12--valve24-4a5568?style=flat-square)

Files used to bring up SteamOS Desktop Mode in the VMware test environment.

> [!IMPORTANT]
> **Not needed on a real Steam Deck.** `install.sh` never touches this folder.

## Contents

- [Files](#files)
- [How they fit together](#how-they-fit-together)

---

## Files

| File | Installed to | Purpose | Guide |
| --- | --- | --- | --- |
| [`compat_dirty.h`](compat_dirty.h) | vmwgfx source folder | Replacement for two kernel functions missing from the Valve kernel | [Step 3](../docs/03-Configuration/03-vmwgfx-Driver/README.md#compat-patch) |
| [`vmwgfx-load.service`](vmwgfx-load.service) | `/etc/systemd/system/` (sets A and B) | Loads `/home/vmwgfx/vmwgfx.ko` before the display manager | [Step 5](../docs/03-Configuration/05-Desktop-Autostart/README.md) |
| [`zzz-vmware-desktop.conf`](zzz-vmware-desktop.conf) | `/etc/sddm.conf.d/` (sets A and B) | Autologin to Desktop Mode (`plasma.desktop`) | [Step 5](../docs/03-Configuration/05-Desktop-Autostart/README.md) |

## How they fit together

```mermaid
flowchart LR
    H[compat_dirty.h] -->|make| K[vmwgfx.ko]
    K -->|cp| HOME["/home/vmwgfx/"]
    SVC[vmwgfx-load.service] -->|insmod at boot| HOME
    SVC --> DRI["/dev/dri/card0"]
    DRI --> SDDM[SDDM]
    CONF[zzz-vmware-desktop.conf] --> SDDM
    SDDM --> P[Plasma desktop]
```

> [!NOTE]
> The built `vmwgfx.ko` is tied to one kernel version, so it is not committed (`.gitignore`). Rebuild it after every SteamOS kernel update ([Step 3](../docs/03-Configuration/03-vmwgfx-Driver/README.md)).
