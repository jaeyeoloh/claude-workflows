# /new-project

새 프로젝트(자체/외주, 플랫폼/커뮤니티/SaaS/내부도구 등) 시작 시 표준 워크플로우.

---

## 메타 규칙

- `$ARGUMENTS`에 프로젝트 설명이 있으면 Step 2 응답으로 활용 가능. 단, 다른 정보(소유/유형/타겟/스택)는 여전히 명시적으로 확인.
- **Step 0에서 결정된 언어**가 이후 모든 단계의 질문, 옵션 라벨, 생성 파일(PRD.md, CLAUDE.md, workflow-log.md, README.md 등)의 언어를 결정한다.
- skill.md 파일 자체는 한국어로 유지 — 사용자에게 안 보이는 Claude용 지시문. 영어 모드와 무관.
- 사용자가 이미 답한 정보는 다시 묻지 않는다. 누락된 항목만 진행.

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
| 자체 (own) | 의사결정 자유도 높음. travelmate 검증 스택을 anchor로 제시 가능. workflow-log 자유 형식. | `projects/own/<프로젝트명>/` |
| 외주 (client) | 클라이언트 요구사항/명세 우선. 워크플로우-log를 청구/검토 근거로 활용 가능하게 더 정밀하게 기록. | `projects/outsourcing/<클라이언트>/<프로젝트명>/` |

---

## Step 2 — 프로젝트 설명 / Description

자유 서술로 받는다:

- "어떤 프로젝트를 만들고 싶어? 한 줄~몇 줄로 자유롭게 설명해줘."
- **외주 선택 시 추가**: "클라이언트 요구사항 명세서(SOW, RFP, 기획서, 와이어프레임 등)가 있어? 있으면 위치 또는 내용 공유해줘."

받은 설명은 Step 3~5의 컨텍스트로 사용 (다시 묻지 말 것).

---

## Step 3 — 프로젝트 유형 확인 / Type Confirmation

Step 2 설명에서 아래 중 어디에 가까운지 **추론하여** 사용자에게 제시·확인:

- 플랫폼 (marketplace, P2P 거래, 매칭)
- 커뮤니티 (글/댓글, SNS, 포럼)
- SaaS B2B 도구
- 정적 사이트 / 랜딩 / 마케팅
- 내부 도구 / 어드민
- CLI / 라이브러리
- 기타

추론 결과를 단정하지 말고 "이거 marketplace 같은데 맞아? 아니면?"으로 확인. 다중 성격이면 우선순위를 묻는다. 이 유형이 Step 5 스택 추천에 직접 영향.

---

## Step 4 — 타겟 사용자 / Target Audience

- **누가 쓰는가**: 연령대, 직군, 사용 맥락
- **지역**: 한국 / 글로벌 / 둘 다

지역은 Step 5의 인증/결제/SMS 옵션을 가르는 결정적 분기점이다.

---

## Step 5 — 기술 스택 결정 / Tech Stack

**매번 논의**한다 (자동 고정 금지). 단, 시작점은 소유 유형에 따라 다름.

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

### 지역별 분기

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

스택 결정 전 `C:\Users\vhxj3\Desktop\projects\shared\packages\`를 먼저 스캔. 이미 만들어진 모듈(카카오 OAuth, 토스, 한국 도메인 유틸 등)이 있으면 **그것을 import해서 쓴다는 전제로 셋업**. 새로 짜지 말 것. (전역 CLAUDE.md 공유 모듈 규칙 참조)

---

## Step 6 — 표준 파일 생성 / Standard Files

Step 1에서 결정한 위치에 폴더 생성 후 아래 파일을 선택된 언어로 작성:

1. `docs/PRD.md` — 한 줄 정의, 해결할 문제, 타겟 유저, Wave 1/2 기능, 비기능 요구사항, Out of Scope, 성공 지표, 미결사항
2. `docs/workflow-log.md` — `## [DEC-001] 결정 주제` 형식. 컨텍스트 / 선택지 / 선택 / 추천 근거 / 트레이드오프 / 시점
3. `CLAUDE.md` — 프로젝트 컨텍스트, 스택 요약, workflow-log 참조, 프로액티브 제안 규칙
4. `README.md` — 한 줄 정의 + 빠른 시작 + 배포 정보
5. `docs/git-strategy.md` — main / dev / feature/* / fix/* 전략 (1인이라도 표준 유지)
6. `.gitignore` — 기본 + `.env*` + `.claude/settings.local.json` + `.claude/scheduled_tasks.lock`

그 다음 git init (기본 브랜치 `main`), 첫 커밋. GitHub 원격 연결은 사용자가 명시적으로 요청할 때까지 보류 (gh repo create는 별도 단계).

---

## Step 7 — MVP 범위 합의 / MVP Scope

코딩 전에 반드시 확정 (PRD.md에 기록):

- **Wave 1** (론칭): 기능 목록 + 각각의 완료 기준
- **Wave 2** (검증 후 추가): 개략 목록
- **Out of Scope**: 명시적으로 안 함

---

## Step 8 — 구현 시작 / Implementation

순서:

1. 모노레포 또는 단일 프로젝트 셋업 (Step 5 결정에 따라)
2. DB 스키마 → 마이그레이션
3. 인증 (Step 5에서 결정한 방식, 가능하면 `shared/` 모듈 활용)
4. 핵심 기능 (Wave 1 우선순위 순)
5. CI/CD (자체면 GitHub Actions + Vercel/Railway 기본, 외주면 클라이언트 인프라)

각 단계에서 의사결정 발생 시 `docs/workflow-log.md`에 `DEC-NNN` 추가.

---

## 마무리 안내

프로젝트 생성 후 사용자에게 안내:

- `claude-workflows/commands/` 라이브러리에서 필요한 커맨드를 새 프로젝트의 `.claude/commands/`로 **수동 복사** 권유. 글로벌 자동 설치는 사용하지 않는다 (사용자 정책).
- `shared/` 패키지 사용 시 `package.json`에 git dependency 또는 npm install로 연결.
- 첫 GitHub 원격 연결 원하면 `gh repo create` 단계 별도 진행.
