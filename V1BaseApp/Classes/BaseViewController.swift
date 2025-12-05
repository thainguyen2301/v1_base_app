//
//  BaseViewController.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 3/12/25.
//

import Foundation
import RxSwift

public protocol BaseViewControllerPreparable: AnyObject {
    var bag: DisposeBag { get set }
    func createViewModel() -> BaseViewModel
    
    func setupUI()
    func observers()
}

open class BaseViewController<T: BaseViewModel>: UIViewController, BaseViewControllerPreparable {
    public var bag = DisposeBag()
    
    private lazy var _viewModel = createViewModel()
    
    // Computed property: Get returns the backing instance
    public var viewModel: T {
        get { return _viewModel as! T }  // Safe cast since createViewModel returns T
    }
  
//    required public init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    open func createViewModel() -> BaseViewModel {
        return BaseViewModel()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observers()
    }

    open func setupUI() {
        
    }
    
    open func observers() {
        
    }
}

