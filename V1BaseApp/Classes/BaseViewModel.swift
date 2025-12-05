//
//  BaseViewModel.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 5/12/25.
//

import Foundation
import RxSwift
protocol IViewModel: AnyObject {
    var bag: DisposeBag { get set}
}

open class BaseViewModel: IViewModel {
   public var bag = DisposeBag()
   public init() { } 
}
