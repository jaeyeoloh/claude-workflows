# claude-workflows

팀 공용 Claude Code 커맨드 & 워크플로우 템플릿 모음.

새 프로젝트 시작, 플랫폼 기획, 외주 개발에 사용하는 슬래시 커맨드와 플레이북을 관리합니다.

---

## 설치

**macOS / Linux — 한 줄 설치:**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main/setup.sh)
```

**Windows — 한 줄 설치:**
```powershell
irm https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main/setup.ps1 | iex
```

**또는 clone 후 실행:**
```bash
git clone https://github.com/jaeyeoloh/claude-workflows
bash claude-workflows/setup.sh     # macOS/Linux
pwsh claude-workflows/setup.ps1    # Windows
```

> 이미 존재하는 파일은 덮어쓰지 않습니다. 여러 번 실행해도 안전합니다.

---

## 설치 후 사용 가능한 것

### 슬래시 커맨드

| 커맨드 | 설명 |
|--------|------|
| `/new-project` | 새 플랫폼/외주/웹사이트 시작 시 표준 워크플로우 실행 |

### 템플릿

| 파일 | 위치 | 설명 |
|------|------|------|
| `platform-playbook.md` | `~/.claude/templates/` | 아이디어 → 구현 전체 플로우 |
| `CLAUDE.md` | `~/.claude/` | 글로벌 행동 규칙 (프로액티브 제안, 결정 기록) |

### 설정

| 항목 | 내용 |
|------|------|
| `settings.json` | auto mode 활성화 (확인 프롬프트 최소화) |

---

## 업데이트

새 커맨드나 플레이북이 추가되면:

```bash
# clone한 경우
cd claude-workflows && git pull && bash setup.sh

# 직접 설치한 경우 (새 파일만 추가됨, 기존 파일은 유지)
bash <(curl -fsSL https://raw.githubusercontent.com/jaeyeoloh/claude-workflows/main/setup.sh)
```

---

## 커맨드/템플릿 추가하기

1. `commands/` 또는 `templates/`에 `.md` 파일 추가
2. PR 생성 → 머지
3. 팀원들이 `setup.sh`를 다시 실행하면 자동으로 설치

---

## 구조

```
claude-workflows/
├── commands/
│   └── new-project.md       # /new-project 슬래시 커맨드
├── templates/
│   ├── CLAUDE.md            # 글로벌 행동 규칙 템플릿
│   └── platform-playbook.md # 아이디어→구현 플레이북
├── setup.sh                 # macOS/Linux 설치
└── setup.ps1                # Windows 설치
```
