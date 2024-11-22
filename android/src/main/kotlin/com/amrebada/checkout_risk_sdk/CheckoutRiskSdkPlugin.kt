package com.amrebada.checkout_risk_sdk

import android.content.Context
import com.checkout.risk.PublishDataResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.checkout.risk.Risk
import com.checkout.risk.RiskConfig
import com.checkout.risk.RiskEnvironment
import kotlinx.coroutines.runBlocking


/** CheckoutRiskSdkPlugin */
class CheckoutRiskSdkPlugin : FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private lateinit var applicationContext : Context

  private var riskInstance: Risk? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    applicationContext = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "checkout_risk_sdk")
    channel.setMethodCallHandler(this)
  }

  private fun getRiskEnvironment(environment: String): RiskEnvironment {
    return if (environment == "production") RiskEnvironment.PRODUCTION else RiskEnvironment.SANDBOX
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "initialize" -> {
        val environment = call.argument<String>("environment")
        val publicKey = call.argument<String>("publicKey")
        if (publicKey != null && environment != null) {
          val env = getRiskEnvironment(environment)
          val config = RiskConfig(publicKey, env)
          runBlocking {
            riskInstance = Risk.getInstance(applicationContext, config)
          }
          result.success(null)
        } else {
          result.error("INVALID_ARGUMENT", "Public key or environment is null", null)
        }
      }
      "publishData" -> {
        val res: PublishDataResult? = runBlocking {
          riskInstance?.publishData()
        }
        if (res == null) {
          result.error("PUBLISH_FAILED", "Failed to publish data", null)
          return
        }
        if (res is PublishDataResult.Success) {
          result.success(res.deviceSessionId)
        } else {
          result.error("PUBLISH_FAILED", "Failed to publish data", null)
        }
      }
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      else -> result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
