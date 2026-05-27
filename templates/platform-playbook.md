# Platform Playbook

> 새 플랫폼/웹사이트/외주 프로젝트를 시작할 때 재사용하는 범용 템플릿.
> 이 프로젝트(트래블메이트)의 workflow-log를 기반으로 추출한 패턴.
> 마지막 업데이트: 2026-05-27

---

## 0. 이 플레이북을 쓰는 타이밍

아이디어가 생겼을 때 → **Step 1부터 순서대로** 진행한다.
코딩은 Step 4가 끝난 후에 시작한다.

---

## Step 1 — 프로젝트 성격 파악 (30분)

다음 세 가지를 2~3문장으로 정리한다:

| 질문 | 예시 답변 |
|------|---------|
| 어떤 문제를 푸는가? | "클룩 전용차를 샀는데 일행이 적어 비용 부담이 큰 여행자의 문제" |
| 누가 쓰는가? | "20~35세 동남아/일본 단기 여행자, 클룩 사용자" |
| 어떻게 돈을 버는가? | "거래 성사 시 10% 수수료 (Wave 2)" |

→ 답변이 나오면 `docs/PRD.md` 생성 시작.

---

## Step 2 — PRD 작성 (1~2시간)

**포함할 것** (최소 PRD):
- 한 줄 정의
- 해결하는 문제 (현재 해결 방법의 문제점 포함)
- 타겟 유저 Primary / Secondary
- Wave 1 기능 목록 + 각 기능의 **완료 기준**
- Wave 2 이후 (일정 미정)
- 명시적 Out of Scope
- 성공 지표 (숫자로)
- 미결 사항 (결정이 필요한 것만)

**포함하지 말 것**: UI 상세 스펙, 화면 설계, DB 설계 (개발하면서 결정)

**완성 기준**: 비개발자(기획자/투자자)가 읽고 서비스가 이해되면 OK.

---

## Step 3 — 기술 스택 결정 (30분)

프로젝트 유형별 추천:

### 🔵 확장 가능한 플랫폼 (결제/에스크로/실시간 포함)
```
Web:     React + Vite + Tailwind (반응형, PWA)
API:     Node.js + Express + TypeScript
DB:      PostgreSQL + Drizzle ORM
Auth:    JWT (15분) + Refresh Token (30일) + 카카오 OAuth
Chat:    Socket.io
Files:   Cloudflare R2
Payment: 토스페이먼츠 (에스크로 기본 지원)
Mono:    Turborepo
Deploy:  Vercel (web) + Railway (api) + Neon (db)
```

### 🟢 빠른 MVP/외주 (복잡한 결제 로직 없음)
```
Stack:   Next.js + Supabase (풀스택, 인증/DB 포함)
Deploy:  Vercel 단일 배포
```

### 🟡 정적 사이트/랜딩 페이지
```
Stack:   Astro 또는 Vite + React
Deploy:  Vercel 또는 Cloudflare Pages
```

**한국 서비스 필수 체크리스트**:
- [ ] 카카오 OAuth (또는 네이버)
- [ ] 토스페이먼츠 (또는 PortOne)
- [ ] CoolSMS (전화번호 OTP)
- [ ] 개인정보처리방침 페이지

결정 내용은 `docs/workflow-log.md`에 DEC-001부터 기록 시작.

---

## Step 4 — 구조 셋업 (반나절)

### 4-1. 디렉토리 구조

**플랫폼 (모노레포)**:
```
project/
├── apps/
│   ├── web/          # React + Vite (포트 3000)
│   ├── api/          # Node.js + Express (포트 4000)
│   └── mobile/       # Capacitor 래핑 (앱스토어 진입 시점에 추가)
├── packages/
│   ├── types/        # 공유 타입 정의
│   ├── utils/        # 공유 유틸
│   └── api-client/   # axios 기반 API 클라이언트
├── docs/
│   ├── PRD.md
│   ├── workflow-log.md
│   └── platform-playbook.md
├── .github/
│   └── workflows/
│       ├── ci.yml        # PR 검사 (type-check + lint)
│       └── deploy.yml    # main 머지 시 자동 배포
├── CLAUDE.md
├── turbo.json
└── package.json
```

**MVP/외주 (단일 프로젝트)**:
```
project/
├── src/
│   ├── app/          # Next.js App Router
│   ├── components/
│   ├── lib/
│   └── types/
├── docs/
│   ├── PRD.md
│   └── workflow-log.md
└── CLAUDE.md
```

### 4-2. 코드 품질 도구

모든 프로젝트 공통으로 설치:
```
ESLint + Prettier + husky + lint-staged
```

설정 원칙:
- TypeScript strict mode
- 커밋 전 자동 lint + format (lint-staged)
- 코드 많이 쌓인 후 추가하면 전체 수정 필요 → **처음부터**

### 4-3. Git 브랜치 전략

```
main          → 배포용 (직접 커밋 금지)
feature/기능명  → 기능 개발 (예: feature/chat, feature/auth)
fix/버그명      → 버그 수정 (예: fix/login-error)
```

---

## Step 5 — DB 스키마 설계 (코딩 전)

**변경 비용이 높은 것 → 먼저 확정**:
- 핵심 엔티티 관계 (users, listings, transactions 등)
- 인증 방식 (JWT 만료 시간, 리프레시 토큰 저장 위치)
- 결제 흐름 (에스크로 상태 전이)
- 파일 저장 방식 (URL 구조, 버킷 정책)

**나중에 바꿔도 되는 것**: 컬럼 추가, 인덱스 최적화, 알림 문구

Drizzle ORM 사용 시 파일 위치: `apps/api/src/db/schema.ts`

---

## Step 6 — 구현 순서

```
DB 스키마
  ↓
인증 모듈 (회원가입 / 로그인 / 토큰 갱신)
  ↓
핵심 기능 API (리스팅, 참여 등 비즈니스 로직)
  ↓
웹 UI (리스트 → 상세 → 생성 → 마이페이지 순서)
  ↓
실시간 기능 (채팅, 알림)
  ↓
배포 파이프라인
  ↓
베타 출시
```

---

## Step 7 — 배포 파이프라인

### Vercel (웹)
- GitHub 연결 → 자동 Preview URL (PR마다)
- 환경변수: `VITE_API_URL`
- `apps/web/vercel.json`: SPA rewrites 설정 필수

### Railway (API)
- Dockerfile 또는 Nixpacks 자동 감지
- 환경변수: `DATABASE_URL`, `JWT_SECRET`, `KAKAO_CLIENT_ID` 등
- PostgreSQL 서비스 추가 가능 (또는 Neon 외부 연결)

### GitHub Actions
- **ci.yml**: PR 생성 시 type-check + lint 자동 실행
- **deploy.yml**: main 브랜치 push 시 Vercel + Railway 자동 배포

### 필요한 Secrets (GitHub → Settings → Secrets)
```
VERCEL_TOKEN
VERCEL_ORG_ID
VERCEL_PROJECT_ID_WEB
RAILWAY_TOKEN
VITE_API_URL         ← 배포된 API 주소
```

---

## Step 8 — 베타 출시 체크리스트

### 기능
- [ ] 회원가입 / 로그인 (이메일 + 소셜)
- [ ] 핵심 기능 전체 플로우 동작
- [ ] 모바일 반응형 (375px~)
- [ ] 빈 상태 UI (데이터 없을 때)
- [ ] 에러 상태 UI (API 실패 시)

### 운영
- [ ] 도메인 연결 (Vercel 커스텀 도메인)
- [ ] 개인정보처리방침 페이지
- [ ] .env.example 최신화
- [ ] README.md 작성

### 선택 (Wave 2 전)
- [ ] Sentry (에러 모니터링)
- [ ] Google Analytics 또는 Mixpanel
- [ ] Rate Limiting (API 어뷰징 방지)

---

## 의사결정 기록 원칙

`docs/workflow-log.md`에 아래 상황에서 반드시 기록:
1. 기술 스택 선택 (라이브러리, 프레임워크)
2. 아키텍처 분기점 (구조가 달라지는 선택)
3. 개발 방식 결정 (순서, 우선순위)
4. 보안/결제/법적 고려사항

기록 형식:
```
## [DEC-N] 결정 주제
- 컨텍스트: 왜 이 결정이 필요했는가
- 선택지: 제시된 옵션들
- 선택: 실제로 선택한 것
- 추천 근거: 어떤 이유로 추천했는가
- 트레이드오프: 선택하지 않은 옵션의 장단점
- 시점: 결정 당시 개발 단계
```

---

## 외주 프로젝트 추가 체크리스트

일반 플랫폼과 다른 점:

| 항목 | 확인 내용 |
|------|---------|
| 요구사항 명세서 | 클라이언트 문서 존재 여부 → 없으면 킥오프 미팅 전 PRD 초안 작성 후 확인 |
| 완료 기준 | 각 기능마다 "이 상태면 완료" 명시 → 분쟁 방지 |
| 수정 범위 | 계약 외 추가 요청 발생 시 별도 협의 조건 명시 |
| 소스코드 소유권 | 납품 후 클라이언트 소유 여부 확인 |
| 유지보수 조건 | 납품 후 버그 수정 기간 및 비용 |
| 배포 계정 | 클라이언트 소유 Vercel/AWS 계정에 배포할지, 개발자 계정에서 이전할지 |

---

## 참고: 트래블메이트 프로젝트 결정 로그

이 플레이북은 `docs/workflow-log.md`의 DEC-001~010을 기반으로 작성됨.
구체적인 결정 근거와 트레이드오프는 해당 파일 참조.
