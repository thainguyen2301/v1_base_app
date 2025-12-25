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
import RxSwift

class ViewController: BaseSplashAdViewController<BaseViewModel> {
    @IBOutlet private weak var adContainer: UIView!
    @IBOutlet weak var bannerContainer: UIView!
    
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
        button.rx.tap.asDriver().drive(onNext: { [weak self]  in
            guard let _self = self else {return}
            _self.gotoDetailVC()
        }).disposed(by: bag)
      
    }
    
    private func addAdToContainer(_ ad: UIView) {
        adContainer.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        
        adContainer.addSubview(ad)
        ad.fullscreen()
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
        produceBannerAd()
    }
    
    private func produceNativeAd() {
        AppAdManager.shared.loadDetailNativeAd()
    }
    
    private func produceBannerAd() {
        AppAdManager.shared.showAllAppAdaptiveBannerAd(in: bannerContainer, controller: self)
    }
    
    private func gotoDetailVC() {
        let detailVC = DetailViewController()
        present(detailVC, animated: false)
    }
}

class DemoViewModel: BaseViewModel {
    
}



