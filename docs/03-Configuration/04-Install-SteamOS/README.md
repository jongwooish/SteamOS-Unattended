# Step 4 · Install SteamOS to NVMe

**English** | [한국어](README/README.ko.md) | [日本語](README/README.ja.md) | [简体中文](README/README.zh-CN.md) | [Español](README/README.es.md) | [Français](README/README.fr.md)

![Step](https://img.shields.io/badge/step-4%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

Run Valve's installer from the recovery environment and write SteamOS to the VM's NVMe disk.

## Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
  - [4-1. Make a VMware-safe copy of the installer](#4-1-make-a-vmware-safe-copy-of-the-installer)
  - [4-2. Run it from the VM's terminal](#4-2-run-it-from-the-vms-terminal)
  - [4-3. The last *Proceed* reboots](#4-3-the-last-proceed-reboots)
- [Verification](#verification)
- [Next](#next)

---

## Overview

The desktop shortcut **Wipe Device & Install SteamOS** closes right after *Proceed* and installs nothing. Running the script by hand reveals three separate blockers:

| # | Symptom | Cause | Fix |
| --- | --- | --- | --- |
| 1 | `!! Please run as root.` | Needs root | Run with `sudo` ([T6](../../04-Troubleshooting/README.md#t6)) |
| 2 | `zenity … cannot open display` | Shows a confirmation dialog | Run from the **VM's own terminal**, not SSH |
| 3 | `nvme format` → `Invalid Command Opcode` | VMware's virtual NVMe does not implement the format command | Skip that one step in a copy of the script ([T7](../../04-Troubleshooting/README.md#t7)) |

## Prerequisites

- [ ] [Step 3](../03-vmwgfx-Driver/README.md) completed — recovery desktop visible, work disk mounted at `/mnt/build`

---

## Steps

### 4-1. Make a VMware-safe copy of the installer

Over SSH:

```bash
cp ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
sed -i 's/nvme format/true nvme format/' ~/tools/repair_device_vm.sh
chmod +x ~/tools/repair_device_vm.sh
diff ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
```

`true` succeeds whatever arguments follow, so only the hardware format is skipped. That step is meant for the Steam Deck's physical SSD; an empty virtual disk does not need it. The copy stays in `tools/` because the script loads sibling files.

### 4-2. Run it from the VM's terminal

Double-click **Terminal with repair tools** on the recovery desktop.

![Terminal with repair tools](images/terminal-icon.png)

```bash
sudo ~/tools/repair_device_vm.sh all 2>&1 | tee /mnt/build/install.log
```

> [!TIP]
> `tee` keeps the log on the work disk. If the window closes, read it over SSH with `tail -30 /mnt/build/install.log`.

![Installation in progress](images/install-progress.png)

| Log line | Meaning |
| --- | --- |
| `mkfs.ext4 … nvme0n1p8` | Partitions created and formatted |
| `Skipping update due to unsupported hardware revision` | BIOS update skipped — expected in a VM |
| `Device does not look like a Steam Deck…` | Controller firmware skipped — expected |
| `fsfreeze -f /` | Source frozen while copying; the VM may feel stuck briefly |
| `Imaging OS partition A`, `dd … sda3 → nvme0n1p4` | Copying the SteamOS system image |

The installed system is a copy of the recovery image's system, so the **kernel is identical** and the module from Step 3 works unchanged.

### 4-3. The last *Proceed* reboots

The final dialog means "installation finished — reboot". The VM boots the new **SteamOS** entry, which shows a black screen because the driver is not installed there yet. This is expected.

![Boot Manager after installation](images/boot-manager-steamos.png)

| Entry | What it is |
| --- | --- |
| **SteamOS** | Created by the installer (NVMe) |
| SATA Hard Drive (0.0) | Recovery disk |
| SATA Hard Drive (2.0) | Work disk (not bootable) |

---

## Verification

- [ ] `install.log` ends with `Creating Boot… SteamOS`
- [ ] Boot Manager lists a **SteamOS** entry

Power off and boot **SATA Hard Drive (0.0)** again to continue.

## Next

[Step 5 · Desktop autostart →](../05-Desktop-Autostart/README.md)
