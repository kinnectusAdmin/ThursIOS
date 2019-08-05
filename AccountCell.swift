//
//  AccountCell.swift
//  Thurst
//
//  Created by Blake Rogers on 2/11/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
protocol AccountDelegate {
    func setEmail(email:String)
    func setPhoneNumber(phoneNumber:String)
    func setPassword(password: String)
}
class AccountCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        contentView.add(views: actionLabel,infoLabel,infoField,actionButton,topBorderView)
        
        actionLabel.setLeftTo(con: contentView.left(), by: 0)
        actionLabel.setYTo(con: contentView.y(), by: 0)
        
        infoLabel.setLeftTo(con: actionLabel.left(), by: 0)
        infoLabel.setTopTo(con: actionLabel.bottom(), by: 4)
        
        infoField.setLeftTo(con: actionLabel.left(), by: 0)
        infoField.setTopTo(con: infoLabel.bottom(), by: 4)
        infoField.setRightTo(con: contentView.right(), by: 0)
        
        actionButton.constrainInView(view: contentView , top: nil, left: nil, right: 0, bottom: nil)
        actionButton.setYTo(con: contentView.y(), by: 0)
        actionButton.addTarget(self , action: #selector(AccountCell.select_action(_:)), for: .touchUpInside)
        
        topBorderView.constrainInView(view: self, top: 0, left: -20, right: 20, bottom: nil)
        topBorderView.setHeightTo(constant: 1)
        
    }
    var delegate: AccountDelegate?
    var accountDetail: String?{
        didSet{
            infoLabel.text = accountDetail ?? ""
            switch action! {
            case "EMAIL":
                infoField.placeholder = "Enter alternate email"
            case "PHONE NUMBER":
                infoField.placeholder = "Enter alternate phone number"
            case "PASSWORD":
                infoField.isSecureTextEntry = true
                infoField.placeholder = "Enter alternate email"
            default:
                break
            }
        }
    }
    
    let infoLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.font = chivo_AppFont(size: 10, light: true)
        lab.textColor = UIColor.black
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let infoField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.text = ""
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 15)
        return field
    }()
    var accountInfo: String{
        return infoField.text ?? ""
    }
    var action: String?{
        didSet{
            actionLabel.text = action ?? ""
        }
    }
    let actionLabel: UILabel = {
        
        let lab = UILabel()
        lab.textAlignment = .left
        lab.font = chivo_AppFont(size: 18, light: true)
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
    func select_action(_ sender: UIButton){
        guard !accountInfo.isEmpty else {return}
        switch action! {
        case "EMAIL":
            delegate?.setEmail(email: accountInfo)
        case "PHONE NUMBER":
            guard accountInfo.characters.count == 10 else { return}
           delegate?.setPhoneNumber(phoneNumber: accountInfo)
        case "PASSWORD":
           delegate?.setPassword(password: accountInfo)
        default:
            break
        }
       
    }
}
