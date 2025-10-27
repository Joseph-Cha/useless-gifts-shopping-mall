# 이걸 왜 팔아?

쓸데없지만 갖고 싶은 그런 물건들을 판매하는 재미있는 쇼핑몰 앱입니다.

## 프로젝트 소개

"이걸 왜 팔아?"는 실용성보다는 재미와 개성을 추구하는 특별한 상품들을 소개하는 Flutter 기반 모바일 쇼핑몰 애플리케이션입니다. 통역 문구가 인쇄된 재밌는 티셔츠, 뚱뚱보 뱃살 힙색, 맘스크 콧물발싸 등 독특하고 유쾌한 아이템들을 만나보세요!

## 주요 기능

### 1. 상품 목록 및 검색
- 그리드 형태의 직관적인 상품 목록 UI
- 실시간 검색 기능으로 원하는 상품 빠르게 찾기
- 카테고리별 필터링 (티셔츠, 잡화, 쿠션, 노트)
- 각 상품 카드에 카테고리 뱃지 표시

### 2. 상품 상세 정보
- 고해상도 상품 이미지
- 상세한 상품 설명
- 수량 선택 기능
- 장바구니 담기
- 같은 카테고리의 관련 상품 추천

### 3. 장바구니
- 담은 상품 목록 관리
- 상품별 수량 조절 (증가/감소)
- 개별 상품 삭제
- 실시간 총 금액 계산
- 간편한 구매 프로세스

### 4. 상품 등록
- 갤러리에서 이미지 선택 또는 URL 입력
- 상품 정보 입력 (이름, 가격, 설명, 카테고리)
- 폼 유효성 검증
- 실시간 등록 상품 반영

## 기술 스택

- **Framework**: Flutter 3.9.2+
- **언어**: Dart
- **상태 관리**: Provider 패턴
- **이미지 처리**: image_picker 패키지
- **아키텍처**: MVVM (Model-View-ViewModel)

## 프로젝트 구조

```
lib/
├── models/              # 데이터 모델
│   ├── product.dart     # 상품 모델
│   ├── cart_item.dart   # 장바구니 아이템 모델
│   └── user.dart        # 사용자 모델
├── providers/           # 상태 관리
│   ├── product_provider.dart  # 상품 상태 관리
│   └── cart_provider.dart     # 장바구니 상태 관리
├── screens/             # 화면
│   ├── main_screen.dart              # 메인 화면 (Bottom Navigation)
│   ├── product_list_screen.dart      # 상품 목록 화면
│   ├── product_detail_screen.dart    # 상품 상세 화면
│   ├── cart_screen.dart              # 장바구니 화면
│   └── product_registration_screen.dart  # 상품 등록 화면
├── widgets/             # 재사용 가능한 위젯
│   ├── product_grid_item.dart  # 상품 그리드 아이템
│   └── product_image.dart      # 상품 이미지 (네트워크/로컬/에셋 지원)
└── main.dart            # 앱 진입점

data/
└── products/
    └── products.json    # 상품 데이터 (JSON)

assets/
└── img/                 # 상품 이미지
```

## 설치 및 실행

### 사전 요구사항
- Flutter SDK 3.9.2 이상
- Dart SDK 3.0.0 이상
- Android Studio / Xcode (플랫폼별)

### 설치 방법

1. 저장소 클론
```bash
git clone <repository-url>
cd useless-gifts-shopping-mall
```

2. 의존성 설치
```bash
flutter pub get
```

3. 앱 실행
```bash
flutter run
```

## 상품 카테고리

현재 지원하는 카테고리:
- **티셔츠**: 재미있는 문구가 인쇄된 티셔츠
- **잡화**: 힙색, 브로치, 마스크 등 다양한 잡화류
- **쿠션**: 독특한 디자인의 쿠션
- **노트**: 특별한 노트 및 문구류

## 주요 패키지

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2        # 상태 관리
  image_picker: ^1.0.7    # 이미지 선택
  cupertino_icons: ^1.0.8 # iOS 스타일 아이콘
```

## 특징

### 가격 포매팅
- 1,000원 단위 콤마 구분
- 한국 원화 표시

### 이미지 지원
- Asset 이미지 (assets/)
- 네트워크 이미지 (http/https)
- 로컬 파일 이미지 (갤러리 선택)

### 반응형 UI
- 그리드 레이아웃 (2열)
- 검색 및 필터 UI
- 카드 기반 디자인

## 개발 정보

### 데이터 로딩
- 앱 시작 시 JSON 파일에서 상품 데이터 자동 로드
- 에러 핸들링 및 로딩 상태 관리

### 상태 관리
- Provider 패턴 사용
- ChangeNotifier를 통한 반응형 UI 업데이트
- 장바구니 상태 실시간 동기화

## 코드 품질

```bash
# 코드 분석
flutter analyze

# 포맷팅
flutter format .
```

## 라이센스

이 프로젝트는 개인 학습 및 포트폴리오 목적으로 제작되었습니다.

## 문의

프로젝트에 대한 문의사항이나 개선 제안이 있으시면 이슈를 등록해 주세요.

---

**재미있는 쇼핑 경험을 즐겨보세요!** 🎁
