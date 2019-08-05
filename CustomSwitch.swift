//
//  CustomSwitch.swift
//  Thurst
//
//  Created by Blake Rogers on 9/20/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

@objcMembers class CustomSwitch: UIControl {

    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating{
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadius
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            let thumbWidth_Height = self.bounds.size.height - self.padding
            let size = CGSize(width: thumbWidth_Height, height: thumbWidth_Height)
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : size
            let yOrigin = self.bounds.size.height - thumbSize.height
            onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yOrigin)
            offPoint = CGPoint(x: self.padding,y: yOrigin)
            let point = self.isOn ? self.onPoint : self.offPoint
            self.thumbView.frame = CGRect(origin: point , size: thumbSize)
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbRadius
            self.thumbView.layer.shadowColor = UIColor.black.cgColor
            self.thumbView.layer.shadowRadius = 1.5
            self.thumbView.layer.shadowOpacity = 0.4
            self.thumbView.layer.shadowOffset = CGSize(width: 0.5, height: 1.0)
            setUpUI()
        }
    }

    var onTintColor: UIColor = UIColor.black{
        didSet{
            self.setUpUI()
        }
    }
    var offTintColor: UIColor = UIColor.black{
        didSet{
            self.setUpUI()
        }
    }
    var cornerRadius: CGFloat = 0.5{
        didSet{
            self.layoutSubviews()
        }
    }
    var thumbSize: CGSize = CGSize.zero{
        didSet{
            self.layoutSubviews()
        }
    }
    var thumbRadius: CGFloat = 0.5{
        didSet{
            self.layoutSubviews()
        }
    }
    var thumbTintColor: UIColor = UIColor.white{
        didSet{
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    var padding: CGFloat = 1{
        didSet{
            self.layoutSubviews()
        }
    }
    
    dynamic var isOn: Bool = false;
    var isAnimating: Bool = false;
    var animationDuration: Double = 0.5;
    
    var thumbView: UIView = UIView(frame: CGRect.zero)
    var onPoint: CGPoint = CGPoint.zero;
    var offPoint: CGPoint = CGPoint.zero;
    
    func clear(){
        for view in subviews{
            view.removeFromSuperview()
        }
    }
    
    func setUpUI(){
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor;
        self.thumbView.isUserInteractionEnabled = false
        self.addSubview(self.thumbView)
        
        
    }
    func animate(){
        self.isOn = !self.isOn
        self.isAnimating = !self.isAnimating
        UIView.animate(withDuration: self.animationDuration) {
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }
        UIView.animate(withDuration: self.animationDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseOut,.beginFromCurrentState], animations: {
            self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
            
        }, completion: {_ in
            self.isAnimating = false
            self.sendActions(for: .valueChanged)
        })
    }
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch , with: event)
        self.animate()
        return true
    }
}
