# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned

- Verify that every artifact survives a real SteamOS update
- Verify on real Steam Deck hardware
- Modules for Decky Loader and emulator setup

## [1.0.0] - 2026-11-26

### Added

- `install.sh` entry point with `--profile`, `--dry-run` and `--list`; fetches the repository when piped from `curl`
- `lib/common.sh` with logging, dry-run handling and changed/skipped/failed counters
- Modules
  - `00-preflight` — SteamOS version, network and free-space checks
  - `10-flatpak` — per-user Flatpak apps from `config/flatpaks.txt`
  - `20-dotfiles` — dotfiles copied to `$HOME` with backups of differing files
  - `30-distrobox` — `devbox` and `netkit` containers from `config/distrobox.ini`
  - `40-korean-input` — fcitx5 Hangul input set as the KDE input method
  - `50-backup` — daily config backup through a systemd user timer, keeping the last 7
  - `60-etc-keep` — `/etc` keep list in `/etc/atomic-update.conf.d/`
- `minimal` and `full` profiles
- `tests/vm-test.ps1` — automated VMware snapshot test (revert → run → re-run → expect 0 changes)
- `vmware/` — vmwgfx compatibility patch, driver autoload service and Desktop Mode autologin for the VMware test environment
- Documentation in six languages (English, 한국어, 日本語, 简体中文, Español, Français): Downloads, Cautions, Configuration (6 steps), Troubleshooting (15 issues), Filesystem
- Privacy check CI workflow

### Verified

- SteamOS 3.8.14 in VMware Workstation: first run 18 changed / 0 failed, second run 0 changed
- `nmap 7.95` in `netkit`, `git 2.56.1` in `devbox`, scheduled midnight backup, Hangul input with Ctrl+Space

[Unreleased]: https://github.com/jongwooish/SteamOS-Unattended/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/jongwooish/SteamOS-Unattended/releases/tag/v1.0.0
