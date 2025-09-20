# 여행 기록 앱 (Flutter)

모바일 여행 기록 앱입니다. 사용자가 여행지, 교통수단, 액티비티 등을 기록할 수 있고, 이러한 기록들을 시간순으로 정렬하여 메인 페이지에 타임라인 형태로 표시합니다.

## 주요 기능

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
├── main.dart                 # 앱 엔트리포인트
├── models/
│   └── travel_record.dart    # 데이터 모델
├── screens/
│   └── travel_app.dart       # 메인 앱 화면
└── widgets/                  # UI 컴포넌트들
    ├── add_record_modal.dart
    ├── bottom_navigation.dart
    ├── filtered_timeline.dart
    ├── mobile_header.dart
    ├── record_card.dart
    └── ...
```