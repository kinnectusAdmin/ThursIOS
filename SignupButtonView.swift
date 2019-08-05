//
//  SignupButtonView.swift
//  Thurst
//
//  Created by Blake Rogers on 2/12/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit

class SignupButtonView: UIView {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        self.backgroundColor = UIColor.white
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let colors = [createColor(153, green: 255, blue: 255).cgColor,UIColor.white.cgColor]
        self.addGradientScreen(frame: frame, start: CGPoint.zero, end: CGPoint(x:1.0,y:1.0), locations: [0.0,1.0], colors: colors)
        
//        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
//        self.layer.shadowOffset = CGSize(width: 5, height: 10)
//        self.layer.shadowRadius = 10.0
//        self.layer.shadowOpacity = 0.5
        addSubview(signUpButton)
        signUpButton.setXTo(con: self.x(), by: 0)
        signUpButton.setYTo(con: self.y(), by: 0)
    }
    let signUpButton: UIButton = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 18, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "E N T E R", attributes: atts)
        let btn = UIButton()
        btn.setAttributedTitle(attTxt, for: .normal)
        btn.isUserInteractionEnabled = false
        btn.adjustsImageWhenHighlighted = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

}
