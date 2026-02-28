package com.vtn.global.base.flutter

import android.content.Intent
import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsControllerCompat
import com.example.bindinghelper.BindingNotificationManager
import com.example.bindinghelper.NotificationCallHandler
import com.vtn.global.base.flutter.ad_factory.*
import com.vtn.global.base.flutter.enum.ButtonPosition
import com.vtn.global.base.flutter.util.method_handler.PermissionHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import com.adjust.helper.AdjustChannel

class MainActivity : FlutterActivity() {
    private var notificationCallHandler: NotificationCallHandler? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        BindingNotificationManager.init(
            this,
            MainActivity::class.java,
            R.drawable.ic_notification,
        )
        BindingNotificationManager.onRestart(this, intent, onNotificationClicked = {
            notificationCallHandler?.channel?.invokeMethod(
                "openNotify",
                mapOf(
                    "fromSplash" to true,
                ),
            )
        })

    }


    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        BindingNotificationManager.onRestart(this, intent, onNotificationClicked = {
            notificationCallHandler?.channel?.invokeMethod(
                "openNotify",
                mapOf(
                    "fromSplash" to false,
                ),
            )
        })
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        notificationCallHandler = NotificationCallHandler(
            context = this,
            messenger = flutterEngine.dartExecutor.binaryMessenger
        )
        AdjustChannel(this, flutterEngine.dartExecutor.binaryMessenger)

        PermissionHandler(
            context = this,
            messenger = flutterEngine.dartExecutor.binaryMessenger
        )

        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "topExtraNativeAd",
            ExtraNativeAd(context, buttonPosition = ButtonPosition.Top)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "bottomExtraNativeAd",
            ExtraNativeAd(context, buttonPosition = ButtonPosition.Bottom)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "topNormalNativeAd",
            NormalNativeAd(context, buttonPosition = ButtonPosition.Top)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "bottomNormalNativeAd",
            NormalNativeAd(context, buttonPosition = ButtonPosition.Bottom)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "homeNativeAd",
            HomeNativeAd(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "smallNativeAd",
            SmallNativeAd(context)
        )
        GoogleMobileAdsPlugin.registerNativeAdFactory(
            flutterEngine,
            "fullNativeAd",
            FullNativeAd(context)
        )
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "topExtraNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "bottomExtraNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "topNormalNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "bottomNormalNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "homeNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "fullNativeAd")
    }
}
