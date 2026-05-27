#!/usr/bin/env bash
# Claude Workflows 설치 스크립트 (macOS / Linux)
#
# 사용법 1 — 저장소 clone 후:
#   git clone https://github.com/jaeyeoloh/claude-workflows
#   bash claude-workflows/setup.sh
#
# 사용법 2 — curl 한 줄 (저장소 최신본을 바로 설치):
#   bash <(curl -fsSL https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main/setup.sh)

set -e

CLAUDE_DIR="$HOME/.claude"
REPO="https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main"

# ── 실행 위치 감지: clone된 폴더 안인지, curl 직접 실행인지 ─────────────────
if [ -f "$(dirname "$0")/commands/new-project.md" ]; then
  # 저장소 clone 후 실행
  SRC="$(cd "$(dirname "$0")" && pwd)"
  USE_LOCAL=true
else
  # curl로 직접 실행 — GitHub에서 파일 다운로드
  USE_LOCAL=false
fi

echo ""
echo "🤖  Claude Workflows 설치"
echo "─────────────────────────────"

install_file() {
  local rel_path="$1"   # 저장소 내 상대 경로 (예: commands/new-project.md)
  local dest="$2"        # 설치 대상 경로
  local label="$3"       # 로그에 표시할 이름

  if [ -f "$dest" ]; then
    echo "  ⏭  $label (이미 존재 — 건너뜀)"
    return
  fi

  mkdir -p "$(dirname "$dest")"

  if [ "$USE_LOCAL" = true ]; then
    cp "$SRC/$rel_path" "$dest"
  else
    curl -fsSL "$REPO/$rel_path" -o "$dest"
  fi

  echo "  ✅  $label"
}

# ── 커맨드 설치 ──────────────────────────────────────────────────────────────
echo ""
echo "📌 슬래시 커맨드"

if [ "$USE_LOCAL" = true ]; then
  for file in "$SRC/commands/"*.md; do
    name=$(basename "$file")
    install_file "commands/$name" "$CLAUDE_DIR/commands/$name" "/$( basename "$name" .md)"
  done
else
  install_file "commands/new-project.md" "$CLAUDE_DIR/commands/new-project.md" "/new-project"
fi

# ── 템플릿 설치 ──────────────────────────────────────────────────────────────
echo ""
echo "📋 템플릿"

install_file "templates/platform-playbook.md" \
  "$CLAUDE_DIR/templates/platform-playbook.md" \
  "platform-playbook.md → ~/.claude/templates/"

install_file "templates/CLAUDE.md" \
  "$CLAUDE_DIR/CLAUDE.md" \
  "CLAUDE.md → ~/.claude/ (글로벌 행동 규칙)"

# ── settings.json (auto mode) ────────────────────────────────────────────────
echo ""
echo "⚙️  설정"

SETTINGS="$CLAUDE_DIR/settings.json"
if [ -f "$SETTINGS" ]; then
  echo "  ⏭  settings.json (이미 존재 — 건너뜀)"
else
  mkdir -p "$CLAUDE_DIR"
  printf '{\n  "permissions": {\n    "defaultMode": "auto"\n  }\n}\n' > "$SETTINGS"
  echo "  ✅  settings.json (auto mode 활성화)"
fi

# ── 완료 ─────────────────────────────────────────────────────────────────────
echo ""
echo "─────────────────────────────"
echo "🎉  설치 완료! Claude Code를 재시작하면 적용됩니다."
echo ""
echo "사용 가능한 커맨드:"
for f in "$CLAUDE_DIR/commands/"*.md; do
  [ -f "$f" ] && echo "  /$(basename "$f" .md)"
done
echo ""
