import 'package:flutter_test/flutter_test.dart';
import 'package:checkout_risk_sdk/checkout_risk_sdk.dart';
import 'package:checkout_risk_sdk/checkout_risk_sdk_platform_interface.dart';
import 'package:checkout_risk_sdk/checkout_risk_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCheckoutRiskSdkPlatform
    with MockPlatformInterfaceMixin
    implements CheckoutRiskSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> initialize(String publicKey, String environment) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<String?> publishData() {
    // TODO: implement publishData
    throw UnimplementedError();
  }
}

void main() {
  final CheckoutRiskSdkPlatform initialPlatform =
      CheckoutRiskSdkPlatform.instance;

  test('$MethodChannelCheckoutRiskSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCheckoutRiskSdk>());
  });

  test('getPlatformVersion', () async {
    CheckoutRiskSdk checkoutRiskSdkPlugin = CheckoutRiskSdk();
    MockCheckoutRiskSdkPlatform fakePlatform = MockCheckoutRiskSdkPlatform();
    CheckoutRiskSdkPlatform.instance = fakePlatform;

    expect(await checkoutRiskSdkPlugin.getPlatformVersion(), '42');
  });
}
