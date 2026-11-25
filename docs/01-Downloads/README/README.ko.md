# 자료실

[English](../README.md) | **한국어** | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![Free](https://img.shields.io/badge/All%20tools-free-2ea44f?style=flat-square) ![Official sources](https://img.shields.io/badge/Sources-official%20only-1A9FFF?style=flat-square)

이 프로젝트를 따라 하는 데 필요한 파일과 공식 배포처를 모았습니다. 전부 무료입니다.

![필요 자료 목록](../images/download-links.png)

## 목차

- [1. 이 프로젝트](#1-이-프로젝트)
- [2. 테스트 환경](#2-테스트-환경)
- [3. 검증에 쓴 버전](#3-검증에-쓴-버전)
- [4. 실제 Steam Deck에서는](#4-실제-steam-deck에서는)
- [5. 받을 때 주의](#5-받을-때-주의)

---

## 1. 이 프로젝트

| 자료 | 받는 곳 | 비고 |
| --- | --- | --- |
| SteamOS-Unattended (최신) | `git clone https://github.com/jongwooish/SteamOS-Unattended.git` | 또는 저장소의 **Code → Download ZIP** |
| 릴리스 파일 | 저장소의 **Releases** 탭 | 태그 `v1.0.0` 부터 |
| 한 줄 설치 (SteamOS 안에서) | `curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh \| bash` | 저장소를 받아 `minimal` 프로필로 실행합니다 |

---

## 2. 테스트 환경

| 자료 | 받는 곳 | 용도 | 비고 |
| --- | --- | --- | --- |
| SteamOS 복구 이미지 | https://store.steampowered.com/steamos/download/?ver=steamdeck | VM에 설치할 SteamOS | 안내: https://help.steampowered.com/faqs/view/1B71-EDF2-EB6D-2BB3 |
| 7-Zip | https://www.7-zip.org/ | 복구 이미지 `.bz2` 압축 풀기 | |
| VMware Workstation Pro | https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro | 가상 머신 | 개인, 교육, 상업 용도 무료. Broadcom 무료 계정 필요 |
| qemu-img (QEMU Windows 빌드) | https://qemu.weilnetz.de/w64/ | `.img` → VMware `.vmdk` 변환 | Debian/Ubuntu: `sudo apt install qemu-utils` |
| Git for Windows | https://git-scm.com/download/win | 저장소 받기 | |

---

## 3. 검증에 쓴 버전

| 구성 요소 | 버전 |
| --- | --- |
| SteamOS | 3.8.14 |
| 커널 | `6.16.12-valve24.4-1-neptune-616-gfe145653a794` |
| 커널 헤더 패키지 | `linux-neptune-616-headers 6.16.12.valve24.4-1` |
| vmwgfx 소스 | kernel.org `linux-6.16.12` |
| distrobox / podman | 1.8.1.2 / 5.5.2 |
| 호스트 | Windows, VMware Workstation Pro |

---

## 4. 실제 Steam Deck에서는

테스트 환경 자료는 필요 없습니다. 데스크톱 모드에서 Konsole을 열고 한 줄 설치 명령만 실행하면 됩니다.

---

## 5. 받을 때 주의

- 복구 이미지는 **Valve 공식 페이지에서만** 받습니다. 다시 올라온 이미지는 변조되었거나 덜 받아진 파일일 수 있습니다.
- VMware 설치 파일도 **Broadcom 포털에서만** 받습니다. "계정 없이 받기" 같은 사이트는 피합니다.
- SteamOS 버전이 다르면 커널이 달라지므로 [vmwgfx 드라이버를 그 버전에 맞게 다시 빌드](../../03-Configuration/03-vmwgfx-Driver/README/README.ko.md)해야 합니다.
