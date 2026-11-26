# 1단계 · VM 만들기

[English](../README.md) | **한국어** | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![Step](https://img.shields.io/badge/step-1%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

SteamOS 복구 이미지로 부팅할 수 있는 VMware Workstation VM을 만듭니다.

> [!NOTE]
> 이 단계는 VMware 테스트 환경 전용입니다. 실제 Steam Deck에서는 바로 [6단계](../../06-Run-Unattended/README/README.ko.md)로 가세요.

## 목차

- [개요](#개요)
- [준비물](#준비물)
- [진행](#진행)
  - [1-1. 복구 이미지 압축 풀기](#1-1-복구-이미지-압축-풀기)
  - [1-2. VMware 디스크로 변환](#1-2-vmware-디스크로-변환)
  - [1-3. VM 만들기](#1-3-vm-만들기)
  - [1-4. 복구 디스크 연결과 3D 가속](#1-4-복구-디스크-연결과-3d-가속)
- [확인](#확인)
- [다음 단계](#다음-단계)

---

## 개요

SteamOS 복구 이미지는 Steam Deck용으로 만든 USB 원본(raw) 이미지입니다. VMware에서 부팅하려면 이미지가 기대하는 세 가지 조건을 맞춰야 합니다.

| 조건 | 이유 |
| --- | --- |
| **UEFI 펌웨어** | 이미지에 BIOS용 부트로더가 없습니다. BIOS로 만들면 [네트워크 부팅으로 빠집니다](../../../04-Troubleshooting/README/README.ko.md#t1). |
| **NVMe 설치 디스크** | 설치 스크립트가 Steam Deck 내장 SSD인 `/dev/nvme0n1` 에 씁니다. |
| **`.vmdk` 디스크 형식** | VMware는 raw `.img` 파일을 그대로 붙이지 못합니다. |

## 준비물

- [ ] VMware Workstation Pro 설치
- [ ] SteamOS 복구 이미지 (`steamdeck-repair-….img.bz2`)
- [ ] 7-Zip과 `qemu-img`
- [ ] 여유 디스크 공간 약 100GB

다운로드 링크는 [자료실](../../../01-Downloads/README/README.ko.md)에 모두 있습니다.

---

## 진행

### 1-1. 복구 이미지 압축 풀기

7-Zip으로 `.bz2` 파일을 풉니다. 결과 파일 이름을 `SteamOS.img` 로 바꾸면 다음 명령이 짧아집니다.

### 1-2. VMware 디스크로 변환

```powershell
cd C:\VMs
& "C:\Program Files\qemu\qemu-img.exe" convert -p -f raw -O vmdk .\SteamOS.img .\recovery.vmdk
```

![qemu-img 변환 완료](../images/qemu-img-convert.png)

> [!WARNING]
> 설치가 끝날 때까지 `recovery.vmdk` 를 옮기지 마세요. VM이 이 파일의 절대 경로를 기억합니다.

### 1-3. VM 만들기

**File → New Virtual Machine → Custom (advanced)** 를 고른 뒤:

| 화면 | 값 |
| --- | --- |
| 게스트 OS 설치 | I will install the operating system later |
| 게스트 OS | Linux · **Other Linux 6.x kernel 64-bit** |
| 펌웨어 | **UEFI**, Secure Boot **해제** |
| 프로세서 | 4코어 |
| 메모리 | 8GB 이상 |
| 네트워크 | NAT |
| 디스크 | **NVMe**, 64GB 이상, 단일 파일 |

![메모리 설정](../images/vm-memory.png)

![프로세서 설정](../images/vm-processors.png)

### 1-4. 복구 디스크 연결과 3D 가속

**Edit virtual machine settings** 에서:

1. **Add → Hard Disk → SATA → Use an existing virtual disk** → `recovery.vmdk` → **Keep Existing Format**
2. **Display → Accelerate 3D graphics** 켜기, Graphics memory 4GB 이상

![디스플레이 설정](../images/vm-display.png)

> [!TIP]
> 항목이 회색으로 비활성화되어 있으면 VM이 켜져 있는 상태입니다. 전원을 끈 뒤 설정을 바꾸세요([T3](../../../04-Troubleshooting/README/README.ko.md#t3)).

---

## 확인

**Edit virtual machine settings** 가 다음과 같으면 됩니다.

| 장치 | 내용 |
| --- | --- |
| Hard Disk (NVMe) | 70GB, 비어 있음 — SteamOS 설치 대상 |
| Hard Disk (SATA 0.0) | `recovery.vmdk` — 복구 환경 |
| Memory / Processors | 8GB / 4 |
| Network / Display | NAT / 3D 가속 |

20GB 작업 디스크는 [3단계](../../03-vmwgfx-Driver/README/README.ko.md)에서 추가합니다.

> [!TIP]
> 지금 `before-install` 스냅샷을 찍어 두세요(VM 전원 끈 상태). 이후에 실패해도 몇 초 만에 이 상태로 돌아올 수 있습니다.

## 다음 단계

[2단계 · 복구 환경 부팅과 SSH →](../../02-Recovery-Boot/README/README.ko.md)
