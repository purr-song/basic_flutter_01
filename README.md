# flutter_basic_seminar

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## App과 Package

`packages/seminar_utils`는 다음과 같은 코드를 앱에서 분리한 예제다.

- 여러 기능이나 앱에서 공통으로 사용하는 코드
- 앱과 분리해서 독립 테스트하기 좋은 코드
- 독립적으로 관리하는 편이 유리한 기능

파일 수가 많다는 이유만으로 Package로 나누지는 않는다.

## Performance

- Performance: 느린 Frame을 찾고 UI / Raster 중 어느 단계가 병목인지 1차로 구분한다.
- 이 예제는 교육을 위해 UI Isolate를 약 80ms 동안 의도적으로 점유한다.
- Performance 탭은 정확한 Dart 코드 라인을 찾는 도구가 아니다.
