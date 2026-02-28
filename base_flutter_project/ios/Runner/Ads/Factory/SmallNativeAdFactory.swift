//
//  CustomNativeAdFactory.swift
//  Runner
//
//  Created by VTN Dev on 11/12/2023.
//

import Foundation
import google_mobile_ads

class SmallNativeAdFactory: FLTNativeAdFactory {


    func createNativeAd(_ nativeAd: NativeAd,
        customOptions: [AnyHashable: Any]? = nil) -> NativeAdView? {
        let viewName = "SmallNativeAdView"
        let nibView = Bundle.main.loadNibNamed(viewName, owner: nil, options: nil)!.first
        let nativeAdView = nibView as! NativeAdView

        (nativeAdView.headlineView as? UILabel)?.text = nativeAd.headline
        nativeAdView.mediaView?.mediaContent = nativeAd.mediaContent

        (nativeAdView.bodyView as? UILabel)?.text = nativeAd.body
        nativeAdView.bodyView?.isHidden = nativeAd.body == nil
        nativeAdView.bodyView?.sizeToFit()

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
