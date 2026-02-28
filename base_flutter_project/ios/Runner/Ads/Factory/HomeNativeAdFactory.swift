//
//  CustomNativeAdFactory.swift
//  Runner
//
//  Created by VTN Dev on 11/12/2023.
//

import Foundation
import google_mobile_ads

class HomeNativeAdFactory: FLTNativeAdFactory {
    var hasMedia : Bool
    init(hasMedia: Bool = true) {
        self.hasMedia = hasMedia
    }


    func createNativeAd(_ nativeAd: NativeAd,
        customOptions: [AnyHashable: Any]? = nil) -> NativeAdView? {
        let viewName = "HomeNativeAdView"
        let nibView = Bundle.main.loadNibNamed(viewName, owner: nil, options: nil)!.first
        let nativeAdView = nibView as! NativeAdView

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        if(hasMedia){
            nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent
        } else{
            nativeAdView.mediaView?.isHidden = true
            nativeAdView.mediaView?.removeFromSuperview()
        }

        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil

        let actionButton = nativeAdView.callToActionView as? UIButton
        actionButton?.setTitle(nativeAd.callToAction, for: .normal)
        actionButton?.isHidden = nativeAd.callToAction == nil
        
        


        (nativeAdView.iconView as? UIImageView)?.image = nativeAd.icon?.image
        nativeAdView.iconView?.isHidden = nativeAd.icon == nil


        actionButton?.isUserInteractionEnabled = false

        nativeAdView.nativeAd = nativeAd

        return nativeAdView
    }

}
