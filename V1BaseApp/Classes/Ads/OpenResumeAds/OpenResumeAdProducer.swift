//
//  OpenResumeAdProducer.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 23/12/25.
//

import Foundation
import GoogleMobileAds

public protocol OpenResumeAdDelegate: AnyObject {
    
}

extension OpenResumeAdDelegate {
    public func requestViewControllerToShow() -> UIViewController? { return nil}
    public func onAdLoaded(isAutoPreload: Bool) {}
    public func onAdLoadFailed(isAutoPreload: Bool) {}
    public func onAdImpression() {}
    public func onAdClicked() {}
    public func onAdFailedToShow() {}
}

open class OpenResumeAdProducer: NSObject {
    private var state: AdState = .initial
    let adModel: OpenResumeAdModel
    let tracker: AppEventTracker?
    weak var delegate: OpenResumeAdDelegate?
    private var ad: AppOpenAd?
    
    public init(adModel: OpenResumeAdModel, tracker: AppEventTracker?) {
        self.adModel = adModel
        self.tracker = tracker
    }
    
    func setDelegate(_ delegate: OpenResumeAdDelegate) {
        self.delegate = delegate
    }
    
    func load(from viewController: UIViewController?) {
        load(from: viewController, isShowImmediately: adModel.displayMode == .loadAndShow)
    }
    
    private func load(from viewController: UIViewController?, isShowImmediately: Bool) {
        let show:((UIViewController?) -> Void) = {[weak self] viewController in
            guard let _self = self else {return}
            if let vc = viewController ?? _self.delegate?.requestViewControllerToShow() {
                DispatchQueue.main.async {
                    _self.show(from: vc)
                }
            } else {
                _self.delegate?.onAdFailedToShow()
            }
        }
        
        if let _ = ad, isShowImmediately {
            show(viewController)
            return
        }
        
        Task {
            do {
                state = .loading
                ad = try await AppOpenAd.load(
                    with: adModel.adID, request: Request())
                ad!.fullScreenContentDelegate = self
                state = .loaded
                
                if isShowImmediately {
                    show(viewController)
                }
            } catch {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                delegate?.onAdFailedToShow()
            }
        }
    }
    
    func show(from viewController: UIViewController, isLoadAndShowIfNotLoadBefore: Bool = false) {
        switch state {
        case .loaded:
            guard let ad = ad else {
                delegate?.onAdFailedToShow()
                return
            }
            ad.present(from: viewController)
            
        case .failedToLoad:
            if isLoadAndShowIfNotLoadBefore {
                load(from: viewController, isShowImmediately: true)
            } else {
                delegate?.onAdFailedToShow()
            }
        case .initial:
            return
        case .loading:
            return
        case .showing, .shown:
            return
        }
    }
}

extension OpenResumeAdProducer: FullScreenContentDelegate {
    public func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        delegate?.onAdClicked()
    }
    
    public func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        delegate?.onAdFailedToShow()
    }
    
    public func adDidRecordImpression(_ ad: any FullScreenPresentingAd) {
        delegate?.onAdImpression()
    }
}

