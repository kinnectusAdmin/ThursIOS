//
//  ConnectionProfileCell.swift
//  Thurst
//
//  Created by Blake Rogers on 11/7/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class ConnectionProfileCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        contentView.add(views: profileImage)
        profileImage.constrainWithMultiplier(view: self.contentView, width: 0.8, height: 0.8)
    }
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile1")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius  = 0
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = UIColor.gray
        iv.layer.masksToBounds = true
        iv.alpha = 0.0
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
  
    func animateImageBorder(){
        
    }
    func showImage(delay: Double, show: Bool){
        let alpha:CGFloat = show ? 1.0 : 0.0
        UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
            self.profileImage.alpha = alpha
        }, completion: nil)
    }
}

