#!/usr/bin/env bash
# 데스크톱 모드 한글 입력: fcitx5(Flatpak) + 한글 애드온을 설치하고
# KDE(Wayland)의 가상 키보드(입력기)로 지정한다.
# 전환 키: 한/영 키 또는 Ctrl+Space

FCITX=org.fcitx.Fcitx5
HANGUL=org.fcitx.Fcitx5.Addon.Hangul
rc=0

# 1) 설치 (시스템/사용자 어느 쪽이든 있으면 건너뜀)
for app in "$FCITX" "$HANGUL"; do
    if flatpak info "$app" >/dev/null 2>&1; then
        skipped "$app"
    elif run flatpak install --user --noninteractive -y flathub "$app"; then
        changed "$app 설치"
    else
        failed "$app 설치 실패"; return 1
    fi
done

# 2) fcitx5 입력기 목록: 영어(us) + 한글
PROFILE_DIR="$HOME/.var/app/$FCITX/config/fcitx5"
PROFILE_FILE="$PROFILE_DIR/profile"
WANT_PROFILE='[Groups/0]
Name=Default
Default Layout=us
DefaultIM=hangul

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=hangul
Layout=

[GroupOrder]
0=Default'

if [[ -f "$PROFILE_FILE" ]] && grep -q '^Name=hangul' "$PROFILE_FILE"; then
    skipped "fcitx5 입력기 목록(한글 포함)"
elif [[ "$DRY_RUN" == "1" ]]; then
    run "write $PROFILE_FILE"
    changed "fcitx5 입력기 목록에 한글 추가"
else
    mkdir -p "$PROFILE_DIR" && printf '%s\n' "$WANT_PROFILE" > "$PROFILE_FILE" \
        && _log_file "EXEC    write $PROFILE_FILE" \
        && changed "fcitx5 입력기 목록에 한글 추가" \
        || { failed "fcitx5 프로필 쓰기 실패"; rc=1; }
fi

# 3) KDE Wayland 입력기로 지정 (설정 > 키보드 > 가상 키보드 와 같은 설정)
DESKTOP_FILE=""
for d in "$HOME/.local/share/flatpak/exports/share/applications" \
         "/var/lib/flatpak/exports/share/applications"; do
    [[ -f "$d/$FCITX.desktop" ]] && { DESKTOP_FILE="$d/$FCITX.desktop"; break; }
done
[[ -z "$DESKTOP_FILE" && "$DRY_RUN" == "1" ]] && \
    DESKTOP_FILE="$HOME/.local/share/flatpak/exports/share/applications/$FCITX.desktop"

if [[ -z "$DESKTOP_FILE" ]]; then
    failed "fcitx5 바로가기 파일을 찾지 못함"; return 1
fi

if ! command -v kwriteconfig6 >/dev/null 2>&1; then
    log_warn "kwriteconfig6 가 없어 KDE 입력기 지정을 건너뜁니다 (데스크톱 설정에서 직접 지정)"
else
    cur="$(kreadconfig6 --file kwinrc --group Wayland --key InputMethod 2>/dev/null)"
    if [[ "$cur" == "$DESKTOP_FILE" ]]; then
        skipped "KDE 입력기 = fcitx5"
    elif run kwriteconfig6 --file kwinrc --group Wayland --key InputMethod "$DESKTOP_FILE"; then
        changed "KDE 입력기를 fcitx5 로 지정 (다음 로그인부터 적용)"
    else
        failed "KDE 입력기 지정 실패"; rc=1
    fi
fi

# 4) Xwayland(X11) 앱용 환경 변수
ENV_FILE="$HOME/.config/environment.d/90-fcitx5.conf"
WANT_ENV='XMODIFIERS=@im=fcitx'
if [[ -f "$ENV_FILE" ]] && grep -qxF "$WANT_ENV" "$ENV_FILE"; then
    skipped "XMODIFIERS 환경 변수"
elif [[ "$DRY_RUN" == "1" ]]; then
    run "write $ENV_FILE"
    changed "XMODIFIERS 환경 변수 설정"
else
    mkdir -p "$(dirname "$ENV_FILE")" && printf '%s\n' "$WANT_ENV" > "$ENV_FILE" \
        && _log_file "EXEC    write $ENV_FILE" \
        && changed "XMODIFIERS 환경 변수 설정" \
        || { failed "환경 변수 파일 쓰기 실패"; rc=1; }
fi

return $rc
