//
//  SettingsVC.swift
//  Thurst
//
//  Created by Blake Rogers on 10/14/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

@objcMembers class SettingsVC: UIViewController {
    // MARK: - UIElements
    var user: ThurstUser? {
        didSet{
            settingsCV.reloadData()
        }
    }
    let bannerView: UIView = {
        let v = UIView()
        v.backgroundColor = light_pink
        v.layer.cornerRadius = 0.0
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 4.0
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let navButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "nav_button"), for: .normal)
        //btn.layer.cornerRadius = 0.0
        //btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    var headingTopCon = NSLayoutConstraint()
    let headingLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.text = "S E T T I N G S"
        lab.alpha = 0.0
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.font = chivo_AppFont(size: 18, light: false)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let thurstLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "THURST", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let settingsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 60)
        let frame = CGRect(x: 0, y: 0, width: 300, height: 60)
        let cv = UICollectionView(frame: frame , collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        settingsCV.register(SettingsCell.self , forCellWithReuseIdentifier: "SettingsCell")
        settingsCV.register(SettingsSwitchCell.self , forCellWithReuseIdentifier: "SettingsSwitchCell")
        settingsCV.register(SettingsHeader.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SettingsHeader")
        settingsCV.register(SettingsFooter.self , forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "SettingsFooter")
        settingsCV.delegate = self
        settingsCV.dataSource = self
        setSettings()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViews(){
        view.backgroundColor = UIColor.white
        view.add(views: settingsCV,bannerView)
        
        bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
        bannerView.setHeightTo(constant: 85)
        bannerView.add(views: navButton,thurstLabel,headingLabel)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(SettingsVC.show_menu(_:)), for: .touchUpInside)
        
        headingTopCon = headingLabel.setTopTo_Return(con: bannerView.bottom(), by: 0)
        headingLabel.setXTo(con: bannerView.x(), by: 0)
        
        settingsCV.constrainInView(view: self.view , top: 65, left: nil, right: nil, bottom: 0)
        settingsCV.setXTo(con: self.view.x(), by: 0)
        settingsCV.setWidthTo(constant: self.view.frame.width*0.65)
        
        let cvShadow = UIView()
            cvShadow.translatesAutoresizingMaskIntoConstraints = false
            cvShadow.backgroundColor = UIColor.white
            cvShadow.layer.shadowColor = UIColor.black.cgColor
            cvShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cvShadow.layer.shadowRadius = 10.0
            cvShadow.layer.shadowOpacity = 0.2
        view.insertSubview(cvShadow , belowSubview: settingsCV)
        cvShadow.constrainWithMultiplier(view: settingsCV , width: 1.2, height: 1.0)
    }
   
    func show_menu(_ sender: UIButton){
        let settingsVC = MenuVC()
            settingsVC.fromPage = 5
        present(settingsVC , animated: true , completion: nil)
    }
    func setSettings(){
        guard let user = ThurstUser().currentUser() else  { return }
            self.user = user
        
    }
    
}
extension SettingsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.settingsCV.frame.width*1.2, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let size = collectionView.contentOffset.y > -10 ? CGSize(width: self.view.frame.width*0.5, height: 120) : CGSize.zero
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionElementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: "SettingsHeader", for: indexPath)
            return header
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: "SettingsFooter", for: indexPath) as! SettingsFooter
                footer.notificationView.setWidthTo(constant: settingsCV.frame.width*1.2)
                let emailOn = user?.isTurnOnEmailNotification ?? false
                let pushOn = user?.isTurnOnPushNotification ?? false
                footer.setNotfications(emailOn: emailOn, notificationsOn: pushOn)
            return footer
        default:
            break
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item{
        case 0:
            present(EditAccountVC(), animated: true , completion: nil)
        case 2:
            present(BlockVC(), animated: true , completion: nil)
        case 4:
            thurstOptionsAlert(title: "Delete Account ", message: "Are you sure you want to delete your account?", screenColor: UIColor.black , screenAlpha: 0.8, delegate: self )
        default: break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.6, height: self.view.frame.height*0.125)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func settingsCell(at path: IndexPath)->SettingsCell{
        if let cell = settingsCV.dequeueReusableCell(withReuseIdentifier: "SettingsCell", for: path ) as? SettingsCell{
            let actions = [0:"EDIT PROFILE",2:"BLOCKED ACCOUNTS",4:"DELETE ACCOUNT"]
            cell.action = actions[path.item]
            return cell
        }
        return SettingsCell()
    }
    
    func settingSwitchCell(at path: IndexPath)->SettingsSwitchCell{
        if let cell = settingsCV.dequeueReusableCell(withReuseIdentifier: "SettingsSwitchCell", for: path ) as? SettingsSwitchCell{
            let actions = [1:"HIDE PROFILE",3:"LOCATION"]
            let action = actions[path.item]
            cell.action = action!
            cell.onColor = createColor(76, green: 175, blue: 80)
            switch action!{
            case "HIDE PROFILE":
                cell.actionSwitch.isOn = user?.isHiddenProfile ?? false
            case "LOCATION":
                cell.actionSwitch.isOn = user?.isTurnOnLocation ?? false
            default:
                break
            }
            return cell
        }
        return SettingsSwitchCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.item{
        case 1,3:
            return settingSwitchCell(at: indexPath)
        case 0,2,4:
            return settingsCell(at: indexPath)
        default: break
        }
        return UICollectionViewCell()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height:CGFloat = 50 //half of height of section header
        let offset = scrollView.contentOffset.y
        print(offset)
        let shouldLiftHeading =  offset > height
        if shouldLiftHeading && headingTopCon.constant == 0{
            UIView.animate(withDuration: 0.25, animations: {
                self.headingTopCon.constant = -50
                self.headingLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }
        let shouldLowerHeading = offset < height
        if shouldLowerHeading && headingTopCon.constant < 0{
            UIView.animate(withDuration: 0.25, animations: {
                self.headingTopCon.constant = 0
                self.headingLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
   
}
class SettingsHeader: UICollectionReusableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        backgroundColor = UIColor.white
        add(views: settingsLabel,accountLabel)
        
        settingsLabel.constrainInView(view: self , top: 8, left: -20, right: 20, bottom: nil)
        accountLabel.constrainInView(view: self , top: nil, left: 0, right: nil, bottom: nil)
        accountLabel.setTopTo(con: self.bottom(), by: -8)
       
    }
    let settingsLabel: UILabel = {
        
        let atts = [NSFontAttributeName: appFont(size: 40),
                    NSForegroundColorAttributeName: UIColor.black]
        let attTxt = NSAttributedString(string: "S E T T I N G S", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let accountLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName:UIColor.lightGray]
        let attTxt = NSAttributedString(string: "ACCOUNT", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    
}
@objcMembers class SettingsFooter: UICollectionReusableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        clipsToBounds = false
        backgroundColor = UIColor.white
        add(views: notificationLabel,notificationView)
        
        notificationLabel.constrainInView(view: self , top: 8, left: 0, right: 0, bottom: nil)

        notificationView.setTopTo(con: notificationLabel.bottom(), by: 10)
        notificationView.setXTo(con: self.x(), by: 0)
        notificationView.setBottomTo(con: self.bottom(), by: 0)
        notificationView.add(views: emailNotiLabel,emailSwitch,pushNotiLabel,pushSwitch)
        
        emailNotiLabel.constrainInView(view: notificationView, top: 30, left: 20, right: nil, bottom: nil)
        
        emailSwitch.frame = CGRect(x: self.frame.width - 30, y: 30, width: 30, height: 15)
        emailSwitch.addShadow(0, dy: 10, color: UIColor.black , radius: 10.0, opacity: 0.6)
        
        pushNotiLabel.setTopTo(con: emailNotiLabel.bottom(), by: 30)
        pushNotiLabel.setLeftTo(con: emailNotiLabel.left(), by: 0)
        
        pushSwitch.frame = CGRect(x: self.frame.width - 30, y: emailSwitch.frame.maxY + 30, width: 30, height: 15)
        pushSwitch.addShadow(0, dy: 10, color: UIColor.black, radius: 10.0, opacity: 0.6)
    
        self.addObserver(self , forKeyPath: #keyPath(SettingsFooter.emailSwitch.isOn ), options: .new, context: &emailContext)
        self.addObserver(self , forKeyPath: #keyPath(SettingsFooter.pushSwitch.isOn ), options: .new, context: &pushContext)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &emailContext{
            print("email changed")
            if let emailChange =  change?[.newKey] as? Bool {
                if let user = ThurstUser().currentUser(){
                    user.isTurnOnEmailNotification = emailChange
                    user.updateCurrentUser(server: true)
                }
                }
            }else if context == &pushContext{
            if let pushChange =  change?[.newKey] as? Bool {
                if let user = ThurstUser().currentUser(){
                    user.isTurnOnPushNotification = pushChange
                    user.updateCurrentUser(server: true)
                }
            }
            
        }
    }
    var emailContext = 0
    var pushContext = 1
    let notificationLabel: UILabel = {
        let atts = [NSFontAttributeName:chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "NOTIFICATIONS", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let notificationView: UIView = {
        let v = UIView()
        v.backgroundColor = createColor(153, green: 153, blue: 153)
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let emailNotiLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "Email Notifications", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let pushNotiLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "Push Notifications", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let emailSwitch: CustomSwitch = {
        let swtch = CustomSwitch()
            swtch.onTintColor = UIColor.black
            swtch.offTintColor = createColor(137, green: 137, blue: 137)
            swtch.thumbTintColor = UIColor.white
            swtch.layer.shadowColor = UIColor.black.cgColor
            swtch.layer.shadowOffset = CGSize(width: 0, height: 20)
        return swtch
    }()
    
    let pushSwitch: CustomSwitch = {
        let swtch = CustomSwitch()
        swtch.onTintColor = UIColor.black
        swtch.offTintColor = createColor(137, green: 137, blue: 137)
        swtch.thumbTintColor = UIColor.white
        swtch.layer.shadowColor = UIColor.black.cgColor
        swtch.layer.shadowOffset = CGSize(width: 0, height: 20)
        return swtch
    }()
    func setNotfications(emailOn:Bool,notificationsOn: Bool){
        emailSwitch.isOn = emailOn
        pushSwitch.isOn = notificationsOn
    }
}
extension SettingsVC: ThurstOptionsDelegate{
    func okResponse() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        guard let uid = Auth.auth().currentUser?.uid  else { return}
//        let userRef = Database.database().reference().child("Users").child(uid)
//            userRef.removeValue()
        let userConvoRefs = Database.database().reference().child("User_Convo_Refs").child(uid)
            userConvoRefs.removeValue()
        let connectionRefs = Database.database().reference().child("Connections").child(uid)
            connectionRefs.removeValue()
        let userChatStorageRef = Storage.storage().reference().child("Images").child("Chat_Images").child(uid)
        userChatStorageRef.delete { (error ) in
            if error == nil{
                print("deleted chat images")
            }
        }
        let userImageStorageRef = Storage.storage().reference().child("Images").child("Profile_Images").child(uid)
        userImageStorageRef.delete { (error) in
            if error == nil{
                print("deleted profile images")
            }
        }
        Auth.auth().currentUser?.delete(completion: { (error ) in
            if error == nil{
                let window = UIApplication.shared.keyWindow
                    window?.rootViewController = SignInVC()
                    window?.makeKeyAndVisible()
            }
        })
    }
    func cancelResponse() {
        
    }
}

