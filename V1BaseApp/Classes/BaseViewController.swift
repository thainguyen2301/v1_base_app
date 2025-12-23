//
//  BaseViewController.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 3/12/25.
//

import Foundation
import RxSwift
import RxRelay

public protocol BaseViewControllerPreparable: AnyObject {
    var bag: DisposeBag { get set }
    func createViewModel() -> BaseViewModel
    
    func setupUI()
    func observers()
}

public protocol ILanguage {
    
}

public protocol LanguageTranslatable {
    func localize()
    func changeLanguage(_ language: ILanguage?)
}

extension LanguageTranslatable {
    public func onLanguageChanged() {}
}

open class BaseViewController<T: BaseViewModel>: UIViewController, BaseViewControllerPreparable, LanguageTranslatable {
    public var bag = DisposeBag()
    
    private lazy var _viewModel = createViewModel()
    private let languageService: LanguageManager = LanguageManager.shared
    
    // Computed property: Get returns the backing instance
    public var viewModel: T {
        get { return _viewModel as! T }  // Safe cast since createViewModel returns T
    }

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
        print("Observer")
        languageService.languageChangeSubject.asObservable().observe(on: MainScheduler.asyncInstance).subscribe(onNext: {[weak self] lang in
            guard let _self = self else {return}
            _self.localize()
        }).disposed(by: bag)
    }
    
    open func localize() {
        
    }
    
    public func changeLanguage(_ language: ILanguage?) {
        languageService.languageChangeSubject.accept(language)
    }
}

