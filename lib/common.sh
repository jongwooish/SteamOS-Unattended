#!/usr/bin/env bash
# 모든 모듈이 같이 쓰는 함수: 로그, dry-run, 변경/건너뜀 집계
#
# 모듈 작성 규칙
#   1. 바꾸기 전에 "이미 되어 있나?"를 먼저 확인하고, 되어 있으면 skipped 를 부른다.
#   2. 실제로 바꾸는 명령은 run 으로 감싼다. (dry-run 이면 출력만 한다)
#   3. 바꿨으면 changed, 실패했으면 failed 를 부르고 return 1 한다.

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/steamos-unattended"
LOG_FILE="$STATE_DIR/install.log"
COUNT_DIR="$STATE_DIR/run"
DRY_RUN="${DRY_RUN:-0}"

if [[ -t 1 ]]; then
    C_RESET=$'\e[0m'; C_BOLD=$'\e[1m'; C_GREEN=$'\e[32m'
    C_YELLOW=$'\e[33m'; C_RED=$'\e[31m'; C_BLUE=$'\e[34m'; C_DIM=$'\e[2m'
else
    C_RESET=""; C_BOLD=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_BLUE=""; C_DIM=""
fi

_ts() { date '+%Y-%m-%d %H:%M:%S'; }

_log_file() {
    mkdir -p "$STATE_DIR"
    printf '%s %s\n' "$(_ts)" "$*" >> "$LOG_FILE"
}

# install.sh 가 실행 시작할 때 한 번만 부른다. 이번 실행의 집계를 0으로 만든다.
log_init() {
    mkdir -p "$STATE_DIR" "$COUNT_DIR"
    : > "$COUNT_DIR/changed"
    : > "$COUNT_DIR/skipped"
    : > "$COUNT_DIR/failed"
    _log_file "======== RUN START (dry_run=$DRY_RUN) ========"
}

_count() { mkdir -p "$COUNT_DIR"; echo "$1" >> "$COUNT_DIR/$2"; }

log_head()    { printf '\n%s:: %s%s\n' "$C_BOLD$C_BLUE" "$*" "$C_RESET"; _log_file "HEAD    $*"; }
log_info()    { printf '   %s\n' "$*"; _log_file "INFO    $*"; }
log_warn()    { printf '   %s! %s%s\n' "$C_YELLOW" "$*" "$C_RESET"; _log_file "WARN    $*"; }
log_fail()    { printf '   %sx %s%s\n' "$C_RED" "$*" "$C_RESET"; _log_file "FAIL    $*"; }

# 이미 원하는 상태라서 아무것도 안 함
skipped() {
    printf '   %s- %s (이미 됨)%s\n' "$C_DIM" "$*" "$C_RESET"
    _log_file "SKIPPED $*"
    _count "$*" skipped
}

# 상태를 바꿈 (dry-run 이면 "바꿀 예정")
changed() {
    if [[ "$DRY_RUN" == "1" ]]; then
        printf '   %s~ %s (dry-run: 할 예정)%s\n' "$C_YELLOW" "$*" "$C_RESET"
        _log_file "WOULD   $*"
    else
        printf '   %s+ %s%s\n' "$C_GREEN" "$*" "$C_RESET"
        _log_file "CHANGED $*"
    fi
    _count "$*" changed
}

failed() {
    log_fail "$*"
    _count "$*" failed
}

# 상태를 바꾸는 명령 실행. dry-run 이면 명령만 출력하고 성공으로 친다.
run() {
    if [[ "$DRY_RUN" == "1" ]]; then
        printf '   %s$ %s%s\n' "$C_DIM" "$*" "$C_RESET"
        _log_file "DRYRUN  $*"
        return 0
    fi
    _log_file "EXEC    $*"
    local out rc
    out="$("$@" 2>&1)"; rc=$?
    [[ -n "$out" ]] && printf '%s\n' "$out" >> "$LOG_FILE"
    if [[ $rc -ne 0 ]]; then
        _log_file "EXIT    $rc"
        printf '%s\n' "$out" | tail -5 | sed 's/^/     /'
    fi
    return $rc
}

need_cmd() {
    command -v "$1" >/dev/null 2>&1 || { failed "필요한 명령이 없음: $1"; return 1; }
}

is_steamos() {
    [[ -r /etc/os-release ]] && grep -q '^ID=steamos' /etc/os-release
}

summary() {
    local c s f
    c=$(wc -l < "$COUNT_DIR/changed" 2>/dev/null || echo 0)
    s=$(wc -l < "$COUNT_DIR/skipped" 2>/dev/null || echo 0)
    f=$(wc -l < "$COUNT_DIR/failed"  2>/dev/null || echo 0)
    log_head "요약"
    if [[ "$DRY_RUN" == "1" ]]; then
        log_info "할 예정 ${c}건 / 이미 됨 ${s}건 / 실패 ${f}건 (dry-run: 아무것도 바꾸지 않음)"
    else
        log_info "변경 ${c}건 / 이미 됨 ${s}건 / 실패 ${f}건"
    fi
    _log_file "SUMMARY changed=$c skipped=$s failed=$f dry_run=$DRY_RUN"
}
