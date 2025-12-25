//
//  AdManager.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 22/12/25.
//

import Foundation
import GoogleMobileAds

public class AdManager {
    public static let shared: AdManager = AdManager()
    
    private var tracker: AppEventTracker?
    
    @MainActor func initAdsWithConsent(from viewController: UIViewController, onReady: @escaping () -> Void, onError: @escaping (Error) -> Void) {
        GoogleMobileAdsConsentManager.shared.gatherConsent(from: viewController) {[unowned self] error in
            if let err = error {
                onError(err)
            } else {
                startup(onReady: onReady)
            }
        }
    }
    
    private func startup(onReady: @escaping () -> Void) {
        MobileAds.shared.start { [unowned self] status in
            tracker?.trackEvent(name: status.description)
            onReady()
        }
    }
    
    public func setupTracker(_ tracker: AppEventTracker) -> AdManager {
        self.tracker = tracker
        return self
    }
    
    public func produceInterstitialAd(model: InterstitialAdModel) -> InterstitialAdProducer {
        return InterstitialAdProducer(adModel: model, tracker: tracker)
    }
    
    public func produceBannerAdProducer(model: BannerAdModel) -> BannerAdProducer {
        return BannerAdProducer(adModel: model)
    }
    
    public func produceRewardAdProducer(model: RewardedAdModel) -> RewardedAdProducer {
        return RewardedAdProducer(adModel: model, tracker: tracker)
    }
}
