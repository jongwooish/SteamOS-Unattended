# Step 1 · Create the VM

**English** | [한국어](README/README.ko.md) | [日本語](README/README.ja.md) | [简体中文](README/README.zh-CN.md) | [Español](README/README.es.md) | [Français](README/README.fr.md)

![Step](https://img.shields.io/badge/step-1%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

Build a VMware Workstation VM that can boot the SteamOS recovery image.

> [!NOTE]
> This step is only for the VMware test environment. On a real Steam Deck, go straight to [Step 6](../06-Run-Unattended/README.md).

## Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
  - [1-1. Extract the recovery image](#1-1-extract-the-recovery-image)
  - [1-2. Convert it to a VMware disk](#1-2-convert-it-to-a-vmware-disk)
  - [1-3. Create the VM](#1-3-create-the-vm)
  - [1-4. Attach the recovery disk and enable 3D](#1-4-attach-the-recovery-disk-and-enable-3d)
- [Verification](#verification)
- [Next](#next)

---

## Overview

The SteamOS recovery image is a raw USB image built for the Steam Deck. To boot it in VMware, three things must match what the image expects:

| Requirement | Why |
| --- | --- |
| **UEFI firmware** | The image has no BIOS boot loader. BIOS [falls back to network boot](../../04-Troubleshooting/README.md#t1). |
| **NVMe target disk** | The installer writes to `/dev/nvme0n1`, the Steam Deck's internal SSD. |
| **`.vmdk` disk format** | VMware cannot attach a raw `.img` file. |

## Prerequisites

- [ ] VMware Workstation Pro installed
- [ ] SteamOS recovery image (`steamdeck-repair-….img.bz2`)
- [ ] 7-Zip and `qemu-img`
- [ ] About 100 GB of free disk space

All download links are in [Downloads](../../01-Downloads/README.md).

---

## Steps

### 1-1. Extract the recovery image

Extract the `.bz2` file with 7-Zip. Renaming the result to `SteamOS.img` keeps the next commands short.

### 1-2. Convert it to a VMware disk

```powershell
cd C:\VMs
& "C:\Program Files\qemu\qemu-img.exe" convert -p -f raw -O vmdk .\SteamOS.img .\recovery.vmdk
```

![qemu-img conversion finished](images/qemu-img-convert.png)

> [!WARNING]
> Do not move `recovery.vmdk` until the installation is finished. The VM keeps an absolute path to it.

### 1-3. Create the VM

**File → New Virtual Machine → Custom (advanced)**, then:

| Screen | Value |
| --- | --- |
| Guest OS installation | I will install the operating system later |
| Guest OS | Linux · **Other Linux 6.x kernel 64-bit** |
| Firmware | **UEFI**, Secure Boot **off** |
| Processors | 4 cores |
| Memory | 8 GB or more |
| Network | NAT |
| Disk | **NVMe**, 64 GB or more, single file |

![Memory setting](images/vm-memory.png)

![Processor setting](images/vm-processors.png)

### 1-4. Attach the recovery disk and enable 3D

In **Edit virtual machine settings**:

1. **Add → Hard Disk → SATA → Use an existing virtual disk** → `recovery.vmdk` → **Keep Existing Format**
2. **Display → Accelerate 3D graphics** on, Graphics memory 4 GB or more

![Display setting](images/vm-display.png)

> [!TIP]
> Grey, disabled options mean the VM is running. Power it off before changing settings ([T3](../../04-Troubleshooting/README.md#t3)).

---

## Verification

**Edit virtual machine settings** should show:

| Device | Content |
| --- | --- |
| Hard Disk (NVMe) | 70 GB, empty — SteamOS install target |
| Hard Disk (SATA 0.0) | `recovery.vmdk` — recovery environment |
| Memory / Processors | 8 GB / 4 |
| Network / Display | NAT / 3D acceleration |

A 20 GB work disk is added later in [Step 3](../03-vmwgfx-Driver/README.md).

> [!TIP]
> Take a snapshot named `before-install` now (VM powered off). If anything later fails, you can return here in seconds.

## Next

[Step 2 · Recovery boot and SSH →](../02-Recovery-Boot/README.md)
