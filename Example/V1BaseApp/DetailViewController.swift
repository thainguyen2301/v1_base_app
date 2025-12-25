//
//  DetailViewController.swift
//  V1BaseApp_Example
//
//  Created by ThaiNguyen on 24/12/25.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import UIKit
import RxSwift
import V1BaseApp

class DetailViewController: BaseViewController<BaseViewModel> {

    @IBOutlet weak var adContainer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nativeAd = AppAdManager.shared.detailNativeAdProducer else {return}
        nativeAd.statusSubject.asObservable().observe(on: MainScheduler.asyncInstance).subscribe(onNext: { [weak self] status in
            guard let _self = self else {return}
            switch status {
            case .loading(let styleView):
                _self.addAdToContainer(styleView)
            case .loaded:
                _self.adContainer.subviews.forEach { subView in
                    subView.removeFromSuperview()
                }
                nativeAd.show(in: _self.adContainer)
            default: break
                
            }
        }).disposed(by: bag)
    }
    
    private func addAdToContainer(_ ad: UIView) {
        adContainer.subviews.forEach { subView in
            subView.removeFromSuperview()
        }
        
        adContainer.addSubview(ad)
        ad.fullscreen()
    }
}
