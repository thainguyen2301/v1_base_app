//
//  ViewController.swift
//  V1BaseApp
//
//  Created by 141131796 on 12/03/2025.
//  Copyright (c) 2025 141131796. All rights reserved.
//

import UIKit
import V1BaseApp
import RxCocoa

class ViewController: BaseViewController<BaseViewModel> {
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Hello World", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func createViewModel() -> BaseViewModel {
        DemoViewModel()
    }
    
    override func setupUI() {
        view.addSubview(button)
        button.setWidth(100).setHeight(100).setCenterX(0, relativeToView: view).setCenterY(0, relativeToView: view)
    }
    
    override func observers() {
        button.rx.tap.asDriver().drive().disposed(by: bag)
    }
}

class DemoViewModel: BaseViewModel {
    
}


