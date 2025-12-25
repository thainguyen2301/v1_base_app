//
//  RewardedAdProducer.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 25/12/25.
//

import Foundation
import GoogleMobileAds
import RxRelay

open class RewardedAdProducer: NSObject {
    
    public enum State {
        case initital, loading, loaded, showing, shown, loadFailed, showFailed, dismissed
    }
    
    let adModel: RewardedAdModel
    let tracker: AppEventTracker?
    public let stateSubject = BehaviorRelay<State>(value: .initital)
    private var rewardedAd: RewardedAd?
    
    public init(adModel: RewardedAdModel, tracker: AppEventTracker? = nil) {
        self.adModel = adModel
        self.tracker = tracker
    }
    
    public func load()  {
        Task.detached(priority: .background) { [weak self] in
            guard let _self = self else {return}
            _self.stateSubject.accept(.loading)
            do {
                _self.rewardedAd = try await RewardedAd.load(
                    with: _self.adModel.adId, request: Request())
                _self.rewardedAd?.fullScreenContentDelegate = self
                _self.stateSubject.accept(.loaded)
            } catch {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                _self.stateSubject.accept(.loadFailed)
            }
        }
    }
    
    public func show(on viewController: UIViewController) {
        let state = stateSubject.value
        guard let rewardedAd = rewardedAd, state == .loaded else { return }
        stateSubject.accept(.showing)
        rewardedAd.present(from: viewController) {
            
        }
        stateSubject.accept(.shown)
    }
}

extension RewardedAdProducer: FullScreenContentDelegate {
    public func adDidDismissFullScreenContent(_ ad: any FullScreenPresentingAd) {
        stateSubject.accept(.dismissed)
    }
    
    public func ad(_ ad: any FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: any Error) {
        stateSubject.accept(.showFailed)
    }
}
