# flutter_demo

Flutter sample app using Sendbird's Flutter plugin

## Setup
See [Flutter install instructions](https://flutter.dev/docs/get-started/install) for your platform and IDE.

Check Flutter status by running in Terminal: `flutter doctor`

Check which devices & emulators are available: `flutter devices`

### Android

SETUP:
```
flutter channel master
flutter upgrade
flutter clean
flutter run -d android
```
RUNNING: `flutter run -d <device_id>`

### iOS

SETUP:
```
flutter channel master
flutter upgrade
flutter clean
flutter build ios
```
RUNNING: `flutter run -d <device_id>`

### Web

SETUP:
```
flutter channel beta
flutter upgrade
flutter config --enable-web
flutter build web
```
RUNNING: `flutter run -d chrome`