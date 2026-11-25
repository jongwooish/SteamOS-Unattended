#!/usr/bin/env bash
# /etc 유지 목록: SteamOS 업데이트(A/B 교체) 때 지켜야 할 /etc 파일을 등록한다.
# 이 레포에서 유일하게 sudo 가 필요한 모듈이라 마지막에 둔다.
# 비밀번호 없이 sudo 가 안 되고 터미널도 아니면(무인 실행) 건너뛴다.

SRC="$ROOT/config/etc-keep.conf"
DST="/etc/atomic-update.conf.d/steamos-unattended.conf"
[[ -f "$SRC" ]] || { failed "목록 파일 없음: $SRC"; return 1; }

# 주석과 빈 줄을 뺀 실제 목록
WANT="$(grep -vE '^\s*(#|$)' "$SRC")"

if [[ -f "$DST" ]] && [[ "$(cat "$DST")" == "$WANT" ]]; then
    skipped "/etc 유지 목록"
    return 0
fi

if [[ "$DRY_RUN" == "1" ]]; then
    run "sudo write $DST"
    changed "/etc 유지 목록 등록 ($(echo "$WANT" | wc -l)개 경로)"
    return 0
fi

if ! sudo -n true 2>/dev/null; then
    if [[ -t 0 ]]; then
        log_info "/etc 에 쓰려면 deck 비밀번호가 필요해요"
        sudo -v || { failed "sudo 인증 실패"; return 1; }
    else
        log_warn "sudo 비밀번호가 필요해서 /etc 유지 목록을 건너뜁니다 (터미널에서 다시 실행)"
        return 0
    fi
fi

if printf '%s\n' "$WANT" | sudo tee "$DST" >/dev/null; then
    _log_file "EXEC    sudo tee $DST"
    changed "/etc 유지 목록 등록 ($(echo "$WANT" | wc -l)개 경로)"
else
    failed "/etc 유지 목록 쓰기 실패"
    return 1
fi
