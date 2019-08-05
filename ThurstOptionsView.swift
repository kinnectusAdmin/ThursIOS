//
//  ThurstOptionsView.swift
//  Thurst
//
//  Created by Blake Rogers on 12/17/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
protocol ThurstOptionsDelegate{
    func okResponse()
    func cancelResponse()
}
class ThurstOptionsView: UIView {

    // MARK: - UIElements
    var title: String?
    var message: String?
    var delegate: ThurstOptionsDelegate?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = appFont(size: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.font = chivo_AppFont(size: 15, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    let okButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "OK", attributes: [NSFontAttributeName: appFont_18,NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Cancel", attributes: [NSFontAttributeName: appFont_18,NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Functions
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
        self.add(views: titleLabel,messageLabel,okButton,cancelButton)
        titleLabel.constrainInView(view: self , top: 15, left: 0, right: 0, bottom: nil)
        titleLabel.text = title
        messageLabel.setXTo(con: self.x(), by: 0)
        messageLabel.setTopTo(con: titleLabel.bottom(), by: 16)
        messageLabel.constrainInView(view: self , top: nil, left: 0, right: 0, bottom: nil)
        messageLabel.text = message
        
        okButton.constrainInView(view: self , top: nil, left: nil, right: nil, bottom: 0)
        okButton.setRightTo(con: self.x(), by: -8)
        okButton.setWidth_Height(width: 100, height:50)
        okButton.addTarget(self , action: #selector(ThurstOptionsView.ok(_:)), for: .touchUpInside)
        
        cancelButton.constrainInView(view: self , top: nil, left: nil, right: nil, bottom: 0)
        cancelButton.setLeftTo(con: self.x(), by: 8)
        cancelButton.setWidth_Height(width: 100, height:50)
        cancelButton.addTarget(self , action: #selector(ThurstOptionsView.cancel(_:)), for: .touchUpInside)
    }
    func dismissOptions(){
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.0
            self.superview?.viewWithTag(101)?.alpha = 0.0
        },completion: {
            _ in
            self.superview?.viewWithTag(101)?.removeFromSuperview()
            self.removeFromSuperview()
        })
    }
    
    func ok(_ sender: UIButton){
        delegate?.okResponse()
        dismissOptions()
    }
    func cancel(_ sender: UIButton){
        delegate?.cancelResponse()
        dismissOptions()
    }
}
