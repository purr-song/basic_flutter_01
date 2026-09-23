# Flutter localization

## 1. Flutter localization의 전체 흐름

```text
ARB 파일 작성
→ flutter gen-l10n 실행
→ Dart localization 클래스 자동 생성
→ MaterialApp에 delegate와 supportedLocales 등록
→ 위젯에서 AppLocalizations.of(context) 사용
```

Flutter의 gen_l10n은 ARB의 key를 Dart getter 또는 method로 만들어준다.

## 2. 사용 예시

생성 파일 위치는 설정에 따라 다르게 만들 수 있다.

```text
apps/
  pubspec.yaml
  l10n.yaml

  lib/
    l10n/
      app_en.arb
      app_ko.arb
      app_th.arb

    generated/
      l10n/
        app_localizations.dart
        app_localizations_en.dart
        app_localizations_ko.dart
        app_localizations_th.dart
```

### 2.1 dependency 추가

apps/pubspec.yaml에 추가

```yaml
dependencies:
  flutter:
    sdk: flutter

  # 추가
  flutter_localizations:
    sdk: flutter

  intl: any

flutter:
  uses-material-design: true
  generate: true # 추가해준다. generated localization source를 사용하려면 generate: true가 필요
```

명령으로 추가하면:
```sh

flutter pub add flutter_localizations --sdk=flutter
flutter pub add intl:any
```

### 2.2 l10n.yaml 만들기

pubspec.yaml과 같은 위치에 만든다.  

apps/l10n.yaml

```yaml
# arb-dir → ARB 원본 파일 위치
arb-dir: lib/l10n

# template-arb-file → 기준이 되는 언어 파일
template-arb-file: app_en.arb

# output-dir → 생성되는 Dart 파일 위치
output-dir: lib/generated/l10n

# output-localization-file → 메인 생성 파일 이름
output-localization-file: app_localizations.dart

# output-class → 생성되는 localization 클래스 이름
output-class: AppLocalizations

# nullable-getter → AppLocalizations.of(context)가 nullable인지 여부. false를 쓰면 보통 다음처럼 ! 없이 사용할 수 있음.
nullable-getter: false
```

### 2.3 ARB 파일이란?

ARB는 JSON 형식의 localization 리소스 파일.  
모든 번역 파일에서 key를 동일하게 유지해야 한다.

```json
영문:

lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appName": "Laundry Crew",
  "homeTitle": "Home",
  "confirm": "Confirm",
  "cancel": "Cancel"
}

한글:

lib/l10n/app_ko.arb
{
  "@@locale": "ko",
  "appName": "Laundry Crew",
  "homeTitle": "홈",
  "confirm": "확인",
  "cancel": "취소"
}

태국어:

lib/l10n/app_th.arb
{
  "@@locale": "th",
  "appName": "Laundry Crew",
  "homeTitle": "หน้าหลัก",
  "confirm": "ยืนยัน",
  "cancel": "ยกเลิก"
}
```

#### 2.3.1 @key 메타데이터

ARB에서는 실제 key 앞에 @를 붙여 설명을 추가할 수 있다.실제 화면에 출력되는 문구가 아닌 번역가와 개발자를 위한 설명이다.

```json
{
  "deleteOrderTitle": "Delete this order?",
  "@deleteOrderTitle": {
    "description": "Title of the order deletion confirmation dialog"
  }
}
```

### 2.4 localization 코드 생성

ARB 파일은 사람이 수정하고 generated Dart 파일은 도구가 생성하므로 직접 수정 금지

```sh
flutter gen-l10n

# 또는 아래 명령에서도 자동 생성될 수 있다.

flutter pub get
flutter run
```

```text
lib/generated/l10n/
  app_localizations.dart
  app_localizations_en.dart
  app_localizations_ko.dart
  app_localizations_th.dart
```

### 2.5 MaterialApp에 등록

생성된 클래스를 import하고 MaterialApp에 등록

```dart
import 'package:laundry_app/generated/l10n/app_localizations.dart';

MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: router,
);
```

AppLocalizations.localizationsDelegates에는 앱 localization delegate뿐 아니라 Material, Widgets, Cupertino에 필요한 delegate가 함께 생성되는 구성이 일반적이다.

#### 2.5.1 GlobalMaterialLocalizations

Flutter가 제공하는 Material 위젯들의 문구를 번역해 보여주는 역할을 한다.

예를 들어 showDatePicker()를 호출하면 날짜 선택 화면에 이런 문구가 나올 수 있다.

```
CANCEL
OK
SELECT DATE

한국어라면:

취소
확인
날짜 선택
```

직접 ARB에 넣지 않았는데도 번역해서 보여주는데 그 역할을 한다. 

#### 2.5.2 GlobalWidgetsLocalizations

Flutter의 더 낮은 수준인 Widgets 계층의 현지화를 담당.  
Flutter의 기본 위젯 동작에 필요한 언어/방향 정보  

```
한국어와 영어는 왼쪽에서 오른쪽으로 읽는다.
LTR(Left To Right)

아랍어, 히브리어는 오른쪽에서 왼쪽으로 읽어.
RTL(Right To Left)
```

GlobalWidgetsLocalizations는 locale에 따라 이런 방향 정보를 Flutter 위젯 트리에 제공한다.

#### 2.5.3 GlobalCupertinoLocalizations

Cupertino는 iOS 스타일 위젯로 Cupertino 위젯이 사용하는 기본 문구와 날짜 형식을 현지화

```
CupertinoDatePicker
CupertinoAlertDialog
CupertinoNavigationBar
```

#### 2.5.4 delegate

현재 locale에 맞는 localization 객체를 생성해준다.

```
현재 locale이 한국어라면:

AppLocalizations.delegate
→ 한국어 AppLocalizations 생성

GlobalMaterialLocalizations.delegate
→ 한국어 MaterialLocalizations 생성

GlobalWidgetsLocalizations.delegate
→ 한국어/한국 환경의 Widget localization 생성

GlobalCupertinoLocalizations.delegate
→ 한국어 Cupertino localization 생성
```

Flutter가 생성한 AppLocalizations 클래스에는 보통 이런 목록이 만들어져 있다.

```dart
개념적으로는:

static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
  delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];
```

그래서 직접 네 개를 적지 않고 한 번에 쓸 수 있다.

```dart
MaterialApp.router(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: router,
);
```

하기와 같이 직접 작성해도 되며 위와 같은 의미이다. 대부분은 위의 방식을 사용한다.

```dart
MaterialApp.router(
  localizationsDelegates: const [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: const [
    Locale('en'),
    Locale('ko'),
    Locale('th'),
  ],
  routerConfig: router,
);
```

### 2.6 위젯에서 사용

```dart
import 'package:laundry_app/generated/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
      ),
      body: Center(
        child: Text(l10n.appName),
      ),
    );
  }
}
```

MaterialApp에 AppLocalizations.delegate가 등록되어 있어야 하고 사용하는 context가 MaterialApp 아래에 있어야 한다. 

#### 2.6.1 extension으로 더 편하게 사용하기

매번 AppLocalizations.of(context).homeTitle 이렇게 쓰는 게 길 수 있어서 앱 내부 extension을 만들기도 헌다.

```dart
lib/core/extensions/build_context_l10n_extension.dart
import 'package:flutter/widgets.dart';
import 'package:laundry_app/generated/l10n/app_localizations.dart';

extension BuildContextL10nExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

사용:

Text(context.l10n.homeTitle)
```

#### 2.6.2  변수 포함 문구: placeholder

생성된 코드는 getter가 아니라 method가 된다.

```json
영문:

{
  "welcomeUser": "Welcome, {name}!",
  "@welcomeUser": {
    "description": "Welcome message displayed on the home screen",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  }
}
```

```dart
Text(l10n.welcomeUser('Kim'))
```

문자열을 직접 조합하지 않아야 한다. 언어에 따라 이름이 들어가는 위치가 달라질 수 있기 때문이다.
```dart
비추천:
Text('${user.name}님, 환영합니다')

추천:
Text(l10n.welcomeUser(user.name))
```

Example:
```json
{
  "orderSummary": "{storeName}에서 {count}개를 주문했습니다.",
  "@orderSummary": {
    "description": "Summary of an order",
    "placeholders": {
      "storeName": {
        "type": "String"
      },
      "count": {
        "type": "int"
      }
    }
  }
}
```
```dart
Text(
  l10n.orderSummary(
    'Gangnam Laundry',
    3,
  ),
)
```

#### 2.6.3 복수형 plural

영어는 개수에 따라 단수와 복수가 달라진다.

```text
1 item
2 items
```

ARB:

```json
{
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of laundry items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

사용:

```dart
Text(l10n.itemCount(0))
Text(l10n.itemCount(1))
Text(l10n.itemCount(5))
```

결과:
```
No items
1 item
5 items
```

한글에서는 문법상 단복수 구분이 크지 않으므로 다음처럼 만들 수 있다.

```json
{
  "itemCount": "{count}개"
}
```

#### 2.6.4  조건 선택 select

성별이나 상태에 따라 문구를 다르게 할 수도 있다.

```json
{
  "orderStatus": "{status, select, pending{Pending} completed{Completed} failed{Failed} other{Unknown}}",
  "@orderStatus": {
    "placeholders": {
      "status": {
        "type": "String"
      }
    }
  }
}
```

사용:

```dart
Text(l10n.orderStatus('pending'))
```

단, 도메인 enum을 문자열로 무분별하게 넘기기보다는 presentation에서 명확히 변환하는 편이 좋다.

```dart
String localizedOrderStatus(
  AppLocalizations l10n,
  OrderStatus status,
) {
  return switch (status) {
    OrderStatus.pending => l10n.orderStatusPending,
    OrderStatus.completed => l10n.orderStatusCompleted,
    OrderStatus.failed => l10n.orderStatusFailed,
  };
}
```

도메인 상태가 몇 개 안 된다면 별도 key가 타입 안정성 면에서 더 이해하기 쉬울 수 있다.

#### 2.6.5 날짜와 숫자

날짜를 직접 문자열로 만들면 언어와 지역에 따라 표현 순서가 어긋날 수 있어.

한국 → 2026. 7. 19.
미국 → 7/19/2026

ARB에서 placeholder 형식 정보를 줄 수 있어.

{
  "orderDate": "Order date: {date}",
  "@orderDate": {
    "description": "Order creation date",
    "placeholders": {
      "date": {
        "type": "DateTime",
        "format": "yMMMd"
      }
    }
  }
}

사용:

Text(l10n.orderDate(order.createdAt))

숫자:

{
  "totalPrice": "Total: {price}",
  "@totalPrice": {
    "placeholders": {
      "price": {
        "type": "double",
        "format": "currency",
        "optionalParameters": {
          "decimalDigits": 0
        }
      }
    }
  }
}

다만 화폐는 국가와 결제 통화 정책이 들어가므로, 단순 locale만으로 결정하지 않고 실제 currencyCode를 명확히 관리하는 것이 안전해.

### 2.7 앱 언어는 기본적으로 어떻게 선택되는가?

Flutter가 기기의 locale과 앱 지원 locale을 비교해서 적절한 언어를 선택하고 설정된 fallback 정책에 따라 지원 locale 선택.  
기본적으로 supportedLocales의 첫 번째 locale로 fallback

#### 2.7.1 직접 언어 가능하게 하기

MaterialApp.locale을 상태로 관리

```dart
MaterialApp.router(
  locale: state.locale,
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  routerConfig: router,
);

Cubit 예:

class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  void changeLocale(Locale locale) {
    emit(locale);
  }

  void followSystem() {
    emit(null);
  }
}

사용:

context.read<LocaleCubit>().changeLocale(
  const Locale('ko'),
);
```
