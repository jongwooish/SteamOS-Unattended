#!/usr/bin/env bash
# Flatpak 앱 설치: config/flatpaks.txt 에 적힌 앱을 사용자 영역(--user)에 설치한다.
# 사용자 영역은 /home 에 저장되므로 SteamOS 업데이트에도 남는다.

LIST="$ROOT/config/flatpaks.txt"
[[ -f "$LIST" ]] || { failed "목록 파일 없음: $LIST"; return 1; }

# 1) 사용자 영역에 flathub 저장소 등록
if flatpak remotes --user --columns=name 2>/dev/null | grep -qx flathub; then
    skipped "flathub 저장소(--user)"
else
    run flatpak remote-add --user --if-not-exists flathub \
        https://dl.flathub.org/repo/flathub.flatpakrepo \
        && changed "flathub 저장소(--user) 등록" \
        || { failed "flathub 저장소 등록 실패"; return 1; }
fi

# 2) 앱 설치
rc=0
while IFS= read -r line || [[ -n "$line" ]]; do
    app="${line%%#*}"                 # 주석 제거
    app="$(echo "$app" | xargs)"       # 앞뒤 공백 제거
    [[ -z "$app" ]] && continue

    # 시스템 영역이든 사용자 영역이든 이미 깔려 있으면 건너뛴다
    if flatpak info "$app" >/dev/null 2>&1; then
        skipped "$app"
        continue
    fi

    if run flatpak install --user --noninteractive -y flathub "$app"; then
        changed "$app 설치"
    else
        failed "$app 설치 실패"
        rc=1
    fi
done < "$LIST"

return $rc
