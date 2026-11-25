#!/usr/bin/env bash
# 컨테이너 환경: config/distrobox.ini 에 선언한 distrobox 컨테이너를 만든다.
# 컨테이너는 /home 아래(podman 사용자 저장소)에 저장되므로 SteamOS 업데이트에도 남는다.

INI="$ROOT/config/distrobox.ini"
[[ -f "$INI" ]] || { failed "선언 파일 없음: $INI"; return 1; }
need_cmd distrobox || return 1
need_cmd podman    || return 1

# rootless podman 은 /etc/subuid 에 사용자 항목이 있어야 동작한다
if ! grep -q "^$(id -un):" /etc/subuid 2>/dev/null; then
    log_warn "/etc/subuid 에 $(id -un) 항목이 없어 컨테이너 생성이 실패할 수 있습니다"
fi

rc=0
# ini 의 [이름] 섹션을 하나씩 확인해서 없는 컨테이너만 만든다
while IFS= read -r name; do
    if podman container exists "$name" 2>/dev/null; then
        skipped "컨테이너 $name"
        continue
    fi
    log_info "컨테이너 $name 생성 중 (이미지를 받느라 몇 분 걸릴 수 있어요)"
    if run distrobox assemble create --file "$INI" --name "$name"; then
        changed "컨테이너 $name 생성"
    else
        failed "컨테이너 $name 생성 실패"
        rc=1
    fi
done < <(sed -n 's/^\[\([^]]*\)\].*/\1/p' "$INI")

return $rc
