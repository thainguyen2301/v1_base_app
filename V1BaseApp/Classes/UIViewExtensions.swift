//
//  UIViewExtensions.swift
//  V1BaseApp
//
//  Created by ThaiNguyen on 5/12/25.
//

import UIKit

private var kViewTopConstraint: UInt8 = 0
private var kViewLeftConstraint: UInt8 = 0
private var kViewRightConstraint: UInt8 = 0
private var kViewBottomConstraint: UInt8 = 0
private var kViewWidthConstraint: UInt8 = 0
private var kViewHeightConstraint: UInt8 = 0
private var kViewRatioConstraint: UInt8 = 0
private var kViewCenterXConstraint: UInt8 = 0
private var kViewCenterYConstraint: UInt8 = 0
private var kViewAdditionalConstraints: UInt8 = 0
extension UIView { // layout vars
    public var privateAdditionalConstraints: [String: NSLayoutConstraint]? {
        get {
            return objc_getAssociatedObject(self, &kViewAdditionalConstraints) as? [String: NSLayoutConstraint]
        }
        set {
            objc_setAssociatedObject(self, &kViewAdditionalConstraints, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var additionalConstraints: [String: NSLayoutConstraint] {
        get {
            if privateAdditionalConstraints == nil {
                privateAdditionalConstraints = [:]
            }
            return privateAdditionalConstraints!
        }
        set {
            privateAdditionalConstraints = newValue
        }
    }
    
    @IBOutlet open var centerXLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewCenterXConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewCenterXConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var centerYLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewCenterYConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewCenterYConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var topLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewTopConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewTopConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var leftLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewLeftConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewLeftConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var bottomLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewBottomConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewBottomConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var rightLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewRightConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewRightConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var widthLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewWidthConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewWidthConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var heightLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewHeightConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewHeightConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @IBOutlet open var ratioLayoutConstraint: NSLayoutConstraint? {
        get {
            return objc_getAssociatedObject(self, &kViewRatioConstraint) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(self, &kViewRatioConstraint, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


@IBDesignable
extension UIView {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            self.layer.borderColor = UIColor.gray.cgColor
            self.layer.borderWidth = newValue
        }
        
        get {
            return self.layer.borderWidth
        }
        
    }
    
}


public extension UIView {
    
    func roundCorner(_ radius: CGFloat, color: UIColor = .clear, width: CGFloat = 0) {
        layer.cornerRadius = radius
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.masksToBounds = true
    }
    
    func roundingCornerTopLeftRight() {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 16, height: 16))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func roundingCornerBottomLeftRight() {
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: [.bottomLeft, .bottomRight],
                                    cornerRadii: CGSize(width: 16, height: 16))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        self.layer.mask = shape
    }
    
    func addGradientColor(colors: [CGColor]) {
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.colors = colors
        self.layer.insertSublayer(layer, at: 0)
    }
    
    func addGradientColor(colors: [CGColor], startPoints: CGPoint, endPoint: CGPoint, location: [NSNumber]) {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        gradient.locations = location
        gradient.startPoint = startPoints
        gradient.endPoint = endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]? = nil, opacity: Float = 1) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.opacity = opacity
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    func addShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
    }

    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0
    }
    
    func getSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()

        return image
    }
    
    func getImageSnapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        defer {
            UIGraphicsEndImageContext()
        }
        drawHierarchy(in: frame, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
}

// MARK: Autolayout Helper
public extension UIView {
    func setEdgesConstraint(to view: UIView, padding: UIEdgeInsets = .zero) {
        self.setConstraint(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: padding)
    }
    
    func setConstraint(top: NSLayoutYAxisAnchor? = nil, leading: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, trailing: NSLayoutXAxisAnchor? = nil, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        // enable autolayout for view
        self.translatesAutoresizingMaskIntoConstraints = false
        // -- set layout for view
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            self.leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        if let trailing = trailing {
            self.trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        // -- set size for view
        if size.width != 0 {
            self.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            self.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    @discardableResult
    func setConstraint(width: CGFloat?, height: CGFloat?, priority: UILayoutPriority = .required) -> (w: NSLayoutConstraint?, h: NSLayoutConstraint?)
    {
        // enable autolayout for view
        self.translatesAutoresizingMaskIntoConstraints = false
        var w: NSLayoutConstraint?
        var h: NSLayoutConstraint?
        
        // -- set size for view
        if let width = width {
            w = self.widthAnchor.constraint(equalToConstant: width)
            w?.priority = priority
            w?.isActive = true
        }
        if let height = height {
            h = self.heightAnchor.constraint(equalToConstant: height)
            h?.priority = priority
            h?.isActive = true
        }
        return (w: w, h: h)
    }
    
    func setAdditionalConstraint(_ constraint: NSLayoutConstraint, forKey key: String) {
        NSLayoutConstraint.activate([constraint])
        additionalConstraints[key] = constraint
    }
    
    func fullscreen(_ relativeView: UIView? = nil, type: ViewFullScreenType = .TopLeftBottomRight) {
        var view = relativeView
        if view == nil {
            view = superview
        }
        guard let sup = view else {return}
        translatesAutoresizingMaskIntoConstraints = false
        
        switch type {
        case .CenterXYWidthHeight:
            setCenterX(0.0, relativeToView: sup)
            setCenterY(0.0, relativeToView: sup)
            setWidth(0.0, relativeToView: sup)
            setHeight(0.0, relativeToView: sup)
            
        default:
            setTop(0.0, relativeToView: sup)
            setLeft(0.0, relativeToView: sup)
            setBottom(0.0, relativeToView: sup)
            setRight(0.0, relativeToView: sup)
        }
    }
    
    func marginAll(_ value: Double, relativeView: UIView? = nil) {
        var view = relativeView
        if view == nil {
            view = superview
        }
        guard let superview = view else {return}
        translatesAutoresizingMaskIntoConstraints = false
        
        setLeft(value, relativeToView: superview)
        setRight(-value, relativeToView: superview)
        setTop(value, relativeToView: superview)
        setBottom(-value, relativeToView: superview)
    }
    
    func centralize() {
        guard let sup = superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        setCenterX(0.0, relativeToView: sup)
        setCenterY(0.0, relativeToView: sup)
    }
    
    @discardableResult
    func setCenterX(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .centerX) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerXLayoutConstraint?.deactivate()
        let centerXCons = NSLayoutConstraint.init(item: self, attribute: .centerX, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([centerXCons])
        centerXLayoutConstraint = centerXCons
        return self
    }
    
    @discardableResult
    func setCenterY(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .centerY) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        centerYLayoutConstraint?.deactivate()
        let centerYCons = NSLayoutConstraint.init(item: self, attribute: .centerY, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([centerYCons])
        centerYLayoutConstraint = centerYCons
        return self
    }
    
    @discardableResult
    func setTop(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .top, relatedBy: NSLayoutConstraint.Relation = .equal) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        topLayoutConstraint?.deactivate()
        let topCons = NSLayoutConstraint.init(item: self, attribute: .top, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([topCons])
        topLayoutConstraint = topCons
        return self
    }
    
    @discardableResult
    func setLeft(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .left, relatedBy: NSLayoutConstraint.Relation = .equal) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        leftLayoutConstraint?.deactivate()
        let leftCons = NSLayoutConstraint.init(item: self, attribute: .left, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([leftCons])
        leftLayoutConstraint = leftCons
        return self
    }
    
    @discardableResult
    func setBottom(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .bottom, relatedBy: NSLayoutConstraint.Relation = .equal) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        bottomLayoutConstraint?.deactivate()
        let bottomCons = NSLayoutConstraint.init(item: self, attribute: .bottom, relatedBy: relatedBy, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([bottomCons])
        bottomLayoutConstraint = bottomCons
        return self
    }
    
    @discardableResult
    func setRight(_ constant: CGFloat, relativeToView: UIView, relativeAttribute: NSLayoutConstraint.Attribute = .right, relatedBy: NSLayoutConstraint.Relation = .equal) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        rightLayoutConstraint?.deactivate()
        let rightCons = NSLayoutConstraint.init(item: self, attribute: .right, relatedBy: .equal, toItem: relativeToView, attribute: relativeAttribute, multiplier: 1.0, constant: constant)
        NSLayoutConstraint.activate([rightCons])
        rightLayoutConstraint = rightCons
        return self
    }
    
    @discardableResult
    func setWidth(_ constant: CGFloat, relativeToView: UIView? = nil, relation: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        widthLayoutConstraint?.deactivate()
        let widthCons = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: relativeToView, attribute: relativeToView == nil ? .notAnAttribute : .width, multiplier: multiplier, constant: constant)
        NSLayoutConstraint.activate([widthCons])
        widthLayoutConstraint = widthCons
        return self
    }
    
    @discardableResult
    func setHeight(_ constant: CGFloat, relativeToView: UIView? = nil, relation: NSLayoutConstraint.Relation = .equal, multiplier: CGFloat = 1.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        heightLayoutConstraint?.deactivate()
        let heightCons = NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: relation, toItem: relativeToView, attribute: relativeToView == nil ? .notAnAttribute : .height, multiplier: multiplier, constant: constant)
        NSLayoutConstraint.activate([heightCons])
        heightLayoutConstraint = heightCons
        return self
    }
    
    @discardableResult
    func setRatio(_ r: CGFloat, c: CGFloat = 0.0) -> UIView {
        translatesAutoresizingMaskIntoConstraints = false
        ratioLayoutConstraint?.deactivate()
        let ratioCons = NSLayoutConstraint.init(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: r, constant: c)
        NSLayoutConstraint.activate([ratioCons])
        ratioLayoutConstraint = ratioCons
        return self
    }
    
    func removeConstraintsToOtherViews() {
        var _spView = superview
        while let spView = _spView{
            for constraint in spView.constraints {
                if (constraint.firstItem as? UIView == self) || (constraint.secondItem  as? UIView == self) {
                    spView.removeConstraint(constraint)
                }
            }
            _spView = spView.superview
        }
    }
    
    func removeSelfConstraints() {
        self.removeConstraintsToOtherViews()
        self.removeConstraints(self.constraints)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}

extension NSLayoutConstraint {
    func deactivate() {
        NSLayoutConstraint.deactivate([self])
    }
}

public enum ViewFullScreenType {
    case TopLeftBottomRight
    case CenterXYWidthHeight
}

extension UIView {
    func loadViewFromNib() {
        let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
        let view = Bundle(for: type(of: self)).loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let views = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: views))
        setNeedsUpdateConstraints()
    }
}
