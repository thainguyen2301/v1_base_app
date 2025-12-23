//
//  InterstitialAdProducer.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 22/12/25.
//

import Foundation
import GoogleMobileAds

public protocol InterstitialAdDelegate: AnyObject {
    func requestViewControllerToShow() -> UIViewController?
    func onAdLoaded(isAutoPreload: Bool)
    func onAdLoadFailed(isAutoPreload: Bool)
    func onAdImpression()
    func onAdClicked()
    func onAdFailedToShow()
    func onNextAction()
    func showNativeFullAd()
}

extension InterstitialAdDelegate {
    public func requestViewControllerToShow() -> UIViewController? { return nil}
    public func onAdLoaded(isAutoPreload: Bool) {}
    public func onAdLoadFailed(isAutoPreload: Bool) {}
    public func onAdImpression() {}
    public func onAdClicked() {}
    public func onAdFailedToShow() {}
    public func onNextAction() {}
    public func showNativeFullAd() {}
}

public class InterstitialAdProducer: NSObject {
    
    public enum State {
        case loaded, failedToLoad, initial, loading, showing, shown
    }
    
    let adModel: InterstitialAdModel
    let tracker: AppEventTracker?
    var state: State = .initial
    weak var delegate: InterstitialAdDelegate? = nil
    
    private var ad: InterstitialAd?
    
    public init(adModel: InterstitialAdModel, tracker: AppEventTracker?, state: State = .initial, delegate: InterstitialAdDelegate? = nil) {
        self.adModel = adModel
        self.tracker = tracker
        self.state = state
        self.delegate = delegate
    }
    
    func setDelegate(_ delegate: InterstitialAdDelegate) {
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
                ad = try await InterstitialAd.load(
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
    
    private func preloadThisAdIfNeeded(from viewController: UIViewController?) {
        guard adModel.shouldPreloadAfterShown else { return }
        load(from: viewController, isShowImmediately: false)
    }
    
    private func resetAd() {
        ad = nil
        state = .initial
    }
    
    private func handleNextActionAfterDismissAd() {
        // TODO: Show native ad if valid
        
        // else handle next action
        delegate?.onNextAction()
    }
}

extension InterstitialAdProducer: FullScreenContentDelegate {
    public func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        resetAd()
        preloadThisAdIfNeeded(from: nil)
        handleNextActionAfterDismissAd()
    }
    
    public func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        delegate?.onAdFailedToShow()
    }
}
