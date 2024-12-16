import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

import 'checkout_risk_sdk_platform_interface.dart';

/// An implementation of [CheckoutRiskSdkPlatform] that uses method channels.
class MethodChannelCheckoutRiskSdk extends CheckoutRiskSdkPlatform {
  final _logger = Logger('MethodChannelCheckoutRiskSdk');

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('checkout_risk_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    try {
      final version =
          await methodChannel.invokeMethod<String>('getPlatformVersion');
      return version;
    } on PlatformException catch (e, stackTrace) {
      _logger.severe(
          'Error getting platform version: ${e.message}', e, stackTrace);
      return null;
    }
  }

  @override
  Future<void> initialize(String publicKey, String environment) async {
    if (publicKey.isEmpty) {
      throw ArgumentError('Public key cannot be empty');
    }
    if (environment.isEmpty) {
      throw ArgumentError('Environment cannot be empty');
    }

    try {
      await methodChannel.invokeMethod('initialize', {
        'publicKey': publicKey,
        'environment': environment,
      });
    } on PlatformException catch (e, stackTrace) {
      _logger.severe('Error initializing the SDK: ${e.message}', e, stackTrace);
      throw CheckoutRiskException('Failed to initialize: ${e.message}', e.code);
    } catch (e, stackTrace) {
      _logger.severe('Unexpected error initializing the SDK', e, stackTrace);
      throw CheckoutRiskException(
          'Unexpected error during initialization', 'UNKNOWN_ERROR');
    }
  }

  @override
  Future<String?> publishData() async {
    try {
      final String? deviceSessionId =
          await methodChannel.invokeMethod('publishData');
      if (deviceSessionId == null || deviceSessionId.isEmpty) {
        throw CheckoutRiskException(
            'Device session ID is null or empty', 'INVALID_RESPONSE');
      }
      return deviceSessionId;
    } on PlatformException catch (e, stackTrace) {
      _logger.severe('Error publishing data: ${e.message}', e, stackTrace);
      throw CheckoutRiskException(
          'Failed to publish data: ${e.message}', e.code);
    } catch (e, stackTrace) {
      _logger.severe('Unexpected error publishing data', e, stackTrace);
      throw CheckoutRiskException(
          'Unexpected error during data publishing', 'UNKNOWN_ERROR');
    }
  }
}

/// Custom exception class for Checkout Risk SDK
class CheckoutRiskException implements Exception {
  final String message;
  final String code;

  CheckoutRiskException(this.message, this.code);

  @override
  String toString() => 'CheckoutRiskException: $message (Code: $code)';
}
