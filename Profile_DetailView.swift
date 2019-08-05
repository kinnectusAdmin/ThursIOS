//
//  Profile_DetailView.swift
//  Thurst
//
//  Created by Blake Rogers on 10/6/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class Profile_DetailView: UIView {
    // MARK: - Data
    var textSize: CGFloat{
        
        return UIScreen.main.bounds.width > 375.0 ? 15.0 : 12.0
    }
    var thurstUser: ThurstUser?{
        
        didSet{
            bday = MyCalendar().formattedBday(bday: thurstUser?.bday ?? "")
            gender = thurstUser?.gender ?? ""
            rel_status = thurstUser?.relationshipStatus ?? ""
            if let locationOn = thurstUser?.isTurnOnLocation{
                if locationOn{
                    location = thurstUser?.location ?? ""
                }
            }
            sexuality = thurstUser?.sexuality ?? ""
            if let count = thurstUser?.connectionCount{
                if count >= 100000000{
                    connections = "0"
                }else{
                     connections = String(describing:count)
                }
            }
            
        }
    }
    var bday = ""
    var gender = ""
    var rel_status = ""
    var location = ""
    var sexuality = ""
    var connections = "0"
    
    
    // MARK: - UIElements
    lazy var bdayLabel: UILabel = {
        let lab = UILabel()
        lab.text = "BIRTHDAY"
        lab.textColor = UIColor.gray
        lab.font = chivo_AppFont(size: self.textSize, light: true)
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    lazy var bdayInfo: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.alpha = 0.0
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var locationLabel: UILabel = {
        let lab = UILabel()
        lab.text = "LOCATION"
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.gray
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var locationInfo: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.alpha = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var sexLabel: UILabel = {
        let lab = UILabel()
        lab.text = "SEXUALITY"
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.gray
        lab.textAlignment = .center
     
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var sexInfo: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.alpha = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var relationshipLabel: UILabel = {
        let lab = UILabel()
        lab.text = "RELATIONSHIP"
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.gray
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var relationshipInfo: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.alpha = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var genderLabel: UILabel = {
        
        let lab = UILabel()
        lab.text = "GENDER"
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.gray
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var genderInfo: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.alpha = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    lazy var connectionsLabel: UILabel = {
        
        let lab = UILabel()
        lab.text = "CONNECTIONS"
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.gray
        lab.textAlignment = .center
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    lazy var connectionsInfo: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size:  self.textSize, light: true)
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.alpha = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    


    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        backgroundColor = UIColor.black
        add(views: bdayLabel,locationLabel,sexLabel,relationshipLabel,genderLabel,connectionsLabel)
        add(views: bdayInfo,locationInfo,sexInfo,relationshipInfo,genderInfo,connectionsInfo)
        
        bdayLabel.constrainInView(view: self, top: 10, left: 0, right: nil, bottom: nil)
        bdayInfo.setXTo(con: bdayLabel.x(), by: 0)
        bdayInfo.setTopTo(con: bdayLabel.bottom(), by: 4)
        
        locationLabel.setXTo(con: self.x(), by: 0)
        locationLabel.setTopTo(con: bdayLabel.top(), by: 0)
        locationInfo.setXTo(con: locationLabel.x(), by: 0)
        locationInfo.setTopTo(con: locationLabel.bottom(), by: 4)
        
        sexLabel.setRightTo(con: self.right(), by: -10)
        sexLabel.setTopTo(con: bdayLabel.top(), by: 0)
        sexInfo.setXTo(con: sexLabel.x(), by: 0)
        sexInfo.setTopTo(con: sexLabel.bottom(), by: 4)
        
        relationshipLabel.setLeftTo(con: bdayLabel.left(), by: 0)
        relationshipLabel.setTopTo(con: bdayLabel.bottom(), by: 30)
        relationshipInfo.setXTo(con: relationshipLabel.x(), by: 0)
        relationshipInfo.setTopTo(con: relationshipLabel.bottom(), by: 4)
        
        genderLabel.setXTo(con: self.x(), by: 0)
        genderLabel.setTopTo(con: relationshipLabel.top(), by: 0)
        genderInfo.setXTo(con: genderLabel.x(), by: 0)
        genderInfo.setTopTo(con: genderLabel.bottom(), by: 4)
        
        connectionsLabel.setRightTo(con: sexLabel.right(), by: 0)
        connectionsLabel.setTopTo(con: relationshipLabel.top(), by: 0)
        connectionsInfo.setXTo(con: connectionsLabel.x(), by: 0)
        connectionsInfo.setTopTo(con: connectionsLabel.bottom(), by: 4)
        
    }
    func show_user_data(){
        bdayInfo.text = bday
        locationInfo.text = location
        sexInfo.text = sexuality
        relationshipInfo.text = rel_status
        genderInfo.text = gender
        connectionsInfo.text = connections
        UIView.animate(withDuration: 0.5, animations: {
            self.bdayInfo.alpha = 1.0
            self.genderInfo.alpha = 1.0
            self.locationInfo.alpha = 1.0
            self.sexInfo.alpha = 1.0
            self.relationshipInfo.alpha = 1.0
            self.connectionsInfo.alpha = 1.0
        })
    }
    
    func hide_user_data(){
        let bday = ""
        let gender = ""
        let rel_status = ""
        let location = ""
        let sexuality = ""
        let connections = ""
        
        bdayInfo.text = bday
        locationInfo.text = location
        sexInfo.text = sexuality
        relationshipInfo.text = rel_status
        genderInfo.text = gender
        connectionsInfo.text = connections
        UIView.animate(withDuration: 0.5, animations: {
            self.bdayInfo.alpha = 0.0
            self.genderInfo.alpha = 0.0
            self.locationInfo.alpha = 0.0
            self.sexInfo.alpha = 0.0
            self.relationshipInfo.alpha = 0.0
            self.connectionsInfo.alpha = 0.0
        })
    }
}
