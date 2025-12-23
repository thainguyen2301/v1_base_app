//
//  OpenResumeAdModel.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 23/12/25.
//

import Foundation

public struct OpenResumeAdModel {
    let adID: String
    let adName: String?
    let displayMode: FullScreenDisplayMode
    let shouldPreloadAfterShown: Bool
    
    public init(adID: String, adName: String?, displayMode: FullScreenDisplayMode = .loadOnly, shouldPreloadAfterShown: Bool = false) {
        self.adID = adID
        self.adName = adName
        self.displayMode = displayMode
        self.shouldPreloadAfterShown = shouldPreloadAfterShown
    }
}
