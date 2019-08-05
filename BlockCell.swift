//
//  BlockCell.swift
//  Thurst
//
//  Created by Blake Rogers on 2/10/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
protocol BlockDelegate{
    func unblockUser( id: String)
}
class BlockCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        add(views: deleteButton, blockImage,nameLabel,addedLabel)
        deleteButton.setWidth_Height(width: 50, height: 50)
        deleteButton.setLeftTo(con: contentView.left(), by: -20)
        contentView.clipsToBounds = false
        deleteButton.addTarget(self , action: #selector(BlockCell.select_unblock(_:)), for: .touchUpInside)
        blockImage.setWidth_Height(width: 50, height:50)
        blockImage.setLeftTo(con: deleteButton.right(), by: 0)
        blockImage.setTopTo(con: deleteButton.top(), by: 0)
        self.clipsToBounds = false
        
        nameLabel.setLeftTo(con: blockImage.right(), by: 20)
        nameLabel.setYTo(con: blockImage.y(), by: 0)
        nameLabel.setRightTo(con: contentView.right(), by: 0)
        
        addedLabel.setXTo(con: nameLabel.x(), by: 0)
        addedLabel.setTopTo(con: nameLabel.bottom(), by: 10)
        addedLabel.setRightTo(con: contentView.right() , by: 0)
        
        let shadow = UIView()
        shadow.backgroundColor = UIColor.white
        contentView.insertSubview(shadow , belowSubview: deleteButton)
        shadow.setLeftTo(con: deleteButton.left(), by: 0)
        shadow.setRightTo(con: blockImage.right(), by: 0)
        shadow.setTopTo(con: deleteButton.top(), by: 0)
        shadow.setBottomTo(con: deleteButton.bottom(), by: 0)
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.addShadow(0, dy: 10, color: UIColor.black, radius: 4.0, opacity: 0.2)
    }
    var account_id: String?
    var delegate: BlockDelegate?
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
    let blockImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "deleteButton"), for: .normal)
        button.backgroundColor = light_green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    func select_unblock(_ sender: UIButton){
        delegate?.unblockUser(id: account_id!)
    }
}

