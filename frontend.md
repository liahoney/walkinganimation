# Project Overview (프로젝트 개요)
- 3D 드로잉 변환 프로젝트
- Three.js와 Canvas를 활용한 2D→3D 변환 웹 애플리케이션
- 주 사용자: 어린이
- UI/UX: 심플하고 직관적인 사용자 친화적 디자인

# Feature Requirements (기능 요구사항)
## 필수 기능
- 2D 드로잉 캔버스
  - 자유롭게 그림을 그릴 수 있는 캔버스 제공
  - 기본적인 그리기 도구 (펜, 지우개)
  - 선 굵기 조절
  - 색상 선택 (기본 색상 팔레트)

- 3D 변환 및 표시
  - 2D 그림을 3D 모델로 변환
  - 3D 모델 회전/확대/축소 기능
  - 조명 효과

- UI/UX
  - 큰 버튼과 아이콘
  - 직관적인 네비게이션
  - 간단한 작동 방식
  - 밝고 경쾌한 색상 사용

# Relevant Codes (관련 코드)
## 주요 라이브러리
- Three.js: 3D 렌더링
- Canvas API: 2D 드로잉
- Vue.js: MVVM 아키텍처 구현

# Current File 
lib/
├── models/
│   ├── drawing_model.dart
│   └── three_model.dart
├── viewmodels/
│   ├── drawing_viewmodel.dart
│   └── three_viewmodel.dart
├── views/
│   ├── home_view.dart
│   └── drawing_view.dart
├── widgets/
│   ├── drawing/
│   │   ├── drawing_canvas.dart
│   │   ├── drawing_tools.dart
│   │   └── color_palette.dart
│   └── three/
│       ├── three_scene.dart
│       └── controls.dart
└── main.dart

# Rules (규칙)
1. 코드 구조
   - MVVM 패턴 준수
   - 컴포넌트 기반 개발
   - 재사용 가능한 모듈식 설계

2. 네이밍 규칙
   - 컴포넌트: PascalCase
   - 메서드/변수: camelCase
   - 상수: UPPER_SNAKE_CASE

3. 성능 최적화
   - 불필요한 렌더링 최소화
   - 리소스 효율적 관리
   - 메모리 누수 방지

# Checklist (체크리스트)
## 초기 설정
- [x] 프로젝트 환경 설정
- [x] 필요한 라이브러리 설치
- [x] 기본 파일 구조 생성

## 2D 드로잉 기능
- [x] 캔버스 컴포넌트 구현
- [x] 그리기 도구 구현
- [x] 색상 선택 기능 구현
- [x] 선 굵기 조절 기능 구현

## 3D 변환 기능
- [x] Three.js 씬 설정
- [x] 2D→3D 변환 로직 구현
- [x] 3D 모델 컨트롤 구현
- [x] 조명 효과 구현

## UI/UX
- [x] 반응형 레이아웃 구현
- [x] 사용자 친화적 인터페이스 디자인
- [x] 애니메이션 효과 추가

## 테스트 및 최적화
- [x] 성능 테스트
- [x] 크로스 브라우저 테스트
- [x] 코드 최적화
- [x] 사용성 테스트
