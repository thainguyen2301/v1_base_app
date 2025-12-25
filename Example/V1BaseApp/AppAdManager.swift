//
//  AppAdManager.swift
//  V1BaseApp_Example
//
//  Created by ThaiNguyen on 24/12/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import V1BaseApp
import GoogleMobileAds

class AppAdManager {
    static let shared = AppAdManager()
    
    private(set) var detailNativeAdProducer: NativeAdProducer?
    
    private init() {}
    
    func loadDetailNativeAd() {
        detailNativeAdProducer = NativeAdProducer(adModel: NativeAdModel(adId: "ca-app-pub-3940256099942544/3986624511", name: "home"))
        if let style = NativeLayerType.native1.fromNib() {
            detailNativeAdProducer?.loadAdWithStyle(adView: style, controller: nil)
        }
    }
    
    func showAllAppAdaptiveBannerAd(in view: UIView, controller: UIViewController) {
        let bannerAd = BannerAdProducer(adModel: BannerAdModel(adId: "ca-app-pub-3940256099942544/2435281174", adName: "banner_all"))
        bannerAd.load(in: view, viewController: controller)
    }
}

enum NativeLayerType: String {
    case native1 = "ads_native_1_button_2_info_3_media"
    
    func fromNib() -> NativeAdView? {
        Bundle.main.loadNibNamed(rawValue, owner: nil, options: nil)?.first as? NativeAdView
    }
}
