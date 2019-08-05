//
//  EditAccountVC.swift
//  Thurst
//
//  Created by Blake Rogers on 2/11/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class EditAccountVC: KeyBoardManagerVC{
        // MARK: - UIElements
        
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
        var user:ThurstUser?{
            return ThurstUser().currentUser()
        }
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
            lab.text = "E D I T  A C C O U N T"
            lab.alpha = 0.0
            lab.backgroundColor = UIColor.clear
            lab.layer.cornerRadius = 0.0
            lab.font = chivo_AppFont(size: 18, light: true)
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
        
        let accountCV: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 300, height: 60)
            let frame = CGRect(x: 0, y: 0, width: 300, height: 60)
            let cv = UICollectionView(frame: frame , collectionViewLayout: layout)
            cv.backgroundColor = UIColor.white
            cv.showsVerticalScrollIndicator = false
            cv.translatesAutoresizingMaskIntoConstraints = false
            cv.clipsToBounds = false
            cv.tag = 100
            return cv
        }()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            accountCV.register(AccountCell.self , forCellWithReuseIdentifier: "AccountCell")
            
            accountCV.register(AccountSettingsHeader.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "AccountSettingsHeader")
            accountCV.delegate = self
            accountCV.dataSource = self
            setViews()
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        func setViews(){
            view.backgroundColor = UIColor.white
            view.add(views: accountCV,bannerView)
            
            bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
            bannerView.setHeightTo(constant: 85)
            bannerView.add(views: navButton,thurstLabel,headingLabel)
            
            thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
            navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
            navButton.addTarget(self , action: #selector(SettingsVC.show_menu(_:)), for: .touchUpInside)
            
            headingTopCon = headingLabel.setTopTo_Return(con: bannerView.bottom(), by: 0)
            headingLabel.setXTo(con: bannerView.x(), by: 0)
            
            accountCV.constrainInView(view: self.view , top: 65, left: nil, right: nil, bottom: 0)
            accountCV.setXTo(con: self.view.x(), by: 0)
            accountCV.setWidthTo(constant: self.view.frame.width*0.65)
            
            let cvShadow = UIView()
            cvShadow.translatesAutoresizingMaskIntoConstraints = false
            cvShadow.backgroundColor = UIColor.white
            cvShadow.layer.shadowColor = UIColor.black.cgColor
            cvShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
            cvShadow.layer.shadowRadius = 10.0
            cvShadow.layer.shadowOpacity = 0.2
            view.insertSubview(cvShadow , belowSubview: accountCV)
            cvShadow.constrainWithMultiplier(view: accountCV , width: 1.2, height: 1.0)
        }
        
        func show_menu(_ sender: UIButton){
            let settingsVC = MenuVC()
            settingsVC.fromPage = 5
            present(settingsVC , animated: true , completion: nil)
        }
        
    }
    extension EditAccountVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
        
     
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            let size = collectionView.contentOffset.y > -10 ? CGSize(width: self.view.frame.width*0.5, height: 120) : CGSize.zero
            return size
        }
        
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind , withReuseIdentifier: "AccountSettingsHeader", for: indexPath)
                return header
        
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch indexPath.item{
            case 2:
                break
            case 4:
                break
            default: break
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 3
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
        
        func accountCell(at path: IndexPath)->AccountCell{
            if let cell = accountCV.dequeueReusableCell(withReuseIdentifier: "AccountCell", for: path ) as? AccountCell{
                let actions = [0:"EMAIL",1:"PHONE NUMBER",2:"PASSWORD"]
                let action = actions[path.item]
                cell.delegate = self
                cell.action = actions[path.item]
                self.setTxtFields([cell.infoField])
                switch action!{
                case "EMAIL":
                    cell.accountDetail = user?.email
                case "PHONE NUMBER":
                    if let number = user?.phoneNumber{
                        var num = String(number.dropFirst(2))
                            num.insert("-", at: String.Index.init(3))
                            num.insert("-", at: String.Index.init(7))
                        cell.accountDetail = num
                    }
                case "PASSWORD":
                    cell.accountDetail = "*******"
                default: break
                }
                return cell
            }
            return AccountCell()
        }
        
  
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                return accountCell(at: indexPath)
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
    class AccountSettingsHeader: UICollectionReusableView{
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
            let attTxt = NSAttributedString(string: "EDIT ACCOUNT", attributes: atts)
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

    extension EditAccountVC: ThurstOptionsDelegate{
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
extension EditAccountVC: AccountDelegate{
    func setEmail(email:String){
        guard let user = ThurstUser().currentUser() else { return }
            user.email = email
            user.updateCurrentUser(server: true)
        
        Auth.auth().currentUser?.updateEmail(to: email, completion: { (error ) in
            if error == nil{
                
                
                self.thurstAlert(title: "All Set!", message:"Your email has been updated ", screenColor: UIColor.black , screenAlpha: 0.8)
            }
        })
    }
    func sendPhoneVerification(to phone: String){
        
       
        let phoneNumber = "+1"+phone
        if phoneNumber.characters.count != 12{
            thurstAlert(title: "Oops", message: "Thats an invalid phone number!", screenColor: UIColor.white , screenAlpha: 0.8)
        }else{
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber , uiDelegate: nil) { (string , error) in
                if error == nil{
                    print(string)
                    UserDefaults.standard.setValue(string, forKeyPath: "verificationID")
                    if let pageVC = self.parent as? UIPageViewController{
                        let vc = VerifyCodeVC()
                            vc.purpose = .PhoneNumberUpdate
                        pageVC.setViewControllers([vc], direction: .forward, animated: true , completion: nil)
                    }
                }else{
                    print(error?.localizedDescription)
                }
            }
        }
        
    }
    func setPhoneNumber(phoneNumber:String){
        sendPhoneVerification(to: phoneNumber)
        
    }
    func setPassword(password: String){
        Auth.auth().currentUser?.updatePassword(to: password , completion: { (error) in
            if error == nil{
                self.thurstAlert(title: "Youre All Set!", message: "Your password was successfully updated", screenColor: UIColor.black , screenAlpha: 0.8)
            }
        })
    }
}


