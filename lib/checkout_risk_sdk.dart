import 'package:checkout_risk_sdk/enums/environments.dart';

import 'checkout_risk_sdk_platform_interface.dart';

class CheckoutRiskSdk {
  Future<String?> getPlatformVersion() {
    return CheckoutRiskSdkPlatform.instance.getPlatformVersion();
  }

  /// Initializes the Checkout Risk SDK with the provided public key and environment.
  ///
  /// This method must be called before using any other functionality of the SDK.
  ///
  /// [publicKey] The public key provided by Checkout for authentication.
  /// [environment] The environment to be used, represented by the [CheckoutRiskEnvironment] enum.
  /// Possible values are:
  /// - [CheckoutRiskEnvironment.sandbox]: For testing purposes.
  /// - [CheckoutRiskEnvironment.production]: For live transactions.
  ///
  /// Throws an exception if initialization fails.
  Future<void> initialize(
      String publicKey, CheckoutRiskEnvironment environment) async {
    await CheckoutRiskSdkPlatform.instance
        .initialize(publicKey, environment.value);
  }

  /// Publishes data using the CheckoutRiskSdkPlatform instance.
  ///
  /// Returns a [Future] that completes with a [String] containing the result token of the publish operation,
  /// or `null` if the operation fails.
  ///
  Future<String?> publishData() async {
    return CheckoutRiskSdkPlatform.instance.publishData();
  }
}
