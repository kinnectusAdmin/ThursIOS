//
//  ChatImageCell.swift
//  Thurst
//
//  Created by Blake Rogers on 2/10/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit

class ChatImageCell: UICollectionViewCell {
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
    let messageImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.layer.cornerRadius = 8.0
        iv.addShadow(10, dy: 10, color: UIColor.black, radius: 10.0, opacity: 0.4)
        return iv
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
