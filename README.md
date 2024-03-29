# MyPup

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![License: MIT][license_badge]][license_link]

An app that provides tips catered to a puppy's growth stage built with Flutter & Firebase; generated by the [Very Good CLI][very_good_cli_link] 🤖:

![mypup-screenshots](https://github.com/thywang/mypup/assets/88808428/58ec7f27-9fb6-40d1-bb93-14d92f1ea9ed)

> **Note**: this project is a work in progress as tests need to be added.

## Prototype

The prototype built with Figma is available here:

- [MyPup | Figma design](https://www.figma.com/file/o4OCyXPchTgcYt75JpGRvy/MyPup?type=design&node-id=1%3A11&mode=design&t=HeFlKyziI33hFHNV-1
)

## Demo

- **Home page** that shows a Tip of the Day (selected randomly daily from Firestore Database filtered by the puppy's growth stage).

![home](https://github.com/thywang/mypup/assets/88808428/b8ad5f51-6316-4170-961a-7843454da8b7)

- **Tips**: general, training, health, and games tips are filtered by the puppy's growth stage and fetched via Firestore stream to get realtime updates.

![tip](https://github.com/thywang/mypup/assets/88808428/13f37660-5b88-47ba-a1af-3a03371e3aed) ![tip2](https://github.com/thywang/mypup/assets/88808428/ea060a89-b852-4fb7-b069-eb0d1eadae51)

- **Clicker** with a 3D clickable button to assist training. Read more about how to use [here](https://www.akc.org/expert-advice/training/clicker-training-your-dog-mark-and-reward/).

![clicker](https://github.com/thywang/mypup/assets/88808428/a4575121-29b4-418e-95c4-13206354e629)

- **Puppy Profile**: user can update their puppy's profile picture, name, birthdate and owner's name.
  
![profile](https://github.com/thywang/mypup/assets/88808428/41c10884-b155-45af-877d-ff09f3fdccb6)

The Puppy Profile data is persisted with SharedPreferences.

---

## Getting Started 🚀

This project contains 3 flavors:

- development
- staging
- production

To run the desired flavor either use the launch configuration in VSCode/Android Studio or use the following commands:

```sh
# Development
$ flutter run --flavor development --target lib/main_development.dart

# Staging
$ flutter run --flavor staging --target lib/main_staging.dart

# Production
$ flutter run --flavor production --target lib/main_production.dart
```

_\*MyPup works on iOS, Android, Web, and Windows._

---

## Running Tests 🧪

To run all unit and widget tests use the following command:

```sh
$ flutter test --coverage --test-randomize-ordering-seed random
```

To view the generated coverage report you can use [lcov](https://github.com/linux-test-project/lcov).

```sh
# Generate Coverage Report
$ genhtml coverage/lcov.info -o coverage/

# Open Coverage Report
$ open coverage/index.html
```

---

## Working with Translations 🌐

This project relies on [flutter_localizations][flutter_localizations_link] and follows the [official internationalization guide for Flutter][internationalization_link].

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```

3. Use the new string

```dart
import 'package:my_pup_simple/l10n/l10n.dart';

@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist` at `ios/Runner/Info.plist` to include the new locale.

```xml
    ...

    <key>CFBundleLocalizations</key>
	<array>
		<string>en</string>
		<string>es</string>
	</array>

    ...
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

### Generating Translations

To use the latest translations changes, you will need to generate them:

1. Generate localizations for the current project:

```sh
flutter gen-l10n --arb-dir="lib/l10n/arb"
```

Alternatively, run `flutter run` and code generation will take place automatically.

[coverage_badge]: coverage_badge.svg
[flutter_localizations_link]: https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html
[internationalization_link]: https://flutter.dev/docs/development/accessibility-and-localization/internationalization
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://github.com/VeryGoodOpenSource/very_good_cli
