# ARCHITECTURE — 멜버니의 걸음마 / 김아린 성공기

## 시스템 전체도 (2026.09.12 기준)

```
┌─ GitHub Pages (무료 호스팅) ─────────────────────┐
│  melbourny-walks  (멜버니 🩷)                     │
│  arin-footprints  (아린 🏆 옐로우)                │
│  silver-rest      (모두엔 MODU:N — 별도 프로젝트) │
│  multicultural    (어울림 — 별도 프로젝트)        │
└──────────────────────────────────────────────────┘
              │ fetch (REST, anon key)
              ▼
┌─ Supabase 프로젝트 2개 ──────────────────────────┐
│  ① csenbounuattwcivyuho ★가족앱 전용 (500MB)     │
│     ├─ mel_photos / mel_diary   (멜버니)         │
│     └─ arin_photos / arin_diary (아린)           │
│  ② puuiviiiltxagoebruuq (심리 사이트용, 500MB)   │
│     ├─ eoullim_* (어울림)                        │
│     └─ dungji_* (모두엔)                         │
└──────────────────────────────────────────────────┘

감시: storage_watch.py (월 1회 크론 b8a8542abb07)
      → 4테이블 용량 합산, 80% 도달 시 경고 보고
```

## 공통 앱 아키텍처 (두 앱 동일 — 코드 복제 + 브랜드/테마/DB만 분기)

```
index.html (단일 파일, 의존성 0)
├─ 게이트: 비밀번호 (멜버니 260915 / 아린 250407) — sessionStorage 1일
├─ 헤더: D+day (로컬 자정 생성자 — UTC 9시간 오차 방지, 1분 자동 갱신)
├─ 탭 4개:
│  ├─ 앨범   — 서버 데이터 최신순, 카드=미디어+메모+D태그
│  ├─ 기록   — 파일선택→리사이즈(사진 1200px/85%, 동영상 30MB 한도)→base64 POST
│  ├─ 일기   — 텍스트 POST, 탭 진입 시 서버 재조회(refreshDiary)
│  └─ 달력   — 월 이동, 사진 썸네일 오버레이, 출생일 💗
├─ 팝업: 날짜 클릭 → 바텀시트 (당일 사진+메모+일기 통합)
├─ 공유: Web Share API (파일 공유 → 카톡 사진 전송, 폴백 클립보드)
├─ 삭제: confirm → 서버 DELETE + 로컬 splice
└─ 폴백: DB 실패 시 localStorage (SUPA_URL 비활성 시 로컬 전용 모드)
```

## DB 스키마 (csenbounuattwcivyuho)

```sql
mel_photos  (id identity PK, created_at, photo_date date, memo text, image_data text)
mel_diary   (id identity PK, created_at, text)
arin_photos (동일 구조)
arin_diary  (동일 구조)
-- RLS 전체 허용 정책 (사이트 비번 게이트가 접근 제어)
-- ⚠️ kind 컬럼 없음 — 프론트에서 400 폴백 처리
```

## 이력

| 날짜 | 내용 |
|---|---|
| 09-10 | 멜버니 v1 배포 (puui…공유) → 서버공유/2컨텍스트 검증 |
| 09-11 | 멜버니 v2(팝업/동영상/공유) v3(삭제/D-day수정) — kind 400 폴백, UTC 오차 픽스 |
| 09-11 | 아린 앱 배포 (발자국→성공기 리브랜딩, 옐로우 테마) |
| 09-12 | 가족앱 DB 신규 프로젝트로 이전 (500MB 독립) — 데이터 이관+라이브 검증 완료 |

## 운영 노트

- 용량: 사진 위주 0원 / 동영상 빈도가 변수 (월 1회 감시 보고)
- 무료 한도 임박 시 우선순위: ① 동영상 10MB 압축 강화 ② Storage 버킷(1GB 무료) ③ Pro
- 키 로테이션 시: 두 앱 index.html의 SUPA_URL/SUPA_KEY 2상수씩 + storage_watch는 melbourny index.html에서 자동 추출
