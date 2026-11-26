# 下载

[English](../README.md) | [한국어](README.ko.md) | [日本語](README.ja.md) | **简体中文** | [Español](README.es.md) | [Français](README.fr.md)

![Free](https://img.shields.io/badge/All%20tools-free-2ea44f?style=flat-square) ![Official sources](https://img.shields.io/badge/Sources-official%20only-1A9FFF?style=flat-square)

这里汇总了复现本项目所需的文件及其官方下载地址。全部免费。

![所需资料列表](../images/download-links.png)

## 目录

- [1. 本项目](#1-本项目)
- [2. 测试环境](#2-测试环境)
- [3. 测试所用版本](#3-测试所用版本)
- [4. 在真实的 Steam Deck 上](#4-在真实的-steam-deck-上)
- [5. 下载时的注意事项](#5-下载时的注意事项)

---

## 1. 本项目

| 资料 | 获取方式 | 备注 |
| --- | --- | --- |
| SteamOS-Unattended（最新） | `git clone https://github.com/jongwooish/SteamOS-Unattended.git` | 或在仓库页面点击 **Code → Download ZIP** |
| 发布文件 | 仓库的 **Releases** 标签页 | 从标签 `v1.0.0` 开始 |
| 一行安装（在 SteamOS 中） | `curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh \| bash` | 下载仓库并以 `minimal` 配置运行 |

---

## 2. 测试环境

| 资料 | 获取方式 | 用途 | 备注 |
| --- | --- | --- | --- |
| SteamOS 恢复镜像 | https://store.steampowered.com/steamos/download/?ver=steamdeck | 安装到虚拟机的 SteamOS | 说明：https://help.steampowered.com/faqs/view/1B71-EDF2-EB6D-2BB3 |
| 7-Zip | https://www.7-zip.org/ | 解压 `.bz2` 恢复镜像 | |
| VMware Workstation Pro | https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro | 虚拟机 | 个人、教育、商业用途均免费，需要 Broadcom 免费账号 |
| qemu-img（QEMU Windows 版） | https://qemu.weilnetz.de/w64/ | `.img` → VMware `.vmdk` 转换 | Debian/Ubuntu：`sudo apt install qemu-utils` |
| Git for Windows | https://git-scm.com/download/win | 获取仓库 | |

---

## 3. 测试所用版本

| 组件 | 版本 |
| --- | --- |
| SteamOS | 3.8.14 |
| 内核 | `6.16.12-valve24.4-1-neptune-616-gfe145653a794` |
| 内核头文件包 | `linux-neptune-616-headers 6.16.12.valve24.4-1` |
| vmwgfx 源码 | kernel.org `linux-6.16.12` |
| distrobox / podman | 1.8.1.2 / 5.5.2 |
| 主机 | Windows，VMware Workstation Pro |

---

## 4. 在真实的 Steam Deck 上

不需要任何测试环境的资料。在桌面模式下打开 Konsole，运行一行安装命令即可。

---

## 5. 下载时的注意事项

- 恢复镜像 **只从 Valve 官方页面** 下载。他人转载的镜像可能被篡改或不完整。
- VMware 安装包也 **只从 Broadcom 门户** 下载。避开声称"无需账号即可下载"的网站。
- SteamOS 版本不同时内核也不同，需要 [针对该版本重新编译 vmwgfx 驱动](../../03-Configuration/03-vmwgfx-Driver/README/README.zh-CN.md)。
