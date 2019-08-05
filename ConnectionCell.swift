//
//  ConnectionCell.swift
//  Thurst
//
//  Created by Blake Rogers on 10/30/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
protocol ThurstConnectionDelegate{
    func chatWith()
}
class ConnectionCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        add(views: messageButton, connectionImage,nameLabel,addedLabel)
        messageButton.setWidth_Height(width: 60, height: 70)
        messageButton.setRightTo(con: contentView.left(), by: 0)
        contentView.clipsToBounds = false
        messageButton.addTarget(self , action: #selector(ConnectionCell.messageConnection(_:)), for: .touchUpInside)
        connectionImage.setWidth_Height(width: 60, height:70)
        connectionImage.setLeftTo(con: messageButton.right(), by: 0)
        connectionImage.setTopTo(con: messageButton.top(), by: 0)
        self.clipsToBounds = false
        
        nameLabel.setLeftTo(con: connectionImage.right(), by: 20)
        nameLabel.setTopTo(con: connectionImage.top(), by: 0)
        nameLabel.setRightTo(con: contentView.right(), by: 0)
        
        addedLabel.setXTo(con: nameLabel.x(), by: 0)
        addedLabel.setTopTo(con: nameLabel.bottom(), by: 10)
        addedLabel.setRightTo(con: contentView.right() , by: 0)
        
        let shadow = UIView()
            shadow.backgroundColor = UIColor.white
        contentView.insertSubview(shadow , belowSubview: messageButton)
        shadow.setLeftTo(con: messageButton.left(), by: 0)
        shadow.setRightTo(con: connectionImage.right(), by: 0)
        shadow.setTopTo(con: messageButton.top(), by: 0)
        shadow.setBottomTo(con: messageButton.bottom(), by: 0)
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.addShadow(0, dy: 10, color: UIColor.black, radius: 4.0, opacity: 0.2)
    }
    
    var delegate: ThurstConnectionDelegate?
    var addedLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = chivo_AppFont(size: 12, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.font = chivo_AppFont(size: 18, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let connectionImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let messageButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "messageButton"), for: .normal)
        button.backgroundColor = light_green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    func messageConnection(_ sender: UIButton){
        delegate?.chatWith()
    }
}
