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
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<void> initialize(String publicKey, String environment) async {
    try {
      await methodChannel.invokeMethod('initialize', {
        'publicKey': publicKey,
        'environment': environment,
      });
    } on PlatformException catch (e, stackTrace) {
      _logger.severe('Error initializing the SDK: ${e.message}', e, stackTrace);
      throw Exception(e);
    }
  }

  @override
  Future<String?> publishData() async {
    try {
      final String? deviceSessionId =
          await methodChannel.invokeMethod('publishData');
      return deviceSessionId;
    } on PlatformException catch (e, stackTrace) {
      _logger.severe('Error publishing data: ${e.message}', e, stackTrace);
      return e.message;
    }
  }
}
