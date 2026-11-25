#!/usr/bin/env bash
# 개인 설정 복원: dotfiles/ 아래 파일을 같은 경로로 $HOME 에 복사한다.
#   - 내용이 같으면 건너뛴다
#   - 다른 파일이 이미 있으면 백업한 뒤 덮어쓴다
# 그리고 ~/.bashrc 가 ~/.bash_aliases 를 읽도록 한 줄을 (없을 때만) 추가한다.

SRC_DIR="$ROOT/dotfiles"
BACKUP_DIR="$STATE_DIR/backup/$(date +%Y%m%d-%H%M%S)"

rc=0
if [[ -d "$SRC_DIR" ]]; then
    while IFS= read -r -d '' src; do
        rel="${src#"$SRC_DIR"/}"
        dst="$HOME/$rel"

        if [[ -f "$dst" ]] && cmp -s "$src" "$dst"; then
            skipped "~/$rel"
            continue
        fi

        if [[ -e "$dst" ]]; then
            run mkdir -p "$BACKUP_DIR/$(dirname "$rel")" \
                && run cp -a "$dst" "$BACKUP_DIR/$rel" \
                && log_info "기존 ~/$rel 백업: $BACKUP_DIR/$rel"
        fi

        if run mkdir -p "$(dirname "$dst")" && run cp "$src" "$dst"; then
            changed "~/$rel"
        else
            failed "~/$rel 복사 실패"
            rc=1
        fi
    done < <(find "$SRC_DIR" -type f ! -name '.gitkeep' -print0)
fi

# ~/.bashrc 에서 ~/.bash_aliases 를 읽게 하기 (한 번만)
HOOK='[ -f ~/.bash_aliases ] && . ~/.bash_aliases  # steamos-unattended'
if [[ -f "$HOME/.bashrc" ]] && grep -qxF "$HOOK" "$HOME/.bashrc"; then
    skipped "~/.bashrc 의 bash_aliases 연결"
else
    if [[ "$DRY_RUN" == "1" ]]; then
        run "append to ~/.bashrc: $HOOK"
        changed "~/.bashrc 에 bash_aliases 연결 추가"
    elif printf '\n%s\n' "$HOOK" >> "$HOME/.bashrc"; then
        _log_file "EXEC    append hook to ~/.bashrc"
        changed "~/.bashrc 에 bash_aliases 연결 추가"
    else
        failed "~/.bashrc 수정 실패"
        rc=1
    fi
fi

return $rc
