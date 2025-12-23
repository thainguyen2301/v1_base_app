//
//  InterstitialAdModel.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 22/12/25.
//

import Foundation

public enum InterstitialDisplayMode {
    case loadAndShow, loadOnly
}

public struct InterstitialAdModel {
    let adID: String
    let adName: String?
    let displayMode: InterstitialDisplayMode
    let shouldPreloadAfterShown: Bool
    
    public init(adID: String, adName: String?, displayMode: InterstitialDisplayMode = .loadAndShow, shouldPreloadAfterShown: Bool = false) {
        self.adID = adID
        self.adName = adName
        self.displayMode = displayMode
        self.shouldPreloadAfterShown = shouldPreloadAfterShown
    }
}
