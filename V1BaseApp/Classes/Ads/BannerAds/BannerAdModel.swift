//
//  BannerAdModel.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 25/12/25.
//

import Foundation

public struct BannerAdModel {
    public enum Style {
        case adaptive, collapsibleTop, collapsibleBottom
    }
    
    let adId: String
    let adName: String?
    let style: Style
    let reloadAfterTimeSeconds: Double = 5
    
    public init(adId: String, adName: String?, style: Style = .adaptive) {
        self.adId = adId
        self.adName = adName
        self.style = style
    }
}
