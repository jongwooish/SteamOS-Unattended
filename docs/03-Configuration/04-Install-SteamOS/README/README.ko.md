# 4단계 · NVMe에 SteamOS 설치

[English](../README.md) | **한국어** | [日本語](README.ja.md) | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![Step](https://img.shields.io/badge/step-4%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

복구 환경에서 Valve 설치 스크립트를 실행해 VM의 NVMe 디스크에 SteamOS를 설치합니다.

## 목차

- [개요](#개요)
- [준비물](#준비물)
- [진행](#진행)
  - [4-1. VMware용 설치 스크립트 복사본 만들기](#4-1-vmware용-설치-스크립트-복사본-만들기)
  - [4-2. VM 화면의 터미널에서 실행](#4-2-vm-화면의-터미널에서-실행)
  - [4-3. 마지막 *Proceed* 는 재부팅](#4-3-마지막-proceed-는-재부팅)
- [확인](#확인)
- [다음 단계](#다음-단계)

---

## 개요

바탕화면의 **Wipe Device & Install SteamOS** 는 *Proceed* 직후 창이 닫히고 아무것도 설치하지 않습니다. 스크립트를 직접 실행해 보면 서로 다른 세 가지 문제가 나옵니다.

| # | 증상 | 원인 | 해결 |
| --- | --- | --- | --- |
| 1 | `!! Please run as root.` | root 권한 필요 | `sudo` 로 실행 ([T6](../../../04-Troubleshooting/README/README.ko.md#t6)) |
| 2 | `zenity … cannot open display` | 확인 창을 화면에 띄움 | SSH가 아니라 **VM 화면의 터미널**에서 실행 |
| 3 | `nvme format` → `Invalid Command Opcode` | VMware 가상 NVMe가 포맷 명령을 지원하지 않음 | 스크립트 복사본에서 그 단계만 건너뜀 ([T7](../../../04-Troubleshooting/README/README.ko.md#t7)) |

## 준비물

- [ ] [3단계](../../03-vmwgfx-Driver/README/README.ko.md) 완료 — 복구 데스크톱 표시, 작업 디스크가 `/mnt/build` 에 연결됨

---

## 진행

### 4-1. VMware용 설치 스크립트 복사본 만들기

SSH에서:

```bash
cp ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
sed -i 's/nvme format/true nvme format/' ~/tools/repair_device_vm.sh
chmod +x ~/tools/repair_device_vm.sh
diff ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
```

`true` 는 뒤에 어떤 인자가 붙어도 성공으로 끝나므로, 하드웨어 포맷 단계만 건너뜁니다. 이 단계는 Steam Deck의 실제 SSD를 위한 것이라 빈 가상 디스크에는 필요 없습니다. 스크립트가 같은 폴더의 다른 파일을 불러오기 때문에 복사본도 `tools/` 에 둡니다.

### 4-2. VM 화면의 터미널에서 실행

복구 데스크톱의 **Terminal with repair tools** 를 더블클릭합니다.

![Terminal with repair tools](../images/terminal-icon.png)

```bash
sudo ~/tools/repair_device_vm.sh all 2>&1 | tee /mnt/build/install.log
```

> [!TIP]
> `tee` 가 작업 디스크에 로그를 남깁니다. 창이 닫혀도 SSH에서 `tail -30 /mnt/build/install.log` 로 확인할 수 있습니다.

![설치 진행 중](../images/install-progress.png)

| 로그 | 의미 |
| --- | --- |
| `mkfs.ext4 … nvme0n1p8` | 파티션 생성과 포맷 완료 |
| `Skipping update due to unsupported hardware revision` | BIOS 업데이트 건너뜀 — VM이라 정상 |
| `Device does not look like a Steam Deck…` | 컨트롤러 펌웨어 건너뜀 — 정상 |
| `fsfreeze -f /` | 복사하는 동안 원본을 얼립니다. VM이 잠깐 멈춘 듯 보일 수 있습니다 |
| `Imaging OS partition A`, `dd … sda3 → nvme0n1p4` | SteamOS 시스템 이미지를 복사하는 중 |

설치본은 복구 이미지의 시스템을 그대로 복사한 것이라 **커널이 같습니다.** 3단계에서 만든 모듈을 그대로 쓸 수 있습니다.

### 4-3. 마지막 *Proceed* 는 재부팅

마지막 확인 창은 "설치 완료, 재부팅" 입니다. VM이 새로 생긴 **SteamOS** 항목으로 부팅하는데, 아직 드라이버가 없어 검은 화면이 나옵니다. 예상된 결과입니다.

![설치 후 Boot Manager](../images/boot-manager-steamos.png)

| 항목 | 정체 |
| --- | --- |
| **SteamOS** | 설치 스크립트가 만든 항목 (NVMe) |
| SATA Hard Drive (0.0) | 복구 디스크 |
| SATA Hard Drive (2.0) | 작업 디스크 (부팅 불가) |

---

## 확인

- [ ] `install.log` 가 `Creating Boot… SteamOS` 로 끝남
- [ ] Boot Manager에 **SteamOS** 항목이 보임

전원을 끄고 다시 **SATA Hard Drive (0.0)** 으로 부팅해 다음 단계를 진행합니다.

## 다음 단계

[5단계 · 데스크톱 자동 실행 →](../../05-Desktop-Autostart/README/README.ko.md)
