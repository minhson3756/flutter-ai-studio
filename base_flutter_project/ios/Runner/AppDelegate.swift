import UIKit
import Flutter
import FirebaseCore
import google_mobile_ads
import FBAudienceNetwork
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // meta ads
        FBAdSettings.setAdvertiserTrackingEnabled(true)
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        GeneratedPluginRegistrant.register(with: self)
        //    FirebaseApp.configure()
        registerAdFactory()
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func registerAdFactory() {
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "bottomExtraNativeAd", nativeAdFactory: ExtraNativeAdFactory())
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "topExtraNativeAd", nativeAdFactory: ExtraNativeAdFactory(buttonPosition: ButtonPosition.top))
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "bottomNormalNativeAd", nativeAdFactory: NormalNativeAdFactory())
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "topNormalNativeAd", nativeAdFactory: NormalNativeAdFactory(buttonPosition: ButtonPosition.top))
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "homeNativeAd", nativeAdFactory: HomeNativeAdFactory())
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "smallNativeAd", nativeAdFactory: SmallNativeAdFactory())
        FLTGoogleMobileAdsPlugin.registerNativeAdFactory(
            self, factoryId: "fullNativeAd", nativeAdFactory: FullNativeAdFactory())
        
    }
}
