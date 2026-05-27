# /new-project

새 프로젝트(자체/외주, 플랫폼/커뮤니티/SaaS/내부도구 등) 시작 시 표준 워크플로우.

---

## 메타 규칙

- `$ARGUMENTS`에 프로젝트 설명이 있으면 Step 3 응답으로 활용 가능. 단, 다른 정보(소유/유형/타겟/스택)는 여전히 명시적으로 확인.
- **Step 0에서 결정된 언어**가 이후 모든 단계의 질문, 옵션 라벨, 생성 파일(PRD.md, CLAUDE.md, workflow-log.md, README.md 등)의 언어를 결정한다.
- skill.md 파일 자체는 한국어로 유지 — 사용자에게 안 보이는 Claude용 지시문. 영어 모드와 무관.
- 사용자가 이미 답한 정보, 또는 **Step 2 참고 자료에서 추론 가능한 정보**는 해당 step에서 다시 묻지 않는다. 누락된 항목만 진행.
- 경로 표현은 **모두 `<workspace>` 플레이스홀더 기준**. 실제 경로는 아래 워크스페이스 감지 결과로 치환. 절대경로 하드코딩 금지.

---

## 워크스페이스 감지 / Workspace Detection

**Step 0 실행 전, 사용자에게 묻기 전에 먼저 수행한다.** 사용자 인터랙션 없음.

### 감지 절차

1. 현재 cwd부터 시작해 부모 폴더로 올라가며 다음 패턴을 찾는다:
   - 어떤 폴더 X에 `own/`, `outsourcing/`, `shared/`, `claude-workflows/` 중 **2개 이상**이 직속 하위로 존재하면 X를 **워크스페이스 루트** 로 간주.
2. 감지 성공 시 그 경로를 `<workspace>`로 저장하고 이후 모든 경로에서 사용.
3. 감지 실패(루트까지 올라가도 패턴 없음) 시 사용자에게 한 번 묻기:

   > 워크스페이스 구조를 감지하지 못했습니다. `own/`, `outsourcing/`, `shared/`, `claude-workflows/` 폴더들이 위치한 부모 디렉토리 경로를 알려주세요. (없으면 "구조 없음")

4. 사용자가 "구조 없음"으로 답하면 단순 모드로 전환: 현재 cwd를 `<workspace>`로 가정하고 own/outsourcing 분기 없이 `<workspace>/<프로젝트명>/`에 생성.

### 이 패턴이 전제하는 폴더 구조

```
<workspace>/
├── own/              # 자체 프로젝트
├── outsourcing/      # 외주 프로젝트
├── shared/           # 공유 코드 패키지
└── claude-workflows/ # 슬래시 커맨드 라이브러리
```

전체 패턴 미구축 팀원은 `claude-workflows/README.md`의 워크스페이스 셋업 가이드 참조.

---

## Step 0 — 언어 / Language

다음을 양쪽 언어로 묻는다:

> 한국어로 진행할까요? / Continue in English?

선택된 언어로 이후 모든 사용자 대화와 생성 파일을 작성. 이후 단계 설명은 한국어로 적혀 있지만, 영어 모드 선택 시 의미를 영어로 변환해 진행.

---

## Step 1 — 소유 / Ownership

**자체(own)** 또는 **외주(client)** 인지 먼저 확인. 이게 이후 전체 워크플로우(스택 추천 방식, 결정 기록 톤, 저장 위치)를 가른다.

| 구분 | 차이점 | 저장 위치 |
|---|---|---|
| 자체 (own) | 의사결정 자유도 높음. travelmate 검증 스택을 anchor로 제시 가능. workflow-log 자유 형식. | `<workspace>/own/<프로젝트명>/` |
| 외주 (client) | 클라이언트 요구사항/명세 우선. 워크플로우-log를 청구/검토 근거로 활용 가능하게 더 정밀하게 기록. | `<workspace>/outsourcing/<클라이언트>/<프로젝트명>/` |

---

## Step 2 — 참고 자료 확인 / Reference Material Check

소유 결정 후, 사용자에게 참고할 자료가 있는지 먼저 확인. 있으면 **전부 읽고** 이후 step에서 사용자에게 다시 묻지 않아도 되는 정보를 미리 추출한다.

### 사용자에게 묻기

한국어 모드 예시:

> 참고할 자료가 있나요? 폴더 경로나 파일 경로 알려주시면 모두 읽어보고 추론 가능한 정보를 정리해드릴게요.
>
> - 자체 프로젝트: 본인 기획 메모, 아이디어 노트, 이전 프로젝트 자료
> - 외주 프로젝트: 클라이언트 SOW · RFP · 제안서 · 기획서 · 와이어프레임 · 회의록
>
> 없으면 "없음"이라고 답해주세요. 그 경우 이후 단계에서 모든 정보를 직접 받아 진행합니다.

영어 모드 예시:

> Any reference materials? Share a folder or file path and I'll read everything to pre-fill what I can.
>
> - Own project: your own planning notes, idea memos, prior project assets
> - Client project: SOW · RFP · proposal · spec · wireframes · meeting notes
>
> If none, reply "none" and I'll gather all info directly in later steps.

### 읽을 수 있는 파일 형식

- 텍스트: `.md`, `.txt`
- 문서: `.pdf` (큰 파일은 `pages` 옵션으로 분할), `.docx`
- 슬라이드: `.pptx` 또는 `.pdf` 변환본
- 스프레드시트: `.xlsx`, `.csv` (기능 목록 · 사용자 페르소나 등 정형 데이터)
- 이미지: `.png`, `.jpg`, `.jpeg` (와이어프레임 · 화면 설계 — 시각 분석)
- 데이터: `.json`, `.yaml`

폴더 경로 받으면 `Glob`으로 재귀 탐색해 후보 파일 전부 식별.

### 자동 추출 대상

각 자료에서 다음 정보를 추출해 이후 step의 답으로 활용:

| 추출 정보 | 이후 사용처 |
|---|---|
| 서비스 한 줄 정의 / 핵심 가치 | Step 3 |
| 해결하는 문제 / 배경 | Step 3 + Step 8 PRD |
| 서비스 유형 (marketplace/community/SaaS 등) | Step 4 |
| 타겟 사용자 / 페르소나 / 지역 | Step 5 |
| 기술 스택 요구 (클라이언트 지정 등) | Step 6 |
| 프로젝트명 후보 (기획서에 명시된 경우) | Step 7 |
| 기능 요구사항 / 화면 목록 / Wave 우선순위 | Step 9 (MVP) |
| 일정 / 마일스톤 / 데드라인 | workflow-log 메모 |
| 법적·규제 제약 (개인정보, 결제, 면책) | Step 8 PRD (비기능 요구사항) |

### 추론 결과 제시 방식

자료 다 읽은 후 추출 결과를 **요약 표**로 한 번에 보여주고 확인:

> 다음 정보를 자료에서 추출했습니다. 맞는지 확인해주세요:
>
> - 서비스: ...
> - 해결 문제: ...
> - 타겟: ...
> - 핵심 기능: ...
> - 기술 스택 요구: ... (또는 "자료에 없음")
> - 일정: ... (또는 "자료에 없음")
>
> 누락 또는 수정할 항목 알려주세요. 확정되면 다음 단계로 진행합니다.

확인된 항목은 해당 step에서 다시 묻지 않고 통과. 누락 또는 사용자가 수정한 항목만 별도 질문.

### 자료가 여러 개 / 충돌하는 경우

- 같은 항목에 대해 자료끼리 충돌하면 사용자에게 어느 게 최신/정답인지 확인.
- 출처와 함께 표시: "(SOW.pdf)에서는 X, (회의록.md)에서는 Y — 어느 게 맞나요?"

### 자료 없음 응답 시

Step 3부터 정상 진행 (모든 정보 직접 받기). 사용자에게 안내: "참고 자료 없이 진행합니다. 각 단계에서 직접 답변 부탁드려요."

---

## Step 3 — 프로젝트 설명 / Description

**Step 2 추출 결과에 서비스 정의가 있으면 이 단계 생략.** 없거나 누락된 경우:

- "어떤 프로젝트를 만들고 싶어? 한 줄~몇 줄로 자유롭게 설명해줘."
- 외주 + 명세서 없음: "클라이언트 요구사항을 구두/메시지로 어떻게 받았어?"

받은 설명은 Step 4~7의 컨텍스트로 사용 (다시 묻지 말 것).

---

## Step 4 — 프로젝트 유형 확인 / Type Confirmation

Step 2 또는 Step 3 정보에서 **추론하여** 사용자에게 제시·확인:

- 플랫폼 (marketplace, P2P 거래, 매칭)
- 커뮤니티 (글/댓글, SNS, 포럼)
- SaaS B2B 도구
- 정적 사이트 / 랜딩 / 마케팅
- 내부 도구 / 어드민
- CLI / 라이브러리
- 기타

추론 결과를 단정하지 말고 "이거 marketplace 같은데 맞아? 아니면?"으로 확인. 다중 성격이면 우선순위를 묻는다. 이 유형이 Step 6 스택 추천에 직접 영향.

---

## Step 5 — 타겟 사용자 / Target Audience

**Step 2 추출 결과에 있으면 확인만, 없으면 묻기.**

- **누가 쓰는가**: 연령대, 직군, 사용 맥락
- **지역**: 한국 / 글로벌 / 둘 다

지역은 Step 6의 인증/결제/SMS 옵션을 가르는 결정적 분기점이다.

---

## Step 6 — 기술 스택 결정 / Tech Stack

**매번 논의**한다 (자동 고정 금지). **Step 2 자료에 클라이언트 지정 스택이 있으면 그것 우선** 검토.

### 자체 프로젝트 (own) — travelmate 검증 스택을 anchor로 제시

```
Monorepo: Turborepo
Web: React + Vite + Tailwind + TanStack Query
API: Node.js + Express + Drizzle + Zod + PostgreSQL
Deploy: Vercel + Railway + Neon
Tools: ESLint + Prettier + Husky + lint-staged
```

→ "이대로 갈래? 아니면 어디 바꿀까?" 항목별 수정 가능. **단, 프로젝트 유형이 monorepo가 과한 경우(정적 사이트, CLI, 단일 페이지 도구)는 anchor 제시 전 "이 프로젝트는 monorepo 불필요할 수 있음" 먼저 안내.**

### 외주 프로젝트 (client) — 클라이언트 요구사항 + 유형 기반 옵션 추천

- 빠른 MVP/외주: Next.js + Supabase (풀스택, 인증·DB 포함)
- 확장 플랫폼: React + Node.js + PostgreSQL (분리 아키텍처)
- 정적 사이트: Astro / Vite + React
- B2B SaaS: Next.js + tRPC + PostgreSQL 또는 요구사항에 맞춰 조정

### 지역별 분기 (Step 5 결과 기반)

**한국 타겟:**
- 인증: 카카오 OAuth (필수 검토), 네이버, Apple
- 결제: 토스페이먼츠 또는 PortOne
- SMS: CoolSMS / NHN Cloud
- 도메인 유틸: 사업자번호 / 주민번호 / 한국 휴대폰 포맷, 원화 표기

**글로벌 타겟:**
- 인증: Google / Apple / Auth0 / Clerk
- 결제: Stripe / Paddle
- SMS: Twilio

**둘 다:** Auth0 같은 통합 옵션 + 한국 PG 추가 패턴 추천.

### shared/ 우선 스캔 (필수)

스택 결정 전 `<workspace>/shared/packages/`를 먼저 스캔. 이미 만들어진 모듈(카카오 OAuth, 토스, 한국 도메인 유틸 등)이 있으면 **그것을 import해서 쓴다는 전제로 셋업**. 새로 짜지 말 것. (전역 CLAUDE.md 공유 모듈 규칙 참조)

워크스페이스에 `shared/` 폴더가 아예 없으면 이 단계 스킵.

---

## Step 7 — 프로젝트명 / Project Name

폴더명은 한 번 정하면 자주 바뀌지 않고 GitHub repo / npm / 도메인까지 연결되므로 신중하게.

### 사용자에게 묻기

**Step 1 소유 유형에 따라 톤을 분기.** 자체는 가벼운 톤, 외주는 계약 영향까지 명시.

#### 자체 (own) — 가벼운 톤

한국어 모드 예시:

> 서비스 명칭을 무엇으로 할까요?
> kebab-case 권장 (예: `travel-share`, `payment-admin`).
> 비워두면 설명에서 추론한 1~3개 후보를 제시하겠습니다.

영어 모드 예시:

> What should the service name be?
> kebab-case recommended (e.g. `travel-share`, `payment-admin`).
> Leave blank and I'll propose 1–3 candidates from the description.

#### 외주 (client) — 계약 영향 명시

한국어 모드 예시:

> 서비스 명칭을 무엇으로 할까요? **신중하게 결정해주세요.**
> 이 이름은 폴더 경로명이 되고, GitHub repo · npm 패키지 · 도메인 이름과 연결됩니다.
>
> **추후 변경 시 별도의 개발 비용이 청구되며(확정), 데드라인이 연장될 수 있습니다.**
>
> kebab-case 권장 (예: `acme-platform`, `client-admin`).
> 비워두면 설명에서 추론한 1~3개 후보를 제시하겠습니다.

영어 모드 예시:

> What should the service name be? **Please choose carefully.**
> This name becomes the folder path and will be tied to the GitHub repo, npm package, and domain.
>
> **Renaming later will incur additional development charges (confirmed) and may extend the deadline.**
>
> kebab-case recommended (e.g. `acme-platform`, `client-admin`).
> Leave blank and I'll propose 1–3 candidates from the description.

### 추론 후보 생성 방식

Step 2 자료 또는 Step 3 설명에서 핵심 명사 1~2개를 추출해 조합:

| 설명 예시 | 후보 |
|---|---|
| "여행 동행 플랫폼" | `travel-share`, `travel-companion`, `travel-platform` |
| "사내 영업 관리 도구" | `sales-admin`, `sales-ops`, `crm-internal` |
| "Acme 회사 랜딩페이지" | `acme-landing`, `acme-site` |
| "결제 정산 라이브러리" | `payment-utils`, `settlement-sdk` |

후보 제시 후 "이 중에 마음에 드는 거? 아니면 직접 입력?" 으로 확인.

### 네이밍 규칙

**필수:**
- **kebab-case** (소문자 + 하이픈): npm 패키지명 / Docker 이미지 / URL slug / GitHub repo와 자연스럽게 일관
- **영문 only** — 한글 폴더명은 빌드 도구·npm·git·CI에서 인코딩 이슈 발생 가능
- 시작은 영문자 (숫자 시작 X)
- 공백, 언더스코어(`_`), camelCase, 특수문자 금지

**피할 것:**
- 너무 일반적인 이름: `app`, `project`, `test`, `web`, `server`, `myapp`
- 회사명 단독 (확장성 ↓): `acme` → 차라리 `acme-platform`
- 약어 남발: `mtsmpf` 같은 의미 추적 불가능한 약자
- 30자 초과 (윈도우 path length 이슈)

**한국 서비스 네이밍 팁:**
- 음역(transliteration) 금지 — `traebeulmeit` 같은 거 절대 X
- 의미 번역(translation) 권장 — "트래블메이트" → `travel-mate` 또는 `travel-share`
- 한국어 의미를 짧고 명확한 영문 단어로 압축

### GitHub repo 이름 일치 권장

**폴더명 = GitHub repo 이름**으로 통일하면 깔끔. 다르면 나중에 혼란:
- 예: 이전 travelmate 케이스 (폴더 `travelmate` ↔ repo `travel-share`) — "어떤 이름이 진짜?" 혼동

폴더명 확정 전 GitHub에 같은 이름의 repo가 본인 계정에 이미 있는지 확인:

```powershell
gh repo view <username>/<프로젝트명>
```

있으면 다른 이름 권유 또는 사용자가 의식적으로 선택하게 안내.

### 서비스 유형별 네이밍 패턴 (참고)

| 유형 | 패턴 | 예시 |
|---|---|---|
| Marketplace / P2P | 동사+명사 / share/swap/match | `travel-share`, `ride-match` |
| 커뮤니티 | 명사+hub/lounge/talk | `dev-hub`, `coffee-talk` |
| B2B SaaS | 도메인+hq/base/core | `sales-hq`, `data-core` |
| 내부 도구 | 도메인+admin/ops/dash | `sales-admin`, `infra-ops` |
| 랜딩/마케팅 | 회사명+site/landing | `acme-site` |
| 라이브러리 | 언어/프레임워크 prefix+기능 | `ts-utils`, `react-form` |

### 변경 비용 (내부 참고 — Claude용)

기술적 변경 난이도:
- 폴더 rename: **쉬움** (OS 이동 또는 `git mv`)
- GitHub repo rename: **쉬움** (`gh repo rename`, 자동 redirect 제공)
- npm 패키지 published 후 rename: **어려움** (deprecate + 새 패키지 publish)
- 도메인 연결 후 변경: **어려움**

자체 프로젝트: npm publish 또는 도메인 연결 전 단계라면 변경 자유. 그 이후엔 신중.

외주 프로젝트: 위 기술 비용과 **별개로 계약상 추가 개발비 청구 + 데드라인 연장** 발생. 클라이언트와 사전 협의 필수 (위 사용자 안내 메시지에 이미 명시됨).

### 저장 경로 확정

- 자체: `<workspace>/own/<프로젝트명>/`
- 외주: `<workspace>/outsourcing/<클라이언트>/<프로젝트명>/`
- 워크스페이스 감지 실패한 단순 모드: `<workspace>/<프로젝트명>/`

---

## Step 8 — 표준 파일 생성 / Standard Files

Step 7에서 확정한 경로에 폴더 생성 후 아래 파일을 선택된 언어로 작성:

1. `docs/PRD.md` — 한 줄 정의, 해결 문제, 타겟 유저, Wave 1/2 기능, 비기능 요구사항, Out of Scope, 성공 지표, 미결사항. **Step 2 자료에서 추출한 정보 최대한 반영.**
2. `docs/workflow-log.md` — `## [DEC-001] 결정 주제` 형식. 컨텍스트 / 선택지 / 선택 / 추천 근거 / 트레이드오프 / 시점. **Step 1~7 진행 중 발생한 결정을 DEC-001부터 자동 기록.**
3. `CLAUDE.md` — 프로젝트 컨텍스트, 스택 요약, workflow-log 참조, 프로액티브 제안 규칙
4. `README.md` — 한 줄 정의 + 빠른 시작 + 배포 정보
5. `docs/git-strategy.md` — main / dev / feature/* / fix/* 전략 (1인이라도 표준 유지)
6. `.gitignore` — 기본 + `.env*` + `.claude/settings.local.json` + `.claude/scheduled_tasks.lock`

그 다음 git init (기본 브랜치 `main`), 첫 커밋. GitHub 원격 연결은 사용자가 명시적으로 요청할 때까지 보류 (gh repo create는 별도 단계).

---

## Step 9 — MVP 범위 합의 / MVP Scope

코딩 전에 반드시 확정 (PRD.md에 기록):

- **Wave 1** (론칭): 기능 목록 + 각각의 완료 기준
- **Wave 2** (검증 후 추가): 개략 목록
- **Out of Scope**: 명시적으로 안 함

**Step 2 자료에 기능 목록 있으면 Wave 1 후보로 자동 제시.** 사용자에게 Wave 분리/우선순위 확인.

---

## Step 10 — 구현 시작 / Implementation

순서:

1. 모노레포 또는 단일 프로젝트 셋업 (Step 6 결정에 따라)
2. DB 스키마 → 마이그레이션
3. 인증 (Step 6에서 결정한 방식, 가능하면 `shared/` 모듈 활용)
4. 핵심 기능 (Wave 1 우선순위 순)
5. CI/CD (자체면 GitHub Actions + Vercel/Railway 기본, 외주면 클라이언트 인프라)

각 단계에서 의사결정 발생 시 `docs/workflow-log.md`에 `DEC-NNN` 추가.

---

## 마무리 안내

프로젝트 생성 후 사용자에게 안내:

- `<workspace>/claude-workflows/commands/` 라이브러리에서 필요한 커맨드를 새 프로젝트의 `.claude/commands/`로 **수동 복사** 권유. 글로벌 자동 설치는 사용하지 않는다 (사용자 정책).
- `<workspace>/shared/` 패키지 사용 시 `package.json`에 git dependency 또는 npm install로 연결.
- 첫 GitHub 원격 연결 원하면 `gh repo create` 단계 별도 진행.
