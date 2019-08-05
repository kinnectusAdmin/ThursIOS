//
//  SettingsSwitchCell.swift
//  Thurst
//
//  Created by Blake Rogers on 10/14/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class SettingsSwitchCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        contentView.add(views: actionLabel,actionSwitch,topBorderView)
        
        self.constrainInView(view: contentView , top: nil, left: 0, right: nil, bottom: nil)
        actionLabel.setLeftTo(con: contentView.left(), by: 0)
        actionLabel.setYTo(con: contentView.y(), by: 0)
        
        
        actionSwitch.frame = CGRect(x: contentView.frame.maxX - 30, y: contentView.frame.midY, width: 30, height: 12)
        actionSwitch.addShadow(0, dy: 10, color: UIColor.black, radius: 10.0, opacity: 0.6)
        topBorderView.constrainInView(view: self, top: 0, left: -20, right: 20, bottom: nil)
        topBorderView.setHeightTo(constant: 1)
        
        
    }
    private var hideProfileContext = 0
    private var locationContext = 1
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let cell = object as? SettingsSwitchCell else { return}
    
        if context == &hideProfileContext{
            if let hideStatus = change?[.newKey] as? Bool{
                if let user = ThurstUser().currentUser(){
                            user.isHiddenProfile = hideStatus
                            user.updateCurrentUser(server: true)
                }
            }
        }else if context == &locationContext{
            if let locationStatus = change?[.newKey] as? Bool{
                if let user = ThurstUser().currentUser(){
                user.isTurnOnLocation = locationStatus
                user.updateCurrentUser(server: true)
                }
            }
        }
    }
    var action: String = ""{
        didSet{
            actionLabel.text = action 
            switch action{
            case "HIDE PROFILE":
                addObserver(self , forKeyPath: #keyPath(SettingsSwitchCell.actionSwitch.isOn), options: .new , context: &hideProfileContext)
            case "LOCATION":
                addObserver(self , forKeyPath: #keyPath(SettingsSwitchCell.actionSwitch.isOn), options: .new , context: &locationContext)
            default: break
            }
        }
    }
    var onColor: UIColor = UIColor.black{
        didSet{
            actionSwitch.onTintColor = onColor
        }
    }
    var offColor: UIColor = UIColor.black{
        didSet{
            actionSwitch.offTintColor = offColor
        }
    }
    let topBorderView: UIView = {
        let v = UIView()
        v.backgroundColor = createColor(210, green: 210, blue: 210)
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let bottomBorderView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let actionLabel: UILabel = {
        
     
        let lab = UILabel()
        lab.textAlignment = .left
        lab.font = chivo_AppFont(size: 10, light: true)
        lab.textColor = UIColor.black
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let actionSwitch: CustomSwitch = {
        let swtch = CustomSwitch()
        swtch.onTintColor = UIColor.black
        swtch.offTintColor = UIColor.black.withAlphaComponent(0.6)
        swtch.thumbTintColor = UIColor.white
        swtch.layer.shadowColor = UIColor.black.cgColor
        swtch.layer.shadowOffset = CGSize(width: 0, height: 20)

        return swtch
    }()
}
