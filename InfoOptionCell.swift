//
//  InfoOptionCell.swift
//  Thurst
//
//  Created by Blake Rogers on 11/25/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class InfoOptionCell: UICollectionViewCell {
    override func layoutSubviews() {
        setViews()
    }
    func setViews(){
        contentView.backgroundColor = UIColor.clear
        contentView.add(views: optionLabel)
        optionLabel.setXTo(con: contentView.x(), by: 0)
        optionLabel.setYTo(con: contentView.y(), by: 0)
        optionLabel.setWidth_Height(width: contentView.frame.width-5, height: 45)
    }
    override var isSelected: Bool{
        didSet{
            optionLabel.textColor = isSelected ? createColor(0, green: 203, blue: 254) : UIColor.white
        }
    }
    var optionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.black
        label.textAlignment = .center
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.borderWidth = 1.0
        label.font = chivo_AppFont(size: 12, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}
