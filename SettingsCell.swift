//
//  SettingsCell.swift
//  Thurst
//
//  Created by Blake Rogers on 10/14/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class SettingsCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        contentView.add(views: actionLabel,actionButton,topBorderView)
        
        actionLabel.setLeftTo(con: contentView.left(), by: 0)
        actionLabel.setYTo(con: contentView.y(), by: 0)
        
        
        actionButton.constrainInView(view: contentView , top: nil, left: nil, right: 0, bottom: nil)
        actionButton.setYTo(con: contentView.y(), by: 0)
        
        topBorderView.constrainInView(view: self, top: 0, left: -20, right: 20, bottom: nil)
        topBorderView.setHeightTo(constant: 1)
      
    }
   
    var action: String?{
        didSet{
            actionLabel.text = action ?? ""
        }
    }
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
    let actionButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "next_tri_button"), for: .normal)
        //btn.layer.cornerRadius = 0.0
        //btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let topBorderView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
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
}
