//
//  ViewController.swift
//  V1BaseApp
//
//  Created by 141131796 on 12/03/2025.
//  Copyright (c) 2025 141131796. All rights reserved.
//

import UIKit
import V1BaseApp
import RxCocoa
import GoogleMobileAds

class ViewController: BaseSplashAdViewController<BaseViewModel> {
    @IBOutlet private weak var adContainer: UIView!
    let nativeAd = NativeAdProducer(adModel: NativeAdModel(adId: "ca-app-pub-3940256099942544/3986624511", name: "home"))
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Hello World", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func createViewModel() -> BaseViewModel {
        DemoViewModel()
    }
    
    override func setupUI() {
        view.addSubview(button)
        button.setWidth(100).setHeight(100).setCenterX(0, relativeToView: view).setCenterY(0, relativeToView: view)
    }
    
    override func observers() {
        super.observers()
        button.rx.tap.asDriver().drive().disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AppEventTracker.shared.trackEvent(name: "ViewController", params: nil)
      
    }
    
    override func makeInterModel() -> InterstitialAdModel {
        InterstitialAdModel(adID: "ca-app-pub-3940256099942544/4411468910", adName: "inter_splash")
    }
    
    override func localize() {
        super.localize()
        print("Localize")
    }
    
    override func processAfterConsent() {
        super.processAfterConsent()
        produceNativeAd()
    }
    
    private func produceNativeAd() {
        nativeAd.setDelegate(delegate: self)
        if let nibObjects = Bundle.main.loadNibNamed("ads_native_1_button_2_info_3_media", owner: nil, options: nil)?.first as? NativeAdView {
            nativeAd.loadAdWithStyle(adView: nibObjects, controller: self)
        }
    }
}

class DemoViewModel: BaseViewModel {
    
}

extension ViewController: NativeProducerDelegate {
    func didLoadAd(view: UIView) {
        view.setNeedsLayout()
            view.layoutIfNeeded()
            print("AdView frames:")
            view.subviews.forEach { print("Tag \($0.tag): \($0.frame)") }
        adContainer.addSubview(view)
        view.fullscreen()
    }
    
    func didFailedToLoadAd() {
        
    }
}


