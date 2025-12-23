//
//  EventTracker.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 22/12/25.
//

import Foundation

public protocol EventTrackable {
    func trackEvent(name: String, params: [String: Any]?)
}

public class AppEventTracker {
    private var trackers: [EventTrackable] = []
    
    public static let shared: AppEventTracker = AppEventTracker()
    
    public func setTrackers(_ trackers: [EventTrackable]) {
        self.trackers = trackers
    }
    
    public func trackEvent(name: String, params: [String: Any]? = nil) {
        trackers.forEach { tracker in
            tracker.trackEvent(name: name, params: params)
        }
    }
}
