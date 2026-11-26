# Cautions

**English** | [한국어](README/README.ko.md) | [日本語](README/README.ja.md) | [简体中文](README/README.zh-CN.md) | [Español](README/README.es.md) | [Français](README/README.fr.md)

![Read first](https://img.shields.io/badge/Read-before%20running-e53e3e?style=flat-square)

Read this once before running anything. Most of it actually happened during the project.

## Contents

- [1. Script (real Steam Deck)](#1-script-real-steam-deck)
- [2. SteamOS system](#2-steamos-system)
- [3. VMware test environment](#3-vmware-test-environment)
- [4. Not needed on a real Steam Deck](#4-not-needed-on-a-real-steam-deck)

---

## 1. Script (real Steam Deck)

- **Run with `--dry-run` first.** It only shows what would be installed or changed.
- **Only the `60-etc-keep` module needs sudo.** If the deck password is not set (`passwd`), that module logs a warning and is skipped. The other modules continue normally.
- **Files in `dotfiles/` overwrite files in your `$HOME`.** If the content differs, the original is backed up to `~/.local/state/steamos-unattended/backup/<time>/` first.
- **Only one line is added to `~/.bashrc`** (the line that reads `~/.bash_aliases`). It is never added twice.
- **The first run takes 5–15 minutes** while container images and Flatpak apps download. Wait even if it looks stuck.
- **Hangul input applies from the next login.** Toggle with Ctrl+Space or the Han/Eng key.
- **Backups go to `~/Backups` by default.** That is the same disk, so it does not protect against device failure. Point `config/backup.conf` to an SD card or NAS.
- **Do not put broad patterns like `/etc/**` in the keep list.** It stops future SteamOS updates from changing `/etc` and causes breakage. List only the files you need.

---

## 2. SteamOS system

- **Do not use `steamos-readonly disable`.** This project never touches the system area (`/usr`). Anything installed there disappears on update.
- **Do not run `pacman -Sy`.** The pacman database lives in the read-only area, so it fails, and forcing it leaves system packages out of sync.

---

## 3. VMware test environment

- **Game Mode does not work in VMware.** The virtual GPU has no Vulkan. Clicking "Return to Gaming Mode" gives a black screen; `sudo reboot` over SSH brings back the desktop.
- **The installed system takes 1–2 minutes to reach the desktop.** Wait at least 2 minutes on a black screen.
- **When the SteamOS kernel is updated, rebuild the vmwgfx driver.** The driver service never blocks boot, so you can fix it over SSH.
- **Always check the name and size with `lsblk` before formatting a disk.** Picking the recovery disk (`sda`) by mistake destroys the working environment.
- **Pass the exact `.vmx` path.** A wrong path reverts *that* VM to its snapshot. Be careful when you have many VMs.
- **Check where you are typing.** `PS C:\…>` is Windows; `(deck@steamdeck ~)$` is inside the VM. Windows commands do not work inside the VM.
- **In a VM the Han/Eng key may be captured by Windows or VMware.** Use Ctrl+Space.

---

## 4. Not needed on a real Steam Deck

Steps 1–5 of [Configuration](../03-Configuration/README.md) (creating the VM, the vmwgfx driver, patching the installer, desktop autologin) are **for the VMware test environment only**. Skip them on a real Steam Deck.
