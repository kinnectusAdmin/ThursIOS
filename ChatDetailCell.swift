//
//  ChatDetailCell.swift
//  Thurst
//
//  Created by Blake Rogers on 8/27/16.
//  Copyright © 2016 T3. All rights reserved.
//

import UIKit

class ChatDetailCell: UICollectionViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    let chatterImage: UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 25
            iv.addShadow(0, dy: 19, color: UIColor.black, radius: 10.0, opacity: 0.4)
        return iv
    }()
    
    let messageView: UITextView = {
        let tv = UITextView()
            tv.backgroundColor = UIColor.clear
            tv.textAlignment = .left
            tv.frame = CGRect(x: 0, y: 0, width: 250, height:50)
            tv.font = chivo_AppFont(size: 15, light: true)
            tv.textColor = UIColor.black
            tv.layer.cornerRadius = 10.0
            tv.isUserInteractionEnabled = false
        return tv
    }()
  
    let timeStamp: UILabel = {
        let label = UILabel()
            label.font = chivo_AppFont(size: 12, light: true)
            label.textAlignment = .left
//            label.text = "5 min ago"
            label.textColor = UIColor.lightGray
        return label
    }()
 

}

