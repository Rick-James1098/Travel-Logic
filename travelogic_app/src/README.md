# Travelogic (Flutter)

모바일 여행 계획 및 기록 앱입니다. 사용자가 여행을 계획하고, 여행지, 교통수단, 액티비티 등을 기록할 수 있습니다.

## 주요 기능

### 🏠 홈 화면
- ✅ **Travelogic 브랜딩** - 상단바에 앱 이름 표시
- ✅ **프로필 & 알림** - 우측 상단에 프로필과 알림 버튼
- ✅ **다가오는 여행** - 예정된 여행들을 카드 형태로 표시
- ✅ **수평 슬라이드** - 여러 여행 계획을 좌우로 스와이프하여 확인
- ✅ **하단 네비게이션** - 내 여행/홈/설정 페이지 간 이동

### 📱 여행 기록 화면
- ✅ **모바일 헤더** - 햄버거 메뉴와 설정 버튼  
- ✅ **타임라인 뷰** - 날짜별로 그룹화된 여행 기록  
- ✅ **하단 네비게이션** - 전체/숙소/교통수단/액티비티 탭  
- ✅ **플로팅 액션 버튼** - 새 기록 추가  
- ✅ **상세 기록 입력** - 교통편, 숙소 상세 정보 입력
- ✅ **사이드바** - 여행 목록  
- ✅ **총 금액 계산** - 각 탭별 총 지출 표시  

## 실행 방법

```bash
flutter run
```

## 디렉토리 구조

```
lib/
├── main.dart                           # 앱 엔트리포인트
├── models/
│   ├── travel_record.dart              # 여행 기록 데이터 모델
│   └── trip_plan.dart                  # 여행 계획 데이터 모델
├── screens/
│   ├── home_screen.dart                # 메인 홈 화면
│   └── travel_app.dart                 # 여행 기록 화면
└── widgets/                            # UI 컴포넌트들
    ├── home_header.dart                # 홈 화면 상단바
    ├── home_bottom_navigation.dart     # 홈 화면 하단 네비게이션
    ├── upcoming_trip_card.dart         # 다가오는 여행 카드
    ├── detailed_add_record_modal.dart  # 상세 기록 추가 모달
    ├── mobile_header.dart              # 여행 기록 화면 헤더
    ├── bottom_navigation.dart          # 여행 기록 화면 네비게이션
    ├── record_card.dart                # 여행 기록 카드
    └── ...
```