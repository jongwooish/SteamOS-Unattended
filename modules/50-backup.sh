#!/usr/bin/env bash
# 자동 백업: config/backup.conf 의 경로를 매일 tar.gz 로 묶어 보관한다.
# systemd 사용자 타이머로 돌리므로 /home 에만 파일이 생기고 업데이트에도 남는다.

CONF="$ROOT/config/backup.conf"
[[ -f "$CONF" ]] || { failed "설정 파일 없음: $CONF"; return 1; }

BIN_DST="$HOME/.local/bin/su-backup"
CONF_DST="$HOME/.config/steamos-unattended/backup.conf"
UNIT_DIR="$HOME/.config/systemd/user"
rc=0

# 파일 하나를 "내용이 다를 때만" 복사하는 도우미
install_file() {   # install_file <원본> <대상> <설명>
    if [[ -f "$2" ]] && cmp -s "$1" "$2"; then
        skipped "$3"
    elif run mkdir -p "$(dirname "$2")" && run cp "$1" "$2"; then
        changed "$3"
        UNITS_CHANGED=1
    else
        failed "$3 복사 실패"; rc=1
    fi
}

UNITS_CHANGED=0
install_file "$ROOT/lib/su-backup.sh"            "$BIN_DST"                       "백업 스크립트 ~/.local/bin/su-backup"
[[ "$DRY_RUN" == "1" ]] || chmod +x "$BIN_DST" 2>/dev/null
install_file "$CONF"                             "$CONF_DST"                      "백업 설정 ~/.config/steamos-unattended/backup.conf"
install_file "$ROOT/systemd/su-backup.service"   "$UNIT_DIR/su-backup.service"    "systemd 유닛 su-backup.service"
install_file "$ROOT/systemd/su-backup.timer"     "$UNIT_DIR/su-backup.timer"      "systemd 유닛 su-backup.timer"

if [[ "$UNITS_CHANGED" == "1" ]]; then
    run systemctl --user daemon-reload || log_warn "daemon-reload 실패 (다음 로그인 때 반영)"
fi

if systemctl --user is-enabled su-backup.timer >/dev/null 2>&1 \
   && systemctl --user is-active su-backup.timer >/dev/null 2>&1; then
    skipped "백업 타이머 활성화"
elif run systemctl --user enable --now su-backup.timer; then
    changed "백업 타이머 활성화 (매일)"
else
    failed "백업 타이머 활성화 실패"; rc=1
fi

return $rc
