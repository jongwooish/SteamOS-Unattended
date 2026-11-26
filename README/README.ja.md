<div align="center">

# SteamOS-Unattended

**初期化しても、アップデートしても — コマンド 1 行で Steam Deck の環境が元どおりに。**

SteamOS デスクトップモード向けの無人・冪等セットアップ

[English](../README.md) | [한국어](README.ko.md) | **日本語** | [简体中文](README.zh-CN.md) | [Español](README.es.md) | [Français](README.fr.md)

![SteamOS](https://img.shields.io/badge/SteamOS-3.8.14-1A9FFF?style=for-the-badge&logo=steam&logoColor=white) ![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white) ![Flatpak](https://img.shields.io/badge/Flatpak-4A90D9?style=for-the-badge&logo=flatpak&logoColor=white) ![Distrobox](https://img.shields.io/badge/Distrobox-1.8.1-8A2BE2?style=for-the-badge) ![VMware](https://img.shields.io/badge/Tested%20on-VMware%20Workstation-607078?style=for-the-badge&logo=vmware&logoColor=white)

[クイックスタート](#クイックスタート) · [モジュール](#モジュール) · [検証結果](#検証結果) · [ドキュメント](../docs/README/README.ja.md) · [変更履歴](../CHANGELOG.md)

</div>

```bash
curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh | bash
```

## 目次

- [何を解決するか](#何を解決するか)
- [Steam Deck プレイヤー向けの説明](#steam-deck-プレイヤー向けの説明)
- [原則](#原則)
- [モジュール](#モジュール)
- [アーキテクチャ](#アーキテクチャ)
- [クイックスタート](#クイックスタート)
- [何をどこに置くか](#何をどこに置くか)
- [検証結果](#検証結果)
- [VMware で SteamOS を動かす](#vmware-で-steamos-を動かす)
- [ドキュメント](#ドキュメント)
- [リポジトリ構成](#リポジトリ構成)
- [ロードマップ](#ロードマップ)
- [作者](#作者)

---

## 何を解決するか

SteamOS の「自分で変えたもの」には性質のまったく違う 2 種類があり、OS アップデートは両者を別々に扱います。

| | 自分のアカウント: ゲームと個人設定 | `sudo` で OS 自体を変更したもの |
| --- | --- | --- |
| 例 | Steam のゲームとセーブ、Discover で入れたアプリ、壁紙、ショートカット、コントローラー配置 | `pacman` で入れたプログラム、システムサービス、ドライバー、`/etc` の編集 |
| 保存場所 | `/home` | システム領域（`/usr`、`/etc` の大部分） |
| OS アップデート後 | **残る** | **消える** — Valve の新しいイメージに置き換わる |
| 初期化後 | 消える | 消える |

> [!NOTE]
> 目安: **sudo のパスワードを入力して変えたものは、たいてい次のアップデートで消えます。** ゲームとセーブは問題ありません。`/home` にあるのでアップデート後も残ります。

SteamOS-Unattended は右側の列の問題を 2 つの方法で解決します。

1. **アップデートを生き残る** — システム領域には一切手を加えません。アプリはユーザー単位の Flatpak、コマンドラインツールは `/home` のコンテナに入れ、本当に必要な `/etc` ファイルだけを SteamOS 自身の保持リストに登録します。
2. **初期化後に作り直す** — 構成全体を設定ファイルで宣言しているので、初期化した Deck や新しい Deck でもコマンド 1 行で同じ環境に戻ります。

## Steam Deck プレイヤー向けの説明

ゲームモードで遊ぶだけなら、このプロジェクトは **不要です。** **デスクトップモード** も使っていて、毎回のセットアップに疲れた人のためのものです。

| 実行すると | 実感できる変化 |
| --- | --- |
| ゲームモード | 何も変わらない — ゲーム、セーブ、コントローラー配置はそのまま |
| デスクトップモードのアプリ | アプリメニューに Flatseal、VLC、Discord が追加（一覧は自由に編集可） |
| 韓国語入力 | デスクトップモードで Ctrl+Space によりハングルに切り替え |
| コマンドラインツール | `devbox`、`netkit` のツールボックス — ターミナルを使わないなら気にしなくてよい |
| バックアップ | 毎晩、設定が `~/Backups` にバックアップされる |
| SteamOS アップデート後 | 上記はすべてそのまま残る |
| 初期化後 | 同じ 1 行をもう一度貼り付けるだけ |

> [!IMPORTANT]
> このプロジェクトはゲームやセーブファイルを **バックアップしません。** ゲームファイルはもともとアップデート後も残り、セーブは Steam クラウドが担います。

## 原則

| 原則 | 意味 | 根拠 |
| --- | --- | --- |
| **無人** | 質問なしで一度に終わる | 1 回目: 変更 18 件、sudo 入力は 1 回 |
| **冪等** | 何回実行しても結果は同じ。済んだ作業は飛ばす | 2 回目: **変更 0 件** |
| **アップデートに強い** | システム領域（`/usr`）には触れない | 成果物はすべて `/home` か保持リストに登録した `/etc` ファイル |

## モジュール

| モジュール | 内容 | 書き込み先 | sudo |
| --- | --- | --- | :---: |
| `00-preflight` | SteamOS のバージョン、ネットワーク、空き容量を確認 | — | |
| `10-flatpak` | `config/flatpaks.txt` のアプリをユーザー単位でインストール | `~/.local/share/flatpak` | |
| `20-dotfiles` | `dotfiles/` を `$HOME` にコピー（差分があれば先にバックアップ） | `$HOME` | |
| `30-distrobox` | `config/distrobox.ini` のコンテナを作成（`devbox`、`netkit`） | podman のユーザーストレージ | |
| `40-korean-input` | fcitx5 + ハングルを導入し KDE の入力メソッドを設定（Ctrl+Space） | `~/.config`、`~/.var` | |
| `50-backup` | systemd ユーザータイマーで毎日設定をバックアップ、直近 7 件を保持 | `~/Backups` | |
| `60-etc-keep` | アップデート後も残す `/etc` ファイルを登録 | `/etc/atomic-update.conf.d/` | ✓ |

## アーキテクチャ

```mermaid
flowchart TD
    I[install.sh] --> P{profile}
    P -->|minimal| M1[10-flatpak · 20-dotfiles]
    P -->|full| M2[00 → 60 all modules]
    I --> L[lib/common.sh<br/>log · dry-run · changed/skipped]
    C[(config/*.txt · *.ini · *.conf)] --> M2
    M2 --> H["/home<br/>Flatpak --user · distrobox · dotfiles · timers"]
    M2 --> E["/etc/atomic-update.conf.d<br/>keep list"]
    U[SteamOS update] -. replaces .-> R["/usr (read-only)"]
    U -. keeps .-> H
    U -. keeps listed .-> E
```

## クイックスタート

```bash
git clone https://github.com/jongwooish/SteamOS-Unattended.git
cd SteamOS-Unattended

./install.sh --list                 # profiles and modules
./install.sh --dry-run              # preview only, changes nothing
./install.sh                        # minimal: apps + dotfiles
./install.sh --profile full         # full: every module
```

| 変えたいもの | 編集するファイル |
| --- | --- |
| アプリ | [`config/flatpaks.txt`](../config/flatpaks.txt) |
| コンテナ | [`config/distrobox.ini`](../config/distrobox.ini) |
| バックアップ対象 | [`config/backup.conf`](../config/backup.conf) |
| 残す `/etc` ファイル | [`config/etc-keep.conf`](../config/etc-keep.conf) |

> [!TIP]
> ログは `~/.local/state/steamos-unattended/install.log` に書き込まれます。

## 何をどこに置くか

SteamOS のシステムは A/B の 2 組で、home だけが共有です。詳しい調査は [ファイルシステム](../docs/05-Filesystem/README/README.ja.md) にあります。

| 場所 | アップデート後 | このプロジェクトでは |
| --- | --- | --- |
| `/usr` | 置き換えられる | 触らない |
| `/etc` | 保持リストのファイルだけ残る | 必要最小限 + 保持リストに登録 |
| `/home` | 残る（A/B 共有パーティション） | アプリ、設定、コンテナ、ログ、バックアップすべて |

## 検証結果

VMware Workstation に SteamOS 3.8.14 をクリーンインストールした状態でテストしました。

| 項目 | 結果 |
| --- | --- |
| 1 回目 | 変更 18 件、失敗 0 件 |
| 2 回目 | **変更 0 件**、実行済み 19 件 |
| コンテナ | `netkit`: `nmap 7.95`、`devbox`: `git 2.56.1` |
| バックアップ | 手動バックアップと **深夜 0 時の自動バックアップ** が動作 |
| ハングル入力 | 再ログイン後、Ctrl+Space で入力可能 |

<table>
<tr>
<td><img src="../docs/03-Configuration/06-Run-Unattended/images/first-run.png" alt="1 回目の実行"/><br/><sub>1 回目: 変更 18 件</sub></td>
<td><img src="../docs/03-Configuration/06-Run-Unattended/images/second-run.png" alt="2 回目の実行"/><br/><sub>2 回目: 変更 0 件</sub></td>
</tr>
<tr>
<td><img src="../docs/03-Configuration/06-Run-Unattended/images/containers-backup.png" alt="コンテナとバックアップ"/><br/><sub>コンテナと自動バックアップ</sub></td>
<td><img src="../docs/03-Configuration/06-Run-Unattended/images/korean-input.png" alt="ハングル入力"/><br/><sub>デスクトップモードでのハングル入力</sub></td>
</tr>
</table>

## VMware で SteamOS を動かす

テストマシン作りそのものが一つのプロジェクトでした。カーネルに VMware のグラフィックドライバー（`vmwgfx`）が含まれていないため、**SteamOS 3.x は VMware では画面がまったく表示されません。**

- Valve カーネルと完全に一致するヘッダーで **vmwgfx をツリー外ビルド** しました。
- Valve カーネルにない 2 つの関数を **互換パッチ**（[`compat_dirty.h`](../vmware/compat_dirty.h)）で置き換えました。
- VMware の仮想 NVMe が拒否する `nvme format` を **インストーラーのコピー** で回避しました。
- `/etc` と `/home` だけで、起動時にドライバーを読み込み **デスクトップモードへ自動ログイン** させました。

> [!NOTE]
> 全手順は [構成](../docs/03-Configuration/README/README.ja.md) に、途中で出会った 15 の問題は [トラブルシューティング](../docs/04-Troubleshooting/README/README.ja.md) にスクリーンショット付きでまとめています。

## ドキュメント

| ドキュメント | 内容 |
| --- | --- |
| [ダウンロード](../docs/01-Downloads/README/README.ja.md) | 必要なファイル、公式リンク、検証済みバージョン |
| [注意事項](../docs/02-Cautions/README/README.ja.md) | 実行前に知っておくこと |
| [構成](../docs/03-Configuration/README/README.ja.md) | VM の作成から検証済みの実行までの 6 ステップ |
| [トラブルシューティング](../docs/04-Troubleshooting/README/README.ja.md) | 症状別の原因と対処 15 件 |
| [ファイルシステム](../docs/05-Filesystem/README/README.ja.md) | アップデートで消えるもの、残るもの |

## リポジトリ構成

```text
install.sh              エントリーポイント（必要ならリポジトリを取得して再実行）
lib/common.sh           ログ、dry-run、変更/スキップの集計
lib/su-backup.sh        バックアップスクリプト（タイマーが実行）
modules/                番号順に実行される 7 つのモジュール
config/                 アプリ一覧、コンテナ定義、バックアップ設定、/etc 保持リスト
profiles/               minimal、full
dotfiles/               $HOME にコピーする個人設定
systemd/                バックアップタイマーのユニット
tests/vm-test.ps1       VMware スナップショットの自動テスト（Windows）
vmware/                 VMware 専用ファイル（ドライバーパッチ、サービス、自動ログイン）
docs/                   ダウンロード、注意事項、構成、トラブルシューティング、ファイルシステム
.github/workflows/      個人情報チェック CI
```

## ロードマップ

- [ ] 実際の SteamOS アップデート後に残ることを検証
- [ ] 実機の Steam Deck で検証
- [ ] モジュール追加: Decky Loader、エミュレーター設定
- [x] 6 言語のドキュメント

## 作者

**Jongwoo Yun** · [@jongwooish](https://github.com/jongwooish)
