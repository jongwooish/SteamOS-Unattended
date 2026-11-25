#!/usr/bin/env bash
# su-backup: ~/.config/steamos-unattended/backup.conf 에 적힌 경로를 묶어서 보관
# systemd 사용자 타이머(su-backup.timer)가 매일 실행한다. 직접 실행해도 된다.
set -euo pipefail

CONF="${1:-$HOME/.config/steamos-unattended/backup.conf}"
BACKUP_DEST="$HOME/Backups"
BACKUP_KEEP=7
BACKUP_PATHS=()
# shellcheck source=/dev/null
source "$CONF"

mkdir -p "$BACKUP_DEST"
cd "$HOME"

existing=()
for p in "${BACKUP_PATHS[@]}"; do
    [[ -e "$p" ]] && existing+=("$p")
done
if [[ ${#existing[@]} -eq 0 ]]; then
    echo "백업할 경로가 없습니다"; exit 0
fi

out="$BACKUP_DEST/backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar --warning=no-file-changed -czf "$out" "${existing[@]}"
echo "백업 완료: $out ($(du -h "$out" | cut -f1))"

# 오래된 백업 정리: 최근 BACKUP_KEEP 개만 남김
ls -1t "$BACKUP_DEST"/backup-*.tar.gz 2>/dev/null | tail -n +$((BACKUP_KEEP + 1)) | xargs -r rm -f
