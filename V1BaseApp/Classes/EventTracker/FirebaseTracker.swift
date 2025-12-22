//
//  FirebaseTracker.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 22/12/25.
//

import Foundation
import FirebaseAnalytics
import FirebaseCore

public class FirebaseEventTracker: EventTrackable {
    
    public init() {}
    
    public func trackEvent(name: String, params: [String : Any]?) {
        guard FirebaseApp.app() != nil else {
            print("Firebase not initialized; skipping event log: \(name)")
            return
        }
        Analytics.logEvent(name, parameters: params)
    }
}
