import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'checkout_risk_sdk_method_channel.dart';

/// The interface that implementations of checkout_risk_sdk must implement.
///
/// Platform implementations should extend this class rather than implement it as `checkout_risk_sdk`
/// does not consider newly added methods to be breaking changes. Extending this class
/// (using `extends`) ensures that the subclass will get the default implementation, while
/// platform implementations that `implements` this interface will be broken by newly added
/// [CheckoutRiskSdkPlatform] methods.
abstract class CheckoutRiskSdkPlatform extends PlatformInterface {
  /// Constructs a CheckoutRiskSdkPlatform.
  CheckoutRiskSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static CheckoutRiskSdkPlatform _instance = MethodChannelCheckoutRiskSdk();

  /// The default instance of [CheckoutRiskSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelCheckoutRiskSdk].
  static CheckoutRiskSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CheckoutRiskSdkPlatform] when
  /// they register themselves.
  static set instance(CheckoutRiskSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Returns the current platform version.
  ///
  /// Platform implementations should throw an appropriate exception if
  /// the platform version cannot be retrieved.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  /// Initializes the Risk SDK with the provided configuration.
  ///
  /// Parameters:
  /// - [publicKey]: The public key provided by Checkout.com
  /// - [environment]: The environment to use ('sandbox' or 'production')
  ///
  /// Throws:
  /// - [ArgumentError] if parameters are invalid
  /// - [CheckoutRiskException] if initialization fails
  Future<void> initialize(String publicKey, String environment) async {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// Publishes device data to Checkout.com's risk engine.
  ///
  /// Returns a device session ID that can be used in subsequent API calls.
  ///
  /// Throws:
  /// - [CheckoutRiskException] if data publishing fails
  Future<String?> publishData() async {
    throw UnimplementedError('publishData() has not been implemented.');
  }
}
