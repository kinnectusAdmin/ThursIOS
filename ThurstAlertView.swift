//
//  ThurstAlertView.swift
//  Thurst
//
//  Created by Blake Rogers on 11/20/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class ThurstAlertView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    init( title: String, message: String){
        super.init(frame: CGRect.zero)
        self.title = title
        self.message = message
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
      
        self.layer.masksToBounds = true
        let blue_frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        let colors = [green_Yellow.cgColor,blue_Purp.withAlphaComponent(0.8).cgColor]
        self.addGradientScreen(frame: blue_frame, start: CGPoint.init(x: 0.0, y: 0.0), end: CGPoint.init(x: 1.0, y: 1.0), locations: [0.0,1.0], colors: colors)
        self.add(views: titleLabel,messageLabel,okButton)
        titleLabel.constrainInView(view: self , top: 15, left: 0, right: 0, bottom: nil)
        titleLabel.text = title
        messageLabel.setXTo(con: self.x(), by: 0)
        messageLabel.setTopTo(con: titleLabel.bottom(), by: 16)
        messageLabel.constrainInView(view: self , top: nil, left: 0, right: 0, bottom: nil)
        messageLabel.text = message
        okButton.constrainInView(view: self , top: nil, left: nil, right: nil, bottom: 0)
        okButton.setXTo(con: self.x(), by: 0)
        okButton.setWidth_Height(width: 75, height:75)
        okButton.addTarget(self , action: #selector(ThurstAlertView.dismiss(_:)), for: .touchUpInside)
    }
    
    var title: String?
    var message: String?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = appFont(size: 30)
       
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = chivo_AppFont(size: 18, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let okButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "OK", attributes: [NSFontAttributeName: appFont_18,NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 37.5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func dismiss(_ sender: UIButton){
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
            self.superview?.viewWithTag(101)?.alpha = 0.0
        },completion: {
            _ in
            self.superview?.viewWithTag(101)?.removeFromSuperview()
            self.removeFromSuperview()
        })
       
    }
}
