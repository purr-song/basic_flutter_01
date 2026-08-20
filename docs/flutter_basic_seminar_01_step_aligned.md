# Flutter Basic Seminar 01

## 개발 환경 · 실행 · 디버깅 · DevTools

> 이 문서는 실습 저장소의 Git Tag 순서와 맞춰 진행한다.
>
> ```text
> step-00-initial
>   ↓
> step-01-assets
>   ↓
> ...
>   ↓
> step-14-cpu-profiler
> ```
>
> 원하는 단계로 이동:
>
> ```sh
> git switch --detach step-07-breakpoint
> ```
>
> 다시 기본 Branch로:
>
> ```sh
> git switch main
> ```
>
> 기본 Branch 이름이 다르면 해당 Branch 이름을 사용한다.

---

# 0. 세미나 목표

이번 세미나에서는 Flutter 문법을 많이 외우는 것보다 다음 흐름에 익숙해지는 것을 목표로 한다.

```text
개발환경 확인
    ↓
프로젝트 실행
    ↓
코드 수정
    ↓
실행 상태 관찰
    ↓
문제 발생
    ↓
Debugger / DevTools로 원인 조사
```

이번 시간에 다루는 주요 내용:

- Flutter / Dart 개발환경
- VS Code 기본 기능
- Flutter CLI
- Flutter App과 Package 차이
- Asset
- Debug / Profile / Release
- Hot Reload / Hot Restart
- Logging / Stack Trace
- Breakpoint / Call Stack / Watch
- Widget Inspector
- Constraints
- Performance
- UI / Raster / Jank
- Isolate / UI Isolate
- CPU Profiler

---

# 1. 개발환경 준비

## Flutter 개발환경 확인

```sh
flutter --version
flutter doctor
flutter doctor -v
flutter devices
flutter emulators
```

### `flutter doctor`

Flutter 개발에 필요한 환경이 정상인지 확인한다.

예를 들어:

```text
Flutter SDK
Android SDK
Xcode
Chrome
Device
```

등의 상태를 확인할 수 있다.

문제가 생겼을 때 무조건 `flutter clean`부터 실행하기보다 먼저:

```sh
flutter doctor
```

로 환경 문제인지 확인하는 습관을 들이는 것이 좋다.

---

# 2. VS Code Extension

처음부터 모든 Extension을 설치하지 않는다.

이번 세미나에서는 Flutter 개발 자체와 직접 관련된 기본 편의 Extension만 사용한다.

> Extension 설치 시 **Extension 이름뿐 아니라 Publisher도 확인한다.**

| Extension | Publisher | 역할 |
|---|---|---|
| **Flutter** | Dart Code | Flutter 실행, Debugging, Hot Reload/Restart, DevTools |
| **Dart** | Dart Code | Analyzer, Completion, Formatting, Refactoring |
| **Error Lens** | Alexander | Analyzer의 Error/Warning을 코드 옆에 강조 |
| **YAML** | Red Hat | `pubspec.yaml`, `analysis_options.yaml` 등 YAML 편집 지원 |
| **Image Preview** | Kiss Tamás | 이미지 파일 경로를 미리보기 |
| **Remove Comments** | plibither8 | 주석 제거 편의 기능 |
| **vscode-icons** | VSCode Icons Team | Explorer 파일/폴더 아이콘 개선 |

Flutter Extension을 설치하면 Dart Extension도 함께 설치된다.

### Error Lens의 역할

Error Lens가 직접 코드를 분석하는 것은 아니다.

```text
Dart Analyzer
    ↓
문제 탐지

Error Lens
    ↓
Analyzer 결과를 더 잘 보이게 표시
```

### Image Preview 주의

Image Preview는 Flutter 전용 Extension이 아니다.

따라서:

```dart
Image.asset('assets/images/flutter_logo.png')
```

같은 Flutter project-root 기준 asset path를 항상 해석하는 것은 아니다.

실제 파일 기준 상대 경로에서는 Preview가 더 잘 동작할 수 있다.

---

# 3. VS Code 기본 사용

| 기능 | Mac | 역할 |
|---|---|---|
| Command Palette | `Cmd + Shift + P` | VS Code 명령 검색 |
| Quick Open | `Cmd + P` | 파일 빠르게 열기 |
| Quick Fix | `Cmd + .` | Code Action / Refactoring |
| Go to Definition | `Cmd + Click` | 정의 위치 이동 |
| Find References | `Shift + F12` | 사용 위치 검색 |
| Rename Symbol | `F2` / `fn + F2` | Symbol 이름과 참조 변경 |

## Rename Symbol vs Replace

```text
Replace
→ 같은 문자열을 찾고 변경

Rename Symbol
→ Analyzer가 같은 코드 Symbol인지 판단하여 정의와 참조를 변경
```

예:

```dart
class UserService {}

final service = UserService();
```

`UserService`를 Rename Symbol로 변경하면 정의와 실제 참조가 같이 변경된다.

문자열:

```dart
'UserService'
```

같은 값까지 무조건 바뀌는 기능은 아니다.

---

# 4. Formatter / Analyzer / Linter

이 세 가지는 구분해서 이해하는 것이 좋다.

## Formatter

```text
코드의 모양을 정리
```

예:

- 들여쓰기
- 줄바꿈
- 공백
- trailing comma에 따른 줄 배치

VS Code에서:

```text
Format On Save
```

를 켜두면 편하다.

예:

```json
{
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "Dart-Code.dart-code"
  }
}
```

---

## Analyzer

Dart 코드를 분석하는 도구다.

예:

```dart
final int count = 'hello';
```

타입이 맞지 않는 문제 등을 찾아낸다.

---

## Linter

문법적으로 실행 가능한 코드라도:

> 코드 품질, 일관성, 안전성을 위해 권장하거나 피해야 할 패턴

을 검사한다.

예:

```yaml
prefer_const_constructors: true
```

```dart
Text('Hello')
```

는 동작하지만:

```dart
const Text('Hello')
```

로 만들 수 있다는 lint가 표시될 수 있다.

정리:

```text
Analyzer
= 코드를 분석하는 엔진

Linter
= Analyzer가 적용하는 추가 규칙
```

---

# 5. Flutter CLI

| 명령 | 역할 |
|---|---|
| `flutter --version` | Flutter / Dart Version |
| `flutter doctor` | 환경 확인 |
| `flutter devices` | Device 목록 |
| `flutter create` | Project 생성 |
| `flutter run` | Debug 실행 |
| `flutter run --profile` | Profile 실행 |
| `flutter run --release` | Release 실행 |
| `flutter analyze` | Analyzer / Lint |
| `flutter test` | Test |
| `flutter logs` | Device Log |
| `flutter clean` | Build 생성물 정리 |

명령 사용법을 모를 때:

```sh
flutter create --help
flutter run --help
flutter build --help
```

`--help`를 활용하는 습관을 들인다.

---

# Step 00 — Initial App

Tag:

```text
step-00-initial
```

기본 Flutter App 상태를 확인한다.

일반 Flutter App 생성:

```sh
flutter create flutter_basic_seminar
```

대표 구조:

```text
flutter_basic_seminar/
├── android/
├── ios/
├── lib/
│   └── main.dart
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

## App으로 생성했을 때 Android / iOS가 있는 이유

Flutter App은 실제 Android / iOS에서 실행되는 Application이므로 Native Host가 필요하다.

Android 기준 기본 진입점은 보통:

```kotlin
class MainActivity : FlutterActivity()
```

초보자 단계에서는 다음 정도로 이해하면 충분하다.

```text
Android
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

일반적인 Flutter App에서는 하나의 `FlutterActivity`를 중심으로 Flutter 화면이 동작한다.

Flutter 내부의 화면 이동:

```text
Home
→ Detail
→ Settings
```

이 일어날 때마다 Android Activity가 반드시 새로 생기는 것은 아니다.

보통 같은 Flutter Host 안에서 Flutter의 Widget Tree가 바뀐다.

> 단, 여러 Activity, Add-to-App, Cached FlutterEngine 등 다른 구조도 가능하다.

---

# Step 01 — Assets

Tag:

```text
step-01-assets
```

실습 프로젝트:

```text
assets/
└── images/
    └── flutter_logo.png
```

`pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

사용:

```dart
Image.asset(
  'assets/images/flutter_logo.png',
)
```

이 단계에서 함께 확인:

```text
Asset 등록
pubspec.yaml
YAML Extension
Image Preview
Image.asset()
```

## 왜 pubspec에 등록하는가?

Flutter Asset은 단순히 파일을 프로젝트 폴더에 넣는 것으로 끝나지 않는다.

Flutter build system에게:

> 이 파일을 Application Asset에 포함해라.

라고 알려줘야 한다.

그 역할을 `pubspec.yaml`이 한다.

---

# Step 02 — Counter

Tag:

```text
step-02-counter
```

실습 요소:

```text
Scaffold
Image
Count
FloatingActionButton
setState()
```

대표 코드:

```dart
int _counter = 0;

void _incrementCounter() {
  setState(() {
    _counter++;
  });
}
```

이 단계에서는 `StatefulWidget` 내부의 값이 변경되면:

```text
State 변경
   ↓
setState()
   ↓
build() 다시 실행
   ↓
화면 갱신
```

정도로 이해하면 충분하다.

> Widget Lifecycle 자체는 다음 세미나에서 더 자세히 다룬다.

---

# Step 03 — Hot Reload / Hot Restart

Tag:

```text
step-03-hot-reload
```

확인용 코드:

```dart
void main() {
  debugPrint('main');
  runApp(const MyApp());
}
```

```dart
@override
void initState() {
  super.initState();
  debugPrint('initState');
}
```

## Hot Reload

실행 중 Dart 코드 변경 내용을 반영한다.

일반적으로:

```text
State 유지
main() 재실행 X
기존 State의 initState() 재실행 X
```

Counter를 증가시킨 뒤 Hot Reload하면 Count가 유지되는지 확인한다.

---

## Hot Restart

Dart Application을 다시 시작한다.

```text
State 초기화
main() 재실행 O
State 다시 생성
initState() 재실행 O
```

터미널:

```text
r → Hot Reload
R → Hot Restart
q → 종료
```

Native 코드, AndroidManifest, Info.plist, Plugin native implementation 등은 Hot Reload만으로 반영되지 않을 수 있다.

---

# Step 04 — Build Mode

Tag:

```text
step-04-build-mode
```

Flutter Build Mode:

```text
Debug
Profile
Release
```

Flavor / Environment:

```text
dev
staging
prod
```

이 둘은 다른 개념이다.

```text
Debug / Profile / Release
= Build Mode

dev / staging / prod
= Flavor / Environment
```

예:

```text
staging + Debug
staging + Release
prod + Release
```

처럼 조합할 수 있다.

| Mode | 목적 | Hot Reload | Debugger | Performance 측정 |
|---|---|---:|---:|---:|
| Debug | 개발 | O | O | 적합하지 않음 |
| Profile | 성능 측정 | X | 제한적 | O |
| Release | 배포 | X | 일반 Debug X | 일반 Profiling X |

현재 Mode 확인:

```dart
kDebugMode
kProfileMode
kReleaseMode
```

Profile은 쉽게:

> Release와 비슷한 실행 특성을 유지하면서 성능 분석 기능을 남겨둔 Mode

라고 이해한다.

---

# Step 05 — Logging

Tag:

```text
step-05-logging
```

## `print`

Dart 기본 출력 함수.

```dart
print('hello');
```

## `debugPrint`

Flutter에서 제공하는 출력 함수.

```dart
debugPrint('hello');
```

많은 로그가 한꺼번에 출력될 때 출력량을 조절하는 동작이 있다.

중요:

```text
debugPrint()
≠
Debug Mode에서만 출력되는 함수
```

Debug Mode에서만 로그를 남기고 싶다면:

```dart
if (kDebugMode) {
  debugPrint('debug only');
}
```

실무에서는 추후 Logger abstraction을 두는 경우가 많다.

---

# Step 06 — Stack Trace

Tag:

```text
step-06-stack-trace
```

실습 호출 흐름:

```text
onPressed
↓
handleErrorButton
↓
throwTestException
```

Exception:

```dart
throw Exception('Seminar test exception');
```

Stack Trace에는:

```text
main.dart:128:13
```

같은 정보가 나온다.

의미:

```text
128 → Line
13  → Column
```

## Stack Trace 읽는 요령

Framework 내부 Stack이 많이 보이더라도 처음부터 전부 읽을 필요는 없다.

먼저:

> 내 프로젝트의 Dart 파일이 처음 등장하는 위치

를 찾는다.

그리고 위아래 호출 관계를 본다.

---

# Step 07 — Breakpoint

Tag:

```text
step-07-breakpoint
```

예:

```dart
void increment() {
  final next = calculateNextValue(_counter);

  setState(() {
    _counter = next;
  });
}

int calculateNextValue(int current) {
  return current + 1;
}
```

## Breakpoint

코드 실행을 특정 위치에서 멈춘다.

Run and Debug 화면에서 주로 확인:

```text
VARIABLES
WATCH
CALL STACK
BREAKPOINTS
```

## Step Over

```text
현재 Line 실행
→ 호출 함수 내부에는 들어가지 않음
→ 다음 Line
```

## Step Into

```text
호출 함수 내부로 이동
```

## Step Out

```text
현재 함수 실행을 끝냄
→ 호출한 함수로 돌아감
```

---

# Step 08 — Conditional Breakpoint

Tag:

```text
step-08-conditional-breakpoint
```

예:

```dart
for (var i = 0; i < 100; i++) {
  calculate(i);
}
```

일반 Breakpoint라면 100번 멈출 수 있다.

Conditional Breakpoint:

```text
i == 50
```

를 설정하면 해당 조건이 참일 때만 멈춘다.

설정:

```text
Breakpoint 우클릭
→ Edit Breakpoint
```

주의:

> VS Code UI에 Condition 문자열이 Breakpoints 목록에 항상 직접 표시되는 것은 아니다.

필요하면 Edit Breakpoint에서 확인한다.

---

# Step 09 — Watch / Scope / Debug Console

Tag:

```text
step-09-watch
```

예:

```dart
void calculatePrice() {
  final price = 10000;
  final discount = 0.2;
  final result = price * (1 - discount);

  debugPrint('$result');
}
```

`debugPrint()` 줄에 Breakpoint를 둔다.

## VARIABLES

현재 Scope에서 접근 가능한 변수를 자동으로 보여준다.

```text
price
discount
result
```

## WATCH

내가 계속 확인하고 싶은 표현식을 등록한다.

예:

```text
price
discount
result
price * (1 - discount)
```

## Debug Console

Pause 상태에서 Dart Expression을 직접 실행해볼 수 있다.

예:

```text
price
price * 2
result
```

---

## Scope란?

현재 코드 위치에서 접근할 수 있는 변수의 범위다.

예를 들어:

```dart
void calculatePrice() {
  final price = 10000;
}
```

`price`는 이 함수 밖에서는 접근할 수 없다.

Watch에서:

```text
Undefined name
```

이 나온다면 현재 선택된 Stack Frame에서 해당 변수가 Scope 밖일 수 있다.

---

## Stack Frame

Call Stack의 각 함수 호출 한 단계라고 생각하면 된다.

```text
onPressed
↓
calculatePrice
```

현재 선택한 Stack Frame이 바뀌면 Variables / Watch에서 접근 가능한 Scope도 달라질 수 있다.

---

# Step 10 — Package

Tag:

```text
step-10-package
```

Flutter App과 Flutter Package는 생성 목적이 다르다.

## App

```sh
flutter create sample_app
```

대표 구조:

```text
sample_app/
├── android/
├── ios/
├── lib/
└── ...
```

목적:

> 실제로 실행할 Application

---

## Package

```sh
flutter create --template=package seminar_utils
```

대표 구조:

```text
seminar_utils/
├── lib/
├── test/
└── pubspec.yaml
```

일반 App용:

```text
android/
ios/
```

Host 프로젝트는 없다.

| 구분 | App | Package |
|---|---|---|
| 목적 | 실행 | 코드 재사용 |
| Android Host | O | X |
| iOS Host | O | X |
| lib | O | O |
| 독립 실행 | O | 일반적으로 X |
| Dependency로 사용 | 주 목적 아님 | O |

정리:

```text
App
= 실행 단위

Package
= 재사용 단위
```

---

## 언제 Package로 분리할까?

대표적으로:

- 여러 기능에서 공통 사용
- 여러 App에서 재사용
- 독립적으로 테스트하기 좋음
- 독립 개발/관리하는 것이 유리함
- 공통 UI
- Utility
- Logging
- Network 공통 코드

예:

```text
packages/
└── seminar_utils/
```

```dart
abstract final class SeminarFormatter {
  static String counterText(int count) {
    return 'Count: $count';
  }
}
```

App:

```yaml
dependencies:
  seminar_utils:
    path: packages/seminar_utils
```

```dart
Text(
  SeminarFormatter.counterText(_counter),
)
```

Package로 나누었다고 해서 자동으로 좋은 Architecture가 되는 것은 아니다.

```text
한 App 안에서만 쓰고 단순함
→ lib/ 내부에 유지

재사용 / 독립 테스트 / 독립 관리 가치가 큼
→ Package 고려
```

---

# Step 11 — Widget Inspector

Tag:

```text
step-11-widget-inspector
```

DevTools의 Inspector를 연다.

주요 기능:

```text
Select Widget Mode
Widget Tree
Source 위치
Size
Constraints
Padding
```

예제 Widget Tree:

```text
Scaffold
└── SafeArea
    └── Center
        └── Column
            ├── Image
            ├── Text
            └── Container
```

## Select Widget Mode

Inspector에서 선택 모드를 켜고 실제 Application UI를 클릭한다.

그러면:

```text
화면의 Widget
↓
Widget Tree의 위치
↓
Source Code
```

를 연결해서 확인할 수 있다.

이번 세미나에서는 `Element`, `RenderObject` 내부 구조까지는 다루지 않는다.

---

# Step 12 — Layout / Constraints

Tag:

```text
step-12-layout
```

실습 예제:

```dart
Container(
  width: 200,
  height: 100,
  padding: const EdgeInsets.all(16),
  child: const Text('Hello Flutter'),
)
```

이 Widget을 Inspector에서 선택하고 다음을 확인한다.

```text
Size
Constraints
Padding
```

---

## Constraints란?

Flutter에서 자식 Widget이 원하는 크기를 무조건 사용할 수 있는 것은 아니다.

부모가 먼저:

> 자식이 사용할 수 있는 크기의 범위

를 전달한다.

이 범위를 **Constraints**라고 한다.

단순화하면:

```text
Parent
   ↓
Constraints 전달

Child
   ↓
Constraints 안에서 Size 결정
```

Constraints에는 개념적으로 다음 범위가 있다.

```text
minWidth
maxWidth
minHeight
maxHeight
```

예를 들어 부모가:

```text
너비: 0 ~ 400
높이: 0 ~ 800
```

범위를 허용했다면 자식은 그 범위 안에서 자신의 Size를 결정한다.

---

## Size와 Constraints는 다르다

```text
Constraints
= 부모가 허용한 범위

Size
= 자식이 최종적으로 가지게 된 실제 크기
```

예를 들어 Inspector에서:

```text
Constraints:
0 <= width <= 400
0 <= height <= 800

Size:
200 × 100
```

처럼 보인다면:

```text
부모가 허용한 범위 안에서
Container가 200 × 100 크기를 사용했다
```

고 볼 수 있다.

---

## `width: 200`이면 항상 200인가?

반드시 그렇지는 않다.

```dart
Container(
  width: 200,
)
```

라고 작성한 것은:

> 가능하다면 이 정도 너비를 사용하고 싶다.

는 의미에 가깝다.

부모가 더 강한 Constraints를 주면 부모의 Constraints 영향을 받는다.

그래서 Flutter에서 Widget 크기가 예상과 다를 때:

```text
왜 width를 줬는데 안 먹지?
왜 화면 전체를 차지하지?
왜 Row 안에서 크기가 이상하지?
```

같은 문제가 생기면 자식 Widget의 `width`만 볼 것이 아니라:

> 부모가 어떤 Constraints를 전달했는가?

를 같이 확인해야 한다.

---

## Flutter Layout을 기억하는 문장

Flutter 공식 Layout 개념을 설명할 때 자주 쓰는 표현:

```text
Constraints go down.
Sizes go up.
```

의미:

```text
Parent
→ Child에게 Constraints 전달

Child
→ 자신의 Size 결정
→ Parent에게 알려줌
```

이번 단계에서는 Layout Engine을 깊게 이해할 필요는 없다.

딱 이것만 기억한다.

> **Widget 크기는 자기 자신의 width/height만으로 결정되지 않는다. 부모가 전달한 Constraints 안에서 Size가 결정된다.**

---

# DevTools 전체 기능 한번 보기

이 시점에 DevTools의 다른 메뉴도 가볍게 살펴본다.

| Tool | 언제 사용하는가 |
|---|---|
| **Inspector** | Widget Tree / Layout 확인 |
| **Performance** | 느린 Frame과 UI/Raster 병목 확인 |
| **CPU Profiler** | CPU를 많이 사용하는 Dart 함수 조사 |
| **Memory** | Heap, Object, GC, Memory 증가 조사 |
| **Network** | HTTP/HTTPS/WebSocket 요청 확인 |
| **Deep Links** | Deep Link 설정 검증 |
| **App Size** | App 크기와 구성 요소 분석 |
| **DTD Tools** | Dart Tooling 연결용 기능 |

이번 세미나의 핵심:

```text
Inspector
Performance
CPU Profiler
```

---

# Step 13 — Performance / UI Jank

Tag:

```text
step-13-performance
```

실습 함수:

```dart
void runIntentionallySlowUiWork() {
  final stopwatch = Stopwatch()..start();
  var checksum = 0;

  while (stopwatch.elapsedMilliseconds < 80) {
    checksum =
        (checksum + stopwatch.elapsedMicroseconds) %
        1000003;
  }

  stopwatch.stop();

  debugPrint(
    'Slow UI work: '
    '${stopwatch.elapsedMilliseconds} ms '
    '($checksum)',
  );
}
```

이 코드는 **성능 문제를 일부러 만들기 위한 교육용 코드**다.

실제 Application에서 이런 Busy Loop를 작성하라는 의미가 아니다.

---

## 이 코드는 무엇을 하는가?

```text
Stopwatch 시작
↓
80ms가 지날 때까지 while 반복
↓
계속 CPU 연산
↓
현재 Dart 실행 흐름을 점유
```

`checksum` 계산 자체에는 특별한 비즈니스 의미가 없다.

CPU가 실제 계산을 계속 수행하게 만들고 값이 지나치게 커지는 것을 막기 위한 예제다.

---

# Frame

화면 한 장을 Frame이라고 한다.

60Hz Display라면 대략:

```text
1000ms / 60
≈ 16.67ms
```

120Hz라면:

```text
1000ms / 120
≈ 8.33ms
```

정도의 시간 안에 다음 Frame을 준비해야 한다.

---

# Jank

`Jank`는 UI가:

```text
뚝뚝 끊김
버벅임
Frame을 제때 보여주지 못함
```

같이 느껴지는 현상을 말한다.

즉:

> Frame deadline을 놓친 상태

라고 이해하면 된다.

---

# UI

DevTools Performance의 UI는 주로 Flutter/Dart 쪽에서 다음 화면을 준비하는 작업과 관련된다.

단순화:

```text
Event 처리
↓
Dart 코드
↓
build
↓
layout
↓
paint 정보 준비
↓
Scene 준비
```

---

# Raster

`Raster`는 **Rasterization**에서 온 이름이다.

Flutter가 준비한 Scene을 실제 화면의 Pixel로 렌더링하는 과정이다.

```text
Flutter Framework
↓
Scene
↓
Raster
↓
GPU
↓
Pixels
↓
Display
```

예를 들어 Raster 비용이 커질 수 있는 요소:

```text
큰 Image
Blur
BackdropFilter
Shadow
Clip
복잡한 CustomPaint
복잡한 Layer
```

---

# Performance 탭은 무엇을 알려주는가?

여기서 중요한 점:

> Performance 탭이 항상 "main.dart 몇 번째 줄이 문제"라고 알려주는 것은 아니다.

Performance의 1차 역할은:

```text
느린 Frame 발견
       ↓
UI가 느렸는가?
Raster가 느렸는가?
```

를 구분하는 것이다.

```text
Jank Frame
   ↓
┌──────────────┐
│              │
UI Jank     Raster Jank
│              │
Dart/CPU     Rendering
조사          구조 조사
```

Timeline Events도 Engine / Frame 흐름을 분석하는 데 도움을 주지만,
항상 특정 Dart source line까지 바로 연결해주는 것은 아니다.

---

# Step 14 — CPU Profiler

Tag:

```text
step-14-cpu-profiler
```

Step 13의 CPU 작업을 더 구체적으로 조사한다.

호출 흐름:

```text
onPressed
↓
runSlowWorkDemo
↓
runIntentionallySlowUiWork
```

## Performance와 CPU Profiler의 차이

```text
Performance
→ 어느 Frame이 느렸는가?
→ UI / Raster 중 어느 단계인가?

CPU Profiler
→ 어떤 Dart 함수가 CPU 시간을 사용했는가?
```

따라서:

```text
Performance에서 UI Jank 발견
        ↓
CPU Profiler
        ↓
CPU를 많이 사용하는 Dart 함수 조사
```

라는 흐름으로 사용할 수 있다.

---

# Isolate

Dart의 **독립적인 실행 단위**다.

각 Isolate는 기본적으로 서로 메모리를 공유하지 않는다.

Dart Application은 기본적으로 Main Isolate에서 시작한다.

---

# UI Isolate

Flutter App에서 Dart UI 작업이 주로 실행되는 기본 Isolate를 흔히 UI Isolate라고 부른다.

여기서 수행되는 예:

```text
Button Event Callback
setState()
build()
Dart 계산
Timer Callback
```

Step 13의:

```dart
while (stopwatch.elapsedMilliseconds < 80) {
  ...
}
```

가 UI Isolate에서 실행되면 약 80ms 동안 다른 Dart 작업을 처리하기 어렵다.

```text
UI Isolate
↓
80ms CPU 작업
↓
다음 Frame 준비 지연
↓
UI Jank 가능
```

---

## Flutter Rendering 전체가 UI Isolate에서 실행되는 것은 아니다

주의할 점:

> Flutter의 실제 Rendering 전체가 UI Isolate 하나에서 실행되는 것은 아니다.

단순화:

```text
UI Isolate
→ Dart 코드
→ Widget / Build / Layout 등

Raster 쪽
→ Engine
→ Scene을 실제 Pixel로 Rendering
```

그래서 Performance에서 UI와 Raster 시간이 따로 보인다.

---

# Memory

Memory Tool은:

```text
Dart Heap
Object
GC
Memory 사용량
```

등을 확인하는 도구다.

예:

```text
화면을 열고 닫을 때마다 메모리 계속 증가
Image를 반복해서 띄운 뒤 메모리가 내려오지 않음
특정 Object가 계속 살아있는 것 같음
```

등의 문제를 조사할 때 사용한다.

이번 세미나에서는 기능 소개만 한다.

---

# Network

Dart의 HTTP / HTTPS / WebSocket Traffic을 확인한다.

예:

```text
Request URL
Method
Status Code
Request Header
Request Body
Response
Timing
```

API 연동 수업에서 더 자세히 다룰 수 있다.

---

# Deep Links

예:

```text
https://example.com/product/123
```

을 눌렀을 때 Application의 특정 화면:

```text
ProductDetail(123)
```

로 이동하도록 연결하는 것이 Deep Link다.

DevTools의 Deep Links 기능은 이러한 설정을 검증할 때 사용한다.

---

# App Size

Application 크기가 왜 커졌는지 분석한다.

예:

```text
Dart Code
Native Code
Assets
Fonts
Package
```

등이 얼마나 차지하는지 확인한다.

Build A와 Build B의 Size 차이를 비교할 수도 있다.

이번 세미나에서는 기능 소개만 한다.

---

# DTD Tools

DTD:

```text
Dart Tooling Daemon
```

Dart 개발 도구 사이의 연결을 위한 Tooling 기능이다.

일반 Flutter Application 개발자가 직접 사용할 일은 많지 않다.

이번 세미나에서는:

> 이런 Tooling 기능도 있다.

정도로만 알고 넘어간다.

---

# 전체 용어 정리

| 용어 | 설명 |
|---|---|
| **Widget** | Flutter UI를 선언하는 기본 구성 단위 |
| **Widget Tree** | Widget의 부모-자식 구조 |
| **State** | 변경 가능한 UI 상태 |
| **Formatter** | 코드의 모양을 정리 |
| **Analyzer** | Dart 코드의 타입/문법/참조 문제 분석 |
| **Linter** | 코드 품질/일관성/안전성을 위한 추가 규칙 |
| **Symbol** | Class, Function, Variable 같은 코드 식별 요소 |
| **Scope** | 현재 위치에서 접근 가능한 변수 범위 |
| **Stack Frame** | 함수 호출 한 단계의 실행 상태 |
| **Call Stack** | 현재 위치까지의 함수 호출 경로 |
| **Constraints** | 부모가 자식에게 전달하는 허용 가능한 크기 범위 |
| **Size** | Widget이 실제로 결정한 크기 |
| **Isolate** | Dart의 독립적인 실행 단위 |
| **UI Isolate** | Flutter 주요 Dart/UI 코드가 실행되는 기본 Isolate |
| **Frame** | 화면 한 장 |
| **FPS** | Frames Per Second |
| **Jank** | Frame deadline을 놓쳐 발생하는 끊김 |
| **Raster** | Scene을 실제 Pixel로 렌더링하는 과정 |
| **Debug Mode** | 개발/Debugging을 위한 Build Mode |
| **Profile Mode** | 성능 분석을 위한 Build Mode |
| **Release Mode** | 실제 배포를 위한 Build Mode |
| **Flavor** | dev/staging/prod 같은 환경 구분 |
| **Package** | 재사용 가능한 Dart/Flutter 코드 단위 |

---

# 세미나 진행 순서 요약

실습 Tag와 동일하게 진행한다.

| Step | Tag | 내용 |
|---:|---|---|
| 00 | `step-00-initial` | Flutter Project / App 구조 |
| 01 | `step-01-assets` | Assets / YAML / Image Preview |
| 02 | `step-02-counter` | Counter / State / setState |
| 03 | `step-03-hot-reload` | Hot Reload / Hot Restart |
| 04 | `step-04-build-mode` | Debug / Profile / Release |
| 05 | `step-05-logging` | print / debugPrint |
| 06 | `step-06-stack-trace` | Exception / Stack Trace |
| 07 | `step-07-breakpoint` | Breakpoint / Step / Call Stack |
| 08 | `step-08-conditional-breakpoint` | Conditional Breakpoint |
| 09 | `step-09-watch` | Scope / Variables / Watch / Debug Console |
| 10 | `step-10-package` | App vs Package |
| 11 | `step-11-widget-inspector` | Widget Inspector |
| 12 | `step-12-layout` | Size / Constraints / Padding |
| 13 | `step-13-performance` | Frame / UI / Raster / Jank |
| 14 | `step-14-cpu-profiler` | CPU Profiler / UI Isolate |

---

# 이번 세미나에서 가져가야 할 것

모든 기능을 외울 필요는 없다.

다음 흐름만 기억하면 된다.

```text
앱이 이상하다
   ↓
로그를 본다
   ↓
필요하면 Breakpoint
   ↓
Widget 문제면 Inspector
   ↓
버벅이면 Performance
   ↓
UI CPU 문제면 CPU Profiler
```

그리고:

> Flutter 개발에서 중요한 것은 도구 이름을 외우는 것이 아니라, 문제가 생겼을 때 어떤 도구로 무엇을 확인할지 아는 것이다.

---

# 다음 세미나 예고

다음 시간에는 이번 실습에서 계속 사용한 Flutter UI 자체를 더 자세히 본다.

```text
Widget
↓
StatelessWidget
↓
StatefulWidget
↓
State
↓
build()
↓
setState()
↓
Widget Lifecycle
```

이후에는:

```text
App Lifecycle
↓
Android Activity
↓
iOS UIViewController
↓
FlutterEngine
↓
Plugin
↓
Platform Channel
↓
Module / Add-to-App
```

순으로 확장할 수 있다.
