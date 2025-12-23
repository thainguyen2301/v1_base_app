//
//  LanguageManager.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 23/12/25.
//

import Foundation
import RxRelay
class LanguageManager {
    static let shared = LanguageManager()
    
    let languageChangeSubject = BehaviorRelay<ILanguage?>(value: nil)
}
