# ステップ 4 · NVMe への SteamOS インストール

[English](../README.md) | [한국어](README.ko.md) | **日本語** | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![Step](https://img.shields.io/badge/step-4%20%2F%206-2c7a7b?style=flat-square) ![Time](https://img.shields.io/badge/time-~20%20min-4a5568?style=flat-square) ![Scope](https://img.shields.io/badge/scope-VMware%20only-607078?style=flat-square)

リカバリー環境から Valve のインストーラーを実行し、VM の NVMe ディスクに SteamOS を書き込みます。

## 目次

- [概要](#概要)
- [前提条件](#前提条件)
- [手順](#手順)
  - [4-1. VMware 向けのインストーラーのコピーを作る](#4-1-vmware-向けのインストーラーのコピーを作る)
  - [4-2. VM 画面のターミナルから実行する](#4-2-vm-画面のターミナルから実行する)
  - [4-3. 最後の *Proceed* は再起動](#4-3-最後の-proceed-は再起動)
- [確認](#確認)
- [次へ](#次へ)

---

## 概要

デスクトップの **Wipe Device & Install SteamOS** は *Proceed* の直後にウィンドウが閉じ、何もインストールされません。スクリプトを手動で実行すると、3 つの別々の問題が見つかります。

| # | 症状 | 原因 | 対処 |
| --- | --- | --- | --- |
| 1 | `!! Please run as root.` | root 権限が必要 | `sudo` で実行（[T6](../../../04-Troubleshooting/README/README.ja.md#t6)） |
| 2 | `zenity … cannot open display` | 確認ダイアログを画面に表示する | SSH ではなく **VM 画面のターミナル** で実行 |
| 3 | `nvme format` → `Invalid Command Opcode` | VMware の仮想 NVMe がフォーマットコマンドに未対応 | スクリプトのコピーでその手順だけ飛ばす（[T7](../../../04-Troubleshooting/README/README.ja.md#t7)） |

## 前提条件

- [ ] [ステップ 3](../../03-vmwgfx-Driver/README/README.ja.md) 完了 — リカバリーのデスクトップが表示され、作業ディスクが `/mnt/build` にマウント済み

---

## 手順

### 4-1. VMware 向けのインストーラーのコピーを作る

SSH で：

```bash
cp ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
sed -i 's/nvme format/true nvme format/' ~/tools/repair_device_vm.sh
chmod +x ~/tools/repair_device_vm.sh
diff ~/tools/repair_device.sh ~/tools/repair_device_vm.sh
```

`true` は後ろにどんな引数があっても成功で終わるため、ハードウェアのフォーマットだけが飛ばされます。この手順は Steam Deck の実際の SSD 向けで、空の仮想ディスクには不要です。スクリプトが同じフォルダーの別ファイルを読み込むので、コピーも `tools/` に置きます。

### 4-2. VM 画面のターミナルから実行する

リカバリーデスクトップの **Terminal with repair tools** をダブルクリックします。

![Terminal with repair tools](../images/terminal-icon.png)

```bash
sudo ~/tools/repair_device_vm.sh all 2>&1 | tee /mnt/build/install.log
```

> [!TIP]
> `tee` がログを作業ディスクに残します。ウィンドウが閉じても、SSH で `tail -30 /mnt/build/install.log` を実行すれば確認できます。

![インストール中](../images/install-progress.png)

| ログ | 意味 |
| --- | --- |
| `mkfs.ext4 … nvme0n1p8` | パーティションの作成とフォーマット完了 |
| `Skipping update due to unsupported hardware revision` | BIOS 更新をスキップ — VM では正常 |
| `Device does not look like a Steam Deck…` | コントローラーのファームウェアをスキップ — 正常 |
| `fsfreeze -f /` | コピー中は元を凍結。VM が一時的に固まったように見えることがある |
| `Imaging OS partition A`、`dd … sda3 → nvme0n1p4` | SteamOS のシステムイメージをコピー中 |

インストール後のシステムはリカバリーイメージのシステムをそのままコピーしたものなので、**カーネルは同一** です。ステップ 3 のモジュールがそのまま使えます。

### 4-3. 最後の *Proceed* は再起動

最後のダイアログは「インストール完了、再起動」という意味です。VM は新しい **SteamOS** エントリーから起動しますが、まだドライバーがないため黒い画面になります。これは想定どおりです。

![インストール後の Boot Manager](../images/boot-manager-steamos.png)

| 項目 | 内容 |
| --- | --- |
| **SteamOS** | インストーラーが作成（NVMe） |
| SATA Hard Drive (0.0) | リカバリーディスク |
| SATA Hard Drive (2.0) | 作業ディスク（起動不可） |

---

## 確認

- [ ] `install.log` が `Creating Boot… SteamOS` で終わっている
- [ ] Boot Manager に **SteamOS** が表示される

電源を切り、もう一度 **SATA Hard Drive (0.0)** から起動して次へ進みます。

## 次へ

[ステップ 5 · デスクトップの自動起動 →](../../05-Desktop-Autostart/README/README.ja.md)
