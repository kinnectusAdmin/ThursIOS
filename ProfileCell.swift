//
//  ProfileCell.swift
//  Thurst
//
//  Created by Blake Rogers on 10/10/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
protocol ProfileImageDelegate {
    func deleteImage(image: String)
    func insertImage()
}
class ProfileCell: UICollectionViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        contentView.add(views: profileImage,deleteButton)
        contentView.clipsToBounds = false
        
        profileImage.setXTo(con: contentView.x(), by: -5)
        profileImage.setWidth_Height(width: contentView.frame.width*0.8, height: contentView.frame.height*0.8)
        profileImage.setYTo(con: contentView.y(), by: 0)
        deleteButton.setXTo(con: profileImage.right(), by: -5)
        deleteButton.setYTo(con: profileImage.bottom(), by: 0)
        deleteButton.setWidth_Height(width: 20, height: 20)
        deleteButton.addTarget(self , action: #selector(ProfileCell.select_image(_:)), for: .touchUpInside)
    }
    var isPrimary: Bool = false{
        didSet{
            if isPrimary{
                profileImage.layer.borderColor = createColor(0, green: 203, blue: 254).cgColor
                profileImage.layer.borderWidth = 2.0
            }else{
                profileImage.layer.borderWidth = 0.0
            }
        }
    }
    var imageURL: String?
    var imageDelegate: ProfileImageDelegate?
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius  = 0
        iv.layer.borderColor = UIColor.white.cgColor
        iv.backgroundColor = UIColor.gray
        iv.layer.masksToBounds = true
        iv.alpha = 0.0
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "X", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 8, weight: 0.0),NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor.black
        button.alpha = 0.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    func animateImageBorder(){
        
    }
    
    func showImage(delay: Double, show: Bool){
        let alpha:CGFloat = show ? 1.0 : 0.0
        UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
            self.profileImage.alpha = alpha
            self.deleteButton.alpha = alpha
        }, completion: nil)
    }
    func select_image(_ sender: UIButton){
        if sender.attributedTitle(for: .normal)!.string == "X"{
            if let image = imageURL{
                imageDelegate?.deleteImage(image: image)
            }
        }else{
            imageDelegate?.insertImage()
        }
    }
}
