# ダウンロード

[English](../README.md) | [한국어](README.ko.md) | **日本語** | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![Free](https://img.shields.io/badge/All%20tools-free-2ea44f?style=flat-square) ![Official sources](https://img.shields.io/badge/Sources-official%20only-1A9FFF?style=flat-square)

このプロジェクトを再現するために必要なファイルと、公式の入手先をまとめました。すべて無料です。

![必要な資料の一覧](../images/download-links.png)

## 目次

- [1. このプロジェクト](#1-このプロジェクト)
- [2. テスト環境](#2-テスト環境)
- [3. 検証したバージョン](#3-検証したバージョン)
- [4. 実機の Steam Deck では](#4-実機の-steam-deck-では)
- [5. ダウンロード時の注意](#5-ダウンロード時の注意)

---

## 1. このプロジェクト

| 資料 | 入手先 | 備考 |
| --- | --- | --- |
| SteamOS-Unattended（最新） | `git clone https://github.com/jongwooish/SteamOS-Unattended.git` | またはリポジトリの **Code → Download ZIP** |
| リリースファイル | リポジトリの **Releases** タブ | タグ `v1.0.0` 以降 |
| 1 行インストール（SteamOS 内で） | `curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh \| bash` | リポジトリを取得し `minimal` プロファイルで実行します |

---

## 2. テスト環境

| 資料 | 入手先 | 用途 | 備考 |
| --- | --- | --- | --- |
| SteamOS リカバリーイメージ | https://store.steampowered.com/steamos/download/?ver=steamdeck | VM にインストールする SteamOS | 案内：https://help.steampowered.com/faqs/view/1B71-EDF2-EB6D-2BB3 |
| 7-Zip | https://www.7-zip.org/ | `.bz2` イメージの展開 | |
| VMware Workstation Pro | https://support.broadcom.com/group/ecx/productdownloads?subfamily=VMware+Workstation+Pro | 仮想マシン | 個人・教育・商用で無料。Broadcom の無料アカウントが必要 |
| qemu-img（QEMU Windows 版） | https://qemu.weilnetz.de/w64/ | `.img` → VMware `.vmdk` 変換 | Debian/Ubuntu：`sudo apt install qemu-utils` |
| Git for Windows | https://git-scm.com/download/win | リポジトリの取得 | |

---

## 3. 検証したバージョン

| 構成要素 | バージョン |
| --- | --- |
| SteamOS | 3.8.14 |
| カーネル | `6.16.12-valve24.4-1-neptune-616-gfe145653a794` |
| カーネルヘッダーパッケージ | `linux-neptune-616-headers 6.16.12.valve24.4-1` |
| vmwgfx ソース | kernel.org `linux-6.16.12` |
| distrobox / podman | 1.8.1.2 / 5.5.2 |
| ホスト | Windows、VMware Workstation Pro |

---

## 4. 実機の Steam Deck では

テスト環境の資料は不要です。デスクトップモードで Konsole を開き、1 行インストールのコマンドを実行するだけです。

---

## 5. ダウンロード時の注意

- リカバリーイメージは **Valve 公式ページからのみ** 入手します。再配布されたイメージは改ざんや破損の可能性があります。
- VMware のインストーラーも **Broadcom ポータルからのみ** 入手します。「アカウント不要」をうたうサイトは避けてください。
- SteamOS のバージョンが変わるとカーネルも変わるため、[そのバージョンに合わせて vmwgfx ドライバーを再ビルド](../../03-Configuration/03-vmwgfx-Driver/README/README.ja.md)する必要があります。
