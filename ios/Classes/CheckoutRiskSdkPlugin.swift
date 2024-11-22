import Flutter
import UIKit
import Risk

public class CheckoutRiskSdkPlugin: NSObject, FlutterPlugin {
  private var riskSDK: Risk?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "checkout_risk_sdk", binaryMessenger: registrar.messenger())
    let instance = CheckoutRiskSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "initialize":
      guard let args = call.arguments as? [String: Any],
            let publicKey = args["publicKey"] as? String,
            let environment = args["environment"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "Public key or environment is missing", details: nil))
        return
      }
      
      let env: RiskEnvironment = (environment == "production") ? .production : .sandbox
      let config = RiskConfig(publicKey: publicKey, environment: env)
      self.riskSDK = Risk(config: config)
      
      self.riskSDK?.configure { configResult in
        DispatchQueue.main.async {
          switch configResult {
          case .success:
            result(nil)
          case .failure(let error):
            result(FlutterError(code: "CONFIG_ERROR", message: error.localizedDescription, details: nil))
          }
        }
      }
      
    case "publishData":
      self.riskSDK?.publishData { publishResult in
        DispatchQueue.main.async {
          switch publishResult {
          case .success(let response):
            result(response.deviceSessionId)
          case .failure(let error):
            result(FlutterError(code: "PUBLISH_ERROR", message: error.localizedDescription, details: nil))
          }
        }
      }
      
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
      
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
