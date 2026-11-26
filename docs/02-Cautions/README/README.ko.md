# 주의사항

[English](../README.md) | **한국어** | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![Read first](https://img.shields.io/badge/Read-before%20running-e53e3e?style=flat-square)

실행하기 전에 한 번 읽어 주세요. 대부분 프로젝트를 진행하면서 실제로 겪은 일입니다.

## 목차

- [1. 스크립트 (실제 Steam Deck)](#1-스크립트-실제-steam-deck)
- [2. SteamOS 시스템](#2-steamos-시스템)
- [3. VMware 테스트 환경](#3-vmware-테스트-환경)
- [4. 실제 Steam Deck에는 필요 없는 것](#4-실제-steam-deck에는-필요-없는-것)

---

## 1. 스크립트 (실제 Steam Deck)

- **처음에는 `--dry-run` 으로 실행합니다.** 무엇을 설치하고 바꿀지만 보여 주고 아무것도 바꾸지 않습니다.
- **`60-etc-keep` 모듈만 sudo가 필요합니다.** deck 비밀번호를 정하지 않았다면(`passwd`) 이 모듈은 경고만 남기고 건너뜁니다. 나머지 모듈은 정상 진행됩니다.
- **`dotfiles/` 의 파일은 내 `$HOME` 파일을 덮어씁니다.** 내용이 다르면 덮어쓰기 전에 `~/.local/state/steamos-unattended/backup/<시각>/` 에 원본을 백업합니다.
- **`~/.bashrc` 에는 한 줄만 추가합니다** (`~/.bash_aliases` 를 읽는 줄). 이미 있으면 다시 추가하지 않습니다.
- **첫 실행은 5~15분 걸립니다.** 컨테이너 이미지와 Flatpak 앱을 받기 때문입니다. 멈춘 것처럼 보여도 기다려 주세요.
- **한글 입력은 다음 로그인부터 적용됩니다.** 전환 키는 Ctrl+Space 또는 한/영입니다.
- **백업은 기본으로 `~/Backups` 에 쌓입니다.** 같은 디스크라서 기기 고장에는 대비가 안 됩니다. `config/backup.conf` 에서 SD카드나 NAS 경로로 바꾸는 것을 권장합니다.
- **`/etc/**` 처럼 넓은 패턴을 유지 목록에 넣지 않습니다.** 이후 SteamOS 업데이트가 `/etc` 를 고치지 못하게 막아 문제가 생깁니다. 필요한 파일만 적어 주세요.

---

## 2. SteamOS 시스템

- **`steamos-readonly disable` 을 쓰지 않습니다.** 이 프로젝트는 시스템 영역(`/usr`)을 전혀 건드리지 않습니다. 그곳에 설치한 것은 업데이트 때 사라집니다.
- **`pacman -Sy` 를 실행하지 않습니다.** pacman 데이터베이스가 읽기 전용 영역에 있어 실패하고, 억지로 하면 시스템 패키지 버전이 어긋납니다.

---

## 3. VMware 테스트 환경

- **게임 모드는 VMware에서 동작하지 않습니다.** 가상 GPU에 Vulkan이 없기 때문입니다. "Return to Gaming Mode" 를 누르면 검은 화면이 되고, SSH로 `sudo reboot` 하면 데스크톱으로 돌아옵니다.
- **설치본은 데스크톱까지 1~2분 걸립니다.** 검은 화면이 보여도 최소 2분은 기다려 주세요.
- **SteamOS 커널이 업데이트되면 vmwgfx 드라이버를 다시 빌드합니다.** 드라이버 서비스는 부팅을 막지 않으므로 SSH로 들어가 고치면 됩니다.
- **디스크를 포맷하기 전에 반드시 `lsblk` 로 이름과 크기를 확인합니다.** 복구 디스크(`sda`)를 잘못 고르면 작업 환경이 사라집니다.
- **`.vmx` 경로를 정확히 넣습니다.** 경로가 틀리면 *그* VM이 스냅샷으로 되돌아갑니다. VM이 많을수록 조심해 주세요.
- **명령을 어디서 입력하는지 확인합니다.** `PS C:\…>` 는 Windows, `(deck@steamdeck ~)$` 는 VM 안입니다. Windows 명령은 VM 안에서 동작하지 않습니다.
- **VM에서는 한/영 키를 Windows나 VMware가 먼저 가져갈 수 있습니다.** Ctrl+Space를 사용하세요.

---

## 4. 실제 Steam Deck에는 필요 없는 것

[Configuration](../../03-Configuration/README/README.ko.md) 의 1~5단계(VM 만들기, vmwgfx 드라이버, 설치 스크립트 수정, 데스크톱 자동 로그인)는 **VMware 테스트 환경 전용**입니다. 실제 Steam Deck에서는 건너뜁니다.
