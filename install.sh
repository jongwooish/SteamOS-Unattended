#!/usr/bin/env bash
# steamos-unattended: SteamOS 무인 세팅 스크립트
#
# 사용법:
#   ./install.sh [--profile 이름] [--dry-run] [--list]
#
#   --profile 이름   profiles/<이름>.conf 를 사용 (기본값: minimal)
#   --dry-run        실제로 바꾸지 않고 무엇을 할지만 출력
#   --list           사용 가능한 프로필과 모듈 목록 출력
#
# 원격 실행 (레포를 받지 않은 상태에서):
#   curl -fsSL https://raw.githubusercontent.com/jongwooish/SteamOS-Unattended/main/install.sh | bash -s -- --profile minimal

set -uo pipefail

REPO="${SU_REPO:-jongwooish/SteamOS-Unattended}"
BRANCH="${SU_BRANCH:-main}"

# ---------------------------------------------------------------------------
# 0. 레포 파일이 옆에 없으면(curl | bash 로 실행된 경우) 레포를 받아서 다시 실행
# ---------------------------------------------------------------------------
SCRIPT_PATH="${BASH_SOURCE[0]:-}"
if [[ -n "$SCRIPT_PATH" && -f "$SCRIPT_PATH" ]]; then
    ROOT="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
else
    ROOT=""
fi

if [[ -z "$ROOT" || ! -f "$ROOT/lib/common.sh" ]]; then
    DEST="$HOME/.local/share/steamos-unattended"
    echo ":: 레포 파일을 $DEST 에 받는 중 ($REPO@$BRANCH)"
    mkdir -p "$DEST"
    if ! curl -fsSL "https://github.com/$REPO/archive/refs/heads/$BRANCH.tar.gz" \
        | tar -xz -C "$DEST" --strip-components=1; then
        echo "!! 레포를 받지 못했습니다. 네트워크와 REPO 이름을 확인하세요." >&2
        exit 1
    fi
    exec bash "$DEST/install.sh" "$@"
fi

# shellcheck source=lib/common.sh
source "$ROOT/lib/common.sh"

# ---------------------------------------------------------------------------
# 1. 인자 처리
# ---------------------------------------------------------------------------
PROFILE="minimal"
LIST_ONLY=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile)  PROFILE="${2:-}"; shift 2 ;;
        --profile=*) PROFILE="${1#*=}"; shift ;;
        --dry-run)  DRY_RUN=1; shift ;;
        --list)     LIST_ONLY=1; shift ;;
        -h|--help)  sed -n '2,13p' "$0"; exit 0 ;;
        *) echo "!! 알 수 없는 옵션: $1" >&2; exit 2 ;;
    esac
done
export DRY_RUN

if [[ $LIST_ONLY -eq 1 ]]; then
    echo "프로필:"
    for f in "$ROOT"/profiles/*.conf; do echo "  - $(basename "$f" .conf)"; done
    echo "모듈:"
    for f in "$ROOT"/modules/*.sh; do echo "  - $(basename "$f" .sh)"; done
    exit 0
fi

PROFILE_FILE="$ROOT/profiles/$PROFILE.conf"
if [[ ! -f "$PROFILE_FILE" ]]; then
    echo "!! 프로필이 없습니다: $PROFILE ($PROFILE_FILE)" >&2
    exit 2
fi

MODULES=()
# shellcheck source=profiles/minimal.conf
source "$PROFILE_FILE"

# ---------------------------------------------------------------------------
# 2. 모듈 실행
# ---------------------------------------------------------------------------
log_init
log_head "steamos-unattended 시작 (프로필: $PROFILE$( [[ $DRY_RUN -eq 1 ]] && echo ', dry-run'))"

FAILED_MODULES=()
for mod in "${MODULES[@]}"; do
    mod_file="$ROOT/modules/$mod.sh"
    if [[ ! -f "$mod_file" ]]; then
        log_fail "모듈 파일 없음: $mod"
        FAILED_MODULES+=("$mod")
        continue
    fi

    log_head "모듈: $mod"
    # 모듈은 서브셸에서 실행해서, 한 모듈의 실패나 변수가 다른 모듈에 번지지 않게 한다.
    # 카운터는 파일로 주고받는다 (lib/common.sh 참고).
    ( ROOT="$ROOT"; source "$ROOT/lib/common.sh"; source "$mod_file" )
    rc=$?
    if [[ $rc -ne 0 ]]; then
        log_fail "모듈 실패: $mod (종료 코드 $rc)"
        FAILED_MODULES+=("$mod")
    fi
done

# ---------------------------------------------------------------------------
# 3. 요약
# ---------------------------------------------------------------------------
summary
if [[ ${#FAILED_MODULES[@]} -gt 0 ]]; then
    log_fail "실패한 모듈: ${FAILED_MODULES[*]}"
    log_info "로그: $LOG_FILE"
    exit 1
fi
log_info "로그: $LOG_FILE"
exit 0
