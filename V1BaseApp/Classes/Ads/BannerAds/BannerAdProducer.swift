//
//  BannerAdProducer.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 25/12/25.
//

import Foundation
import GoogleMobileAds

open class BannerAdProducer: NSObject {
    let adModel: BannerAdModel
    let tracker: AppEventTracker?
    public init(adModel: BannerAdModel, tracker: AppEventTracker? = nil) {
        self.adModel = adModel
        self.tracker = tracker
    }
    
    public func load(in view: UIView, viewController: UIViewController) {
        let bannerView = BannerView()
        bannerView.adUnitID = adModel.adId
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        bannerView.fullscreen()
        bannerView.rootViewController = viewController
        
        bannerView.adSize = currentOrientationAnchoredAdaptiveBanner(width: view.frame.width)
        bannerView.delegate = self
        
        let request = Request()
             
        switch adModel.style {
        case .adaptive:
            break
            
        case .collapsibleTop:
            let extras = Extras()
            extras.additionalParameters?["collapsible"] = "top"
            request.register(extras)
            
        case .collapsibleBottom:
            let extras = Extras()
            extras.additionalParameters?["collapsible"] = "bottom"
            request.register(extras)
        }
        
        bannerView.load(request)
    }
    
    private func autoReloadIfNeeded() {
        
    }
}

extension BannerAdProducer: BannerViewDelegate {
    public func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        guard let hostView = bannerView.superview,
              !hostView.isHidden,
              hostView.window != nil else {  // window != nil means it's on-screen/hierarchically attached.
            print("Banner loaded but view is dismissed/hidden. Cleaning up...")
            bannerView.removeFromSuperview()  // Prevent any UI updates.
            bannerView.delegate = nil  // Break retain cycle.
            return
        }
    }
    
    public func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: any Error) {
        
    }
}
