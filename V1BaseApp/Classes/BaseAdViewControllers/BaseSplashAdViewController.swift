//
//  BaseSplashAdViewController.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 22/12/25.
//

import Foundation

public protocol SplashAdPreparable: AnyObject {
    func makeInterModel() -> InterstitialAdModel
    func produceInterAd() -> InterstitialAdProducer
}

extension SplashAdPreparable {
    public func produceInterAd() -> InterstitialAdProducer {
        return AdManager.shared.produceInterstitialAd(model: makeInterModel())
    }
}

open class BaseSplashAdViewController<T:BaseViewModel>: BaseViewController<T>, SplashAdPreparable, InterstitialAdDelegate {
    open func makeInterModel() -> InterstitialAdModel {
        InterstitialAdModel(adID: "", adName: "")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        initAdConsentIfNeeded()
    }
    
    private func initAdConsentIfNeeded() {
        AdManager.shared.initAdsWithConsent(from: self) { [weak self] in
            guard let _self = self else {return}
            _self.showInterAd()
        } onError: { error in
            
        }

    }
    
    private func showInterAd() {
        let interAd = produceInterAd()
        interAd.setDelegate(self)
        interAd.load(from: self)
    }
}

