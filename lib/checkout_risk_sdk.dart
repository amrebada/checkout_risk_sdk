import 'package:checkout_risk_sdk/enums/environments.dart';
import 'package:flutter/foundation.dart';

import 'checkout_risk_sdk_platform_interface.dart';

/// A Flutter plugin for integrating with Checkout.com's Risk SDK.
///
/// This SDK helps collect device information for risk assessment purposes.
class CheckoutRiskSdk {
  bool _isInitialized = false;

  /// Returns the platform version.
  ///
  /// This is mainly used for testing purposes.
  @visibleForTesting
  Future<String?> getPlatformVersion() {
    return CheckoutRiskSdkPlatform.instance.getPlatformVersion();
  }

  /// Initializes the Checkout Risk SDK with the provided public key and environment.
  ///
  /// This method must be called before using any other functionality of the SDK.
  /// It can only be called once - subsequent calls will throw an exception.
  ///
  /// Parameters:
  /// - [publicKey]: The public key provided by Checkout for authentication.
  /// - [environment]: The environment to be used ([CheckoutRiskEnvironment.sandbox] or [CheckoutRiskEnvironment.production]).
  ///
  /// Throws:
  /// - [StateError] if the SDK has already been initialized
  /// - [ArgumentError] if the publicKey is empty or null
  /// - [CheckoutRiskException] if initialization fails
  Future<void> initialize(
      String publicKey, CheckoutRiskEnvironment environment) async {
    if (_isInitialized) {
      throw StateError('CheckoutRiskSdk has already been initialized');
    }

    if (publicKey.isEmpty) {
      throw ArgumentError('Public key cannot be empty');
    }

    try {
      await CheckoutRiskSdkPlatform.instance
          .initialize(publicKey, environment.value);
      _isInitialized = true;
    } catch (e) {
      _isInitialized = false;
      rethrow;
    }
  }

  /// Publishes device data to Checkout.com's risk engine.
  ///
  /// This method must be called after [initialize].
  ///
  /// Returns:
  /// A [Future] that completes with a [String] containing the device session ID,
  /// which can be used in subsequent API calls to Checkout.com.
  ///
  /// Throws:
  /// - [StateError] if the SDK hasn't been initialized
  /// - [CheckoutRiskException] if data publishing fails
  Future<String?> publishData() async {
    if (!_isInitialized) {
      throw StateError(
          'CheckoutRiskSdk must be initialized before calling publishData');
    }

    return CheckoutRiskSdkPlatform.instance.publishData();
  }

  /// Checks if the SDK has been initialized.
  bool get isInitialized => _isInitialized;
}
