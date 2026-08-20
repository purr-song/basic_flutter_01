# Flutter Basic Seminar 01

하나의 Flutter 앱을 단계별로 발전시키며 기본 UI, 상태, 디버깅, DevTools를 실습하는 저장소다. 각 태그는 독립적으로 checkout해 실행할 수 있는 수업 시점이다.

## 실행

```sh
flutter pub get
flutter run
```

## Flutter 환경 확인

```sh
flutter doctor
flutter devices
```

문제가 생기면 먼저 `flutter doctor`의 진단 결과와 `flutter devices`의 실행 대상 목록을 확인한다.

## 태그로 실습하기

전체 태그를 확인한다.

```sh
git tag
```

특정 단계로 이동한다.

```sh
git switch --detach step-07-breakpoint
```

이 상태는 특정 commit/tag를 살펴보는 detached HEAD 상태다. VS Code Git Graph의 `Checkout Detached`를 사용해도 된다.

기본 브랜치로 돌아온다.

```sh
git switch main
```

## Step 안내

| Tag | 주제 | 핵심 실습 |
| --- | --- | --- |
| step-00-initial | Initial | 기본 Flutter App |
| step-01-assets | Assets | pubspec / Image.asset / Image Preview |
| step-02-counter | Counter | State / setState |
| step-03-hot-reload | Hot Reload | Reload / Restart |
| step-04-build-mode | Build Mode | Debug / Profile / Release |
| step-05-logging | Logging | print / debugPrint |
| step-06-stack-trace | Stack Trace | Exception / line / column |
| step-07-breakpoint | Breakpoint | Step / Variables / Call Stack |
| step-08-conditional-breakpoint | Conditional | 조건 Breakpoint |
| step-09-watch | Watch | Scope / Watch / Debug Console |
| step-10-package | Package | App vs Package / path dependency |
| step-11-widget-inspector | Inspector | Widget Tree |
| step-12-layout | Layout | Size / Constraints / Padding |
| step-13-performance | Performance | UI Jank / Frame |
| step-14-cpu-profiler | CPU Profiler | CPU 병목 함수 찾기 |

### 진행자가 확인할 포인트

- `step-01`: `pubspec.yaml`의 asset 등록과 `Image.asset()` 경로를 함께 확인한다.
- `step-02`: FloatingActionButton을 누를 때 `setState()`가 Count UI를 갱신하는지 확인한다.
- `step-03`: Count를 올린 뒤 Hot Reload와 Hot Restart를 비교하고 `main`, `initState` 로그를 본다.
- `step-04`: Debug/Profile/Release는 Flavor가 아니라 Build Mode임을 구분한다.
- `step-05`: `debugPrint()` 자체는 Debug mode 전용 함수가 아니며, `kDebugMode` 조건이 Debug 전용 로그를 만든다는 점을 확인한다.
- `step-06`: 예외 Stack Trace에서 `onPressed → handleErrorButton → throwTestException`과 `파일:줄:열`을 읽는다.
- `step-07`: `increment()`와 `calculateNextValue()`에 breakpoint를 두고 Step Over/Into/Out, VARIABLES, Call Stack을 확인한다.
- `step-08`: 반복문의 breakpoint 조건을 `i == 50`으로 설정해 일반 breakpoint와 비교한다.
- `step-09`: `debugPrint()` 줄에서 `price`, `discount`, `result`, `price * (1 - discount)`를 Watch한다.
- `step-10`: 앱과 package 테스트를 따로 실행하고 path dependency 연결을 확인한다.
- `step-11`: Select Widget Mode로 Widget Tree와 소스 위치를 찾는다.
- `step-12`: Container의 Size, Constraints, Padding을 Inspector에서 비교한다.
- `step-13`: Profile mode에서 느린 Frame과 UI/Raster 구분을 확인한다.
- `step-14`: CPU Profiler에서 `runSlowWorkDemo → runIntentionallySlowUiWork` 호출을 찾는다.

## Hot Reload와 Hot Restart

Count를 올린 상태에서 비교한다.

| 동작 | State | `main()` | `initState()` |
| --- | --- | --- | --- |
| Hot Reload | 유지 | 재실행 안 함 | 재실행 안 함 |
| Hot Restart | 초기화 | 재실행 | 재실행 |

## App과 Package

일반 앱을 만든다.

```sh
flutter create sample_app
```

일반 App에는 실행에 필요한 Native Host가 포함된다.

```text
android/
ios/
lib/
...
```

Package를 만든다.

```sh
flutter create --template=package seminar_utils
```

일반적인 Package의 핵심 구조는 다음과 같다.

```text
lib/
test/
pubspec.yaml
```

```text
App
→ 실행 가능한 앱
→ Android / iOS Native Host 포함

Package
→ 재사용 가능한 Dart/Flutter 코드
→ 일반적인 App용 Android / iOS Host 프로젝트 없음
```

이 저장소의 `packages/seminar_utils`는 다음 경우를 보여준다.

- 여러 기능이나 앱에서 공통으로 사용하는 코드
- 앱과 분리해서 독립 테스트하기 좋은 코드
- 독립적으로 관리하는 편이 유리한 기능

단순히 파일 수가 많다는 이유만으로 Package로 나누지는 않는다. 앱은 아래 path dependency로 package를 연결한다.

```yaml
dependencies:
  seminar_utils:
    path: packages/seminar_utils
```

## Android 기본 구조 맛보기

```text
MainActivity / FlutterActivity
        ↓
FlutterEngine
        ↓
Dart main()
        ↓
runApp()
        ↓
Widget Tree
```

- 기본 Flutter Android App은 보통 `MainActivity : FlutterActivity()`를 사용한다.
- 일반적인 Flutter App에서는 하나의 FlutterActivity를 Native Host로 사용한다.
- 화면 이동은 Activity를 계속 새로 만드는 대신 Flutter 내부 Widget Tree가 바뀌는 방식이 보통이다.
- Add-to-App, 여러 Activity, 여러 FlutterEngine 구성도 가능하므로 절대적인 규칙은 아니다.

## VS Code Extension

| Extension | Publisher | 역할 |
| --- | --- | --- |
| Flutter | Dart Code | Flutter 실행 / Debug / DevTools |
| Dart | Dart Code | Analyzer / Completion / Formatting / Refactoring |
| Error Lens | Alexander | Analyzer 결과를 코드 옆에 강조 |
| YAML | Red Hat | YAML 편집 지원 |
| Image Preview | Kiss Tamás | 이미지 경로 Preview |
| Remove Comments | plibither8 | 주석 제거 편의 기능 |
| vscode-icons | VSCode Icons Team | Explorer 아이콘 개선 |

> VS Code Extension을 설치할 때는 이름뿐 아니라 Publisher도 확인한다.

## DevTools

| Tool | 역할 |
| --- | --- |
| Inspector | Widget Tree / Layout 확인 |
| Performance | Jank Frame 발견 / UI-Raster 병목 1차 분류 |
| CPU Profiler | CPU를 많이 사용하는 Dart 함수 분석 |
| Memory | Dart Heap / 객체 / GC / 메모리 증가 조사 |
| Network | HTTP / HTTPS / WebSocket 분석 |
| Deep Links | Deep Link 설정 및 연결 검증 |
| App Size | 앱 크기 분석 |
| DTD Tools | Dart Tooling 연결용 기능 |

이번 실습은 Inspector, Performance, CPU Profiler를 중심으로 사용한다.

### Performance와 CPU Profiler

```text
Performance
→ 언제 느렸는가?
→ UI / Raster 중 어느 단계인가?

CPU Profiler
→ 어떤 Dart 함수가 CPU를 많이 사용했는가?
```

Performance는 느린 Frame을 찾고 UI/Raster 중 어느 단계가 병목인지 1차로 구분한다. 정확한 Dart 코드 라인을 찾는 용도로 설명하지 않는다. `Run Slow UI Work`는 교육을 위해 UI Isolate를 약 80ms 동안 의도적으로 막아 UI Jank를 만든다. 실제 앱에서는 이런 방식으로 작업하면 안 된다. 별도의 Raster Jank 예제는 포함하지 않는다.

## 용어 정리

| 용어 | 설명 |
| --- | --- |
| Widget | Flutter UI를 선언하는 기본 구성 단위 |
| Widget Tree | Widget의 부모-자식 구조 |
| State | 변경 가능한 UI 상태 |
| Formatter | 코드 모양 정리 |
| Analyzer | Dart 코드 문제 분석 |
| Linter | 코드 품질/일관성/안전성을 위한 추가 규칙 |
| Symbol | 클래스, 함수, 변수 등 코드 식별 요소 |
| Scope | 현재 코드에서 접근 가능한 범위 |
| Stack Frame | 함수 호출 한 단계의 실행 상태 |
| Call Stack | 현재 위치까지의 함수 호출 경로 |
| Isolate | Dart의 독립 실행 단위 |
| UI Isolate | Flutter 주요 Dart/UI 로직이 실행되는 기본 Isolate |
| Frame | 화면 한 장 |
| FPS | 초당 Frame 수 |
| Jank | Frame deadline 초과로 발생하는 끊김 |
| Raster | Scene을 실제 Pixel로 렌더링하는 과정 |
| Profile Mode | 성능 분석을 위한 Flutter Build Mode |
| Package | 재사용 가능한 Dart/Flutter 코드 단위 |

## 검증

앱 루트에서 실행한다.

```sh
flutter pub get
flutter analyze
flutter test
```

Package를 독립적으로 검증한다.

```sh
cd packages/seminar_utils
flutter analyze
flutter test
```
