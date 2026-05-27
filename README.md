# claude-workflows

Claude Code 슬래시 커맨드 & 워크플로우 템플릿 **라이브러리(보관소)**.

> **사용 정책:** 이 저장소의 커맨드는 글로벌(`~/.claude/commands/`)로 자동 설치하지 않습니다.
> 필요한 프로젝트의 `<프로젝트>/.claude/commands/` 폴더에 **수동 복사**해서 사용합니다.
> 프로젝트마다 컨텍스트가 다르므로, 어떤 커맨드를 쓸지 프로젝트별로 의도적으로 선택합니다.

새 프로젝트 시작, 플랫폼 기획, 외주 개발에 사용할 수 있는 슬래시 커맨드와 플레이북을 모아둡니다.

---

## 워크스페이스 구조 요구사항

이 라이브러리의 커맨드(`/new-project` 등)는 다음 폴더 구조를 전제로 합니다:

```
<workspace>/                  # 예: ~/dev/, ~/Desktop/projects/, ~/work/
├── own/                      # 자체 프로젝트
├── outsourcing/              # 외주 프로젝트 (클라이언트별 하위 폴더)
├── shared/                   # 자체+외주가 공유하는 코드 패키지
└── claude-workflows/         # 이 저장소
```

- `own/`과 `outsourcing/`은 분류 폴더. 각각 하위에 실제 프로젝트 폴더가 들어갑니다.
- `shared/`는 카카오 OAuth, 토스페이먼츠, 한국 도메인 유틸 등 디자인 무관 재사용 로직 보관소.
- 워크스페이스 루트 이름은 자유 (`projects`, `dev`, `work` 등). 4개 폴더 중 **2개 이상**이 같은 부모에 있으면 자동 감지됩니다.

전체 패턴이 없어도 `/new-project`는 단순 모드(워크스페이스 = cwd, own/outsourcing 분기 없음)로 동작합니다. 다만 협업/재사용 가치는 떨어집니다.

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
