import Foundation
import GoogleMobileAds
import SkeletonView
enum NativeAdState {
    case initial
}

private enum AdViewTags: Int {
    case headline = 1
    case body = 2
    case callToAction = 3
    case media = 4
    case icon = 5
    case attribution = 6  // Optional "Ad" label
}

public protocol NativeProducerDelegate: AnyObject {
    func didLoadAd(view: UIView)  // NEW: Success callback with populated view
    func didFailedToLoadAd()      // Existing: Failure
}

open class NativeAdProducer: NSObject {
    let adModel: NativeAdModel
    let state: NativeAdState = .initial
    
    weak var delegate: NativeProducerDelegate?
    private var adLoader: AdLoader?
    private var nativeAd: NativeAd?
    private var nativeAdView: NativeAdView?
    
    public init(adModel: NativeAdModel, delegate: NativeProducerDelegate? = nil) {
        self.adModel = adModel
        self.delegate = delegate
        super.init()
    }
    
    public func setDelegate(delegate: NativeProducerDelegate) {
        self.delegate = delegate
    }
    
    private func requestAd(controller: UIViewController) {
        adLoader = nil

        adLoader = {
            let loader = AdLoader(
                adUnitID: adModel.adId,
                rootViewController: controller,
                adTypes: [.native],
                options: nil
            )
            loader.delegate = self  // Set IMMEDIATELY after init
            return loader
        }()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.adLoader?.load(Request())
            print("🔄 Ad load initiated")
        }
    }
    
    public func loadAdWithStyle(adView: NativeAdView, controller: UIViewController) {
        requestAd(controller: controller)
        adView.headlineView = adView.viewWithTag(AdViewTags.headline.rawValue)
        adView.bodyView = adView.viewWithTag(AdViewTags.body.rawValue)
        adView.callToActionView = adView.viewWithTag(AdViewTags.callToAction.rawValue)
        if let mediaView = adView.viewWithTag(AdViewTags.media.rawValue) as? MediaView {
            adView.mediaView = mediaView
        }
    
        adView.iconView = adView.viewWithTag(AdViewTags.icon.rawValue)
        
        guard adView.headlineView != nil, adView.mediaView != nil else {
            print("Missing required tagged views (headline tag 1 or media tag 4).")
            delegate?.didFailedToLoadAd()
            return
        }
        
        nativeAdView = adView
        
        // Attribution (set early, shown after population)
        if let attributionView = adView.viewWithTag(AdViewTags.attribution.rawValue) as? UILabel {
            attributionView.text = "Ad"
            attributionView.isHidden = false
        }
      
        nativeAdView = adView
        startSkeletingForAdView()
        delegate?.didLoadAd(view: adView)
    }
    
    private func startSkeletingForAdView() {
        guard let nativeAdView = nativeAdView else {return}
        nativeAdView.headlineView?.isSkeletonable = true
        nativeAdView.bodyView?.isSkeletonable = true
        nativeAdView.callToActionView?.isSkeletonable = true
        nativeAdView.mediaView?.isSkeletonable = true
        nativeAdView.iconView?.isSkeletonable = true
        
        nativeAdView.headlineView?.showAnimatedGradientSkeleton()
        nativeAdView.bodyView?.showAnimatedGradientSkeleton()
        nativeAdView.callToActionView?.showAnimatedGradientSkeleton()
        nativeAdView.mediaView?.showAnimatedGradientSkeleton()
        nativeAdView.iconView?.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        guard let nativeAdView = nativeAdView else {return}
        nativeAdView.headlineView?.hideSkeleton()
        nativeAdView.bodyView?.hideSkeleton()
        nativeAdView.callToActionView?.hideSkeleton()
        nativeAdView.mediaView?.hideSkeleton()
        nativeAdView.iconView?.hideSkeleton()
    }
    
    private func populateData(in adView: NativeAdView, with nativeAd: NativeAd) {
        // Guaranteed
        if let headlineView = adView.headlineView as? UILabel {
            headlineView.text = nativeAd.headline
        }
        
        if let mediaView = adView.mediaView {
            mediaView.mediaContent = nativeAd.mediaContent
//            if nativeAd.mediaContent.aspectRatio > 0 {
//                let aspectRatioConstraint = NSLayoutConstraint(
//                    item: mediaView,
//                    attribute: .width,
//                    relatedBy: .equal,
//                    toItem: mediaView,
//                    attribute: .height,
//                    multiplier: CGFloat(nativeAd.mediaContent.aspectRatio),
//                    constant: 0)
//                mediaView.addConstraint(aspectRatioConstraint)
//                adView.layoutIfNeeded()
//            }
        }
        
        // Optional (hide if nil)
        if let bodyView = adView.bodyView as? UILabel, let body = nativeAd.body {
            bodyView.text = body
            bodyView.isHidden = false
        } else if let bodyView = adView.bodyView {
            bodyView.isHidden = true
        }
        
        if let ctaView = adView.callToActionView as? UIButton, let cta = nativeAd.callToAction {
            ctaView.setTitle(cta, for: .normal)
            ctaView.isHidden = false
            ctaView.isUserInteractionEnabled = false  // SDK handles
        } else if let ctaView = adView.callToActionView {
            ctaView.isHidden = true
        }
        
        // Icon
        if let icon = nativeAd.icon, let iconView = adView.iconView as? UIImageView {
            iconView.image = icon.image
            iconView.isHidden = false
        } else if let iconView = adView.iconView {
            iconView.isHidden = true
        }
    }
    
}

extension NativeAdProducer: AdLoaderDelegate {
    public func adLoader(_ adLoader: AdLoader, didFailToReceiveAdWithError error: any Error) {
        print("Ad load failed: \(error.localizedDescription)")
        delegate?.didFailedToLoadAd()
    }
}

extension NativeAdProducer: NativeAdLoaderDelegate {
    public func adLoader(_ adLoader: AdLoader, didReceive nativeAd: NativeAd) {
        self.nativeAd = nativeAd
        nativeAd.delegate = self  // For impressions/clicks
        hideSkeleton()
        guard let nativeAdView = nativeAdView else {
            print("Ad view not prepared. Call loadAdWithStyle first.")
            delegate?.didFailedToLoadAd()
            return
        }
        
        populateData(in: nativeAdView, with: nativeAd)
        nativeAdView.nativeAd = nativeAd
        delegate?.didLoadAd(view: nativeAdView)
    }
}

extension NativeAdProducer: NativeAdDelegate {
    public func nativeAdDidRecordImpression(_ nativeAd: NativeAd) {
        print("Ad impression recorded")
    }
    
    public func nativeAdDidRecordClick(_ nativeAd: NativeAd) {
        print("Ad clicked")
    }
    
    public func nativeAdWillPresentScreen(_ nativeAd: NativeAd) {
        // Pause app content if needed
    }
    
    public func nativeAdWillDismissScreen(_ nativeAd: NativeAd) {
        // Resume app content
    }
}

//extension NativeAdProducer {
//    private func cloneConstraints(from subview: UIView, oldSuperview: UIView, to newSuperview: UIView) {
//        // Collect constraints where oldSuperview is involved (firstItem or secondItem)
//        let relevantConstraints = subview.constraints.filter { constraint in
//            constraint.firstItem === oldSuperview || constraint.secondItem === oldSuperview
//        }
//        
//        // Deactivate old ones (they'll be invalid after move)
//        NSLayoutConstraint.deactivate(relevantConstraints)
//        
//        // Create and activate new equivalents
//        let newConstraints = relevantConstraints.map { oldConstraint -> NSLayoutConstraint in
//            let firstItem = (oldConstraint.firstItem === oldSuperview) ? newSuperview : oldConstraint.firstItem
//            let secondItem = (oldConstraint.secondItem === oldSuperview) ? newSuperview : oldConstraint.secondItem
//            
//            return NSLayoutConstraint(
//                item: firstItem!,
//                attribute: oldConstraint.firstAttribute,
//                relatedBy: oldConstraint.relation,
//                toItem: secondItem,
//                attribute: oldConstraint.secondAttribute,
//                multiplier: oldConstraint.multiplier,
//                constant: oldConstraint.constant
//            )
//        }
//        
//        NSLayoutConstraint.activate(newConstraints)
//    }
//}

/**
 public func loadAdWithStyle1(view: UIView, controller: UIViewController) {
         requestAd(controller: controller)
         
         let adView = NativeAdView()
         adView.translatesAutoresizingMaskIntoConstraints = false
         adView.backgroundColor = .clear
         
         // Set adView to match input view size
         adView.frame = view.bounds  // Or use constraints if view is in hierarchy
         
         var mediaPlaceholder: UIView?
         for subview in view.subviews {
             if subview.tag == AdViewTags.media.rawValue {
                 mediaPlaceholder = subview  // Hold for replacement
                 continue
             }
             subview.removeFromSuperview()
             adView.addSubview(subview)
             // Frames auto-preserve; for Auto Layout, clone if needed (see note below)
         }
         
         let mediaView = MediaView()
         mediaView.translatesAutoresizingMaskIntoConstraints = false
         if let placeholder = mediaPlaceholder {
             // FIXED: Pin mediaView to placeholder's *relative position* in adView
             // Assumes placeholder was positioned in XIB; this mimics it
             adView.addSubview(mediaView)
             NSLayoutConstraint.activate([
                 mediaView.topAnchor.constraint(equalTo: adView.topAnchor, constant: placeholder.frame.origin.y),
                 mediaView.leadingAnchor.constraint(equalTo: adView.leadingAnchor, constant: placeholder.frame.origin.x),
                 mediaView.widthAnchor.constraint(equalToConstant: placeholder.frame.width),
                 mediaView.heightAnchor.constraint(equalToConstant: placeholder.frame.height)
             ])
             placeholder.removeFromSuperview()
         } else {
             print("Missing media placeholder (tag 4).")
             delegate?.didFailedToLoadAd()  // Early fail
             return
         }
         
         // Map views
         adView.headlineView = adView.viewWithTag(AdViewTags.headline.rawValue)
         adView.bodyView = adView.viewWithTag(AdViewTags.body.rawValue)
         adView.callToActionView = adView.viewWithTag(AdViewTags.callToAction.rawValue)
         adView.mediaView = mediaView
         adView.iconView = adView.viewWithTag(AdViewTags.icon.rawValue)
         
         // FIXED: Validate headline too (AdMob requirement)
         guard adView.headlineView != nil, adView.mediaView != nil else {
             print("Missing required tagged views (headline tag 1 or media tag 4).")
             delegate?.didFailedToLoadAd()
             return
         }
         
         nativeAdView = adView
         
         // Attribution (set early, shown after population)
         if let attributionView = adView.viewWithTag(AdViewTags.attribution.rawValue) as? UILabel {
             attributionView.text = "Ad"
             attributionView.isHidden = false
         }
     }
 
 */
