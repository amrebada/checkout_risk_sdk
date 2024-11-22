# checkout_risk_sdk

Unofficial Flutter plugin for the Checkout.com Risk API.

## Content

- [Installation](#installation)
  - [Android](#android)
  - [iOS](#ios)
- [Usage](#usage)

## Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  checkout_risk_sdk: ^0.0.1
```

### Android

Add the following to your `android/build.gradle` file:

```gradle
allprojects {
    repositories {
        ...
        maven { url 'https://jitpack.io' }
        maven { url = uri("https://maven.fpregistry.io/releases") }
    }

}
```

Add the following to your `android/app/build.gradle` file:

```gradle
dependencies {
    ...
    implementation 'com.github.checkout:checkout-risk-sdk-android:2.0.0'
}
```

### iOS

No additional setup required.

## Usage

```dart
import 'package:checkout_risk_sdk/checkout_risk_sdk.dart';

void main() async {
    final sdk = CheckoutRiskSdk();
    await sdk.initialize(
        publicKey: 'pk_....',
        environment: CheckoutRiskEnvironment.sandbox,
    );

    ...

    final token = await sdk.publishData();
}
```
