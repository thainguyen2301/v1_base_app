//
//  NativeAdModel.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 23/12/25.
//

import Foundation

public struct NativeAdModel {
    let adId: String
    let name: String
    
    public init(adId: String, name: String) {
        self.adId = adId
        self.name = name
    }
}
