//
//  RewardedAdModel.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 25/12/25.
//

import Foundation

public struct RewardedAdModel {
    let adId: String
    let adName: String?
    
    public init(adId: String, adName: String?) {
        self.adId = adId
        self.adName = adName
    }
}
