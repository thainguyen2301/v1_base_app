//
//  AppOpenResume.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 23/12/25.
//

import Foundation

public protocol AppOpenResumable {
    var openResumeModel: OpenResumeAdModel {get}
    func makeOpenResumeProducer() -> OpenResumeAdProducer
    func showAppOpenResumeAd(delegate: OpenResumeAdDelegate?, from viewController: UIViewController)
}

public extension AppOpenResumable {
    func makeOpenResumeProducer() -> OpenResumeAdProducer {
        let interAdProducer = OpenResumeAdProducer(adModel: openResumeModel, tracker: AppEventTracker.shared)
        return interAdProducer
    }
    
    func showAppOpenResumeAd(delegate: OpenResumeAdDelegate?, from viewController: UIViewController) {
        let producer = makeOpenResumeProducer()
        if let delegate = delegate {
            producer.setDelegate(delegate)
        }
        producer.load(from: viewController)
    }
}
