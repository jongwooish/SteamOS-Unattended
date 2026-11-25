#!/usr/bin/env bash
# 사전 점검: 바꾸는 건 없고, 계속 진행해도 되는지만 확인한다.

if is_steamos; then
    ver="$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2)"
    log_info "SteamOS $ver"
else
    log_warn "SteamOS가 아닙니다. 테스트 목적이 아니라면 중단하세요."
fi

if command -v steamos-readonly >/dev/null 2>&1; then
    log_info "시스템 영역 읽기 전용: $(steamos-readonly status 2>/dev/null || echo '알 수 없음')"
fi

need_cmd flatpak || return 1
need_cmd curl    || return 1

if curl -fsI --max-time 10 https://dl.flathub.org >/dev/null 2>&1; then
    log_info "네트워크: Flathub 연결 OK"
else
    failed "Flathub(dl.flathub.org)에 연결할 수 없음"
    return 1
fi

avail_mb=$(df -Pm "$HOME" | awk 'NR==2 {print $4}')
if [[ "${avail_mb:-0}" -lt 2048 ]]; then
    log_warn "home 여유 공간이 ${avail_mb}MB 입니다 (2GB 이상 권장)"
else
    log_info "home 여유 공간: ${avail_mb}MB"
fi
