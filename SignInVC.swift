//
//  SignInVC.swift
//  Thurst
//
//  Created by Rogers, Blake A. on 9/11/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignInVC: KeyBoardManagerVC{
    var shouldUpdate : Bool = false
    var userName: String{
        get{
            return nameField.text ?? ""
            
        }
    }
    var password: String{
        get{
            return passwordField.text ?? ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        if let err = error{
            thurstAlert(title: "Oops", message: err, screenColor: UIColor.black , screenAlpha: 0.6)
        }
        if shouldUpdate{
            thurstOptionsAlert(title: "Let's Upgrade You", message: "We just pimped a new version of Thurst. Go Upgrade!", screenColor: UIColor.black, screenAlpha: 0.6, delegate: self)
        }
    }
    func setViews(){
        
       //modify background
        view.backgroundColor = blue_Purp
        let blue_frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.95, height: self.view.frame.height*0.33)
        let colors = [green_Yellow.cgColor,blue_Purp.withAlphaComponent(0.8).cgColor]
        let grad_View = UIView()
            grad_View.frame = blue_frame
        let mask_path = UIBezierPath()
        let top_left = CGPoint.zero
        let bottom_left = CGPoint(x: 0, y: grad_View.frame.maxY)
        let bottom_right = CGPoint(x: grad_View.frame.width*0.3 , y: bottom_left.y)
        let top_right = CGPoint(x: grad_View.frame.width, y: 0)
            mask_path.move(to: top_left)
            mask_path.addLine(to: bottom_left)
            mask_path.addLine(to: bottom_right)
            mask_path.addLine(to: top_right)
            mask_path.addLine(to: top_left)
            mask_path.addClip()
        let mask = CAShapeLayer()
            mask.path = mask_path.cgPath
        grad_View.addGradientScreen(frame: blue_frame, start: CGPoint.init(x: 0.0, y: 0.0), end: CGPoint.init(x: 1.0, y: 1.0), locations: [0.0,1.0], colors: colors)
        grad_View.layer.mask = mask
        
        let bottom_half = UIView()
            bottom_half.backgroundColor = salmon_Pink
            bottom_half.frame = CGRect(x: 0, y: self.view.frame.height*0.33, width: self.view.frame.width , height: self.view.frame.height*0.67)
        
        view.add(views: grad_View,bottom_half,thurst_logo_Image)
        view.add(views: thurstLabel,containerView,accountButton)
        
        thurst_logo_Image.setRightTo(con: self.view.right(), by: -20)
        thurst_logo_Image.setBottomTo(con: thurstLabel.top(), by: 0)
        thurst_logo_Image.setWidth_Height(width: 150, height: 150)
        
        thurstLabel.constrainInView(view: self.view , top: nil, left: 0, right: 0, bottom: nil)
        thurstLabel.setYTo(con: self.view.top(), by: self.view.frame.height*0.33)
        
        containerView.setTopTo(con: thurstLabel.bottom(), by: 20)
        containerView.constrainInView(view: self.view , top: nil, left: 20, right: -20, bottom: nil)
        
        containerView.setHeightTo(constant: 200)
        containerView.add(views: nameField,passwordField,nameLabel,passwordLabel, signInButton)
        
        nameField.constrainInView(view: containerView , top: 20, left: 0, right: 0, bottom: nil)
        nameLabel.constrainInView(view: containerView, top: 10, left: 0, right: nil, bottom: nil)
        
        passwordLabel.setTopTo(con: nameLabel.bottom(), by: 50)
        passwordLabel.setLeftTo(con: containerView.left(), by: 10)
        
        passwordField.setTopTo(con: nameField.bottom(), by: 60)
        passwordField.setLeftTo(con: passwordLabel.left(), by: 0)
        passwordField.setRightTo(con: containerView.right(), by: 0)
        
        //set up name and password gesture
        nameGesture = UITapGestureRecognizer(target: self , action: #selector(SignInVC.name_anim(_:)))
        passwdGesture = UITapGestureRecognizer(target: self , action: #selector(SignInVC.passwd_anim(_:)))
        nameLabel.addGestureRecognizer(nameGesture!)
        passwordLabel.addGestureRecognizer(passwdGesture!)
        
        signInButton.setXTo(con: containerView.right(), by: -10)
        signInButton.setYTo(con: containerView.bottom(), by: -10)
        signInButton.addTarget(self , action: #selector(SignInVC.signIn(_:)), for: .touchUpInside)
        
        accountButton.constrainInView(view: self.view , top: nil, left: 0, right: nil, bottom: -20)
        accountButton.addTarget(self , action: #selector(SignInVC.newUser(_:)), for: .touchUpInside)
    
        setTxtFields([nameField,passwordField])
    }
    var error:  String?
    let thurstLabel: UILabel = {
        let lab = UILabel()
            lab.textAlignment = .center
        let shadow = NSShadow()
            shadow.shadowColor = UIColor.black.withAlphaComponent(0.6)
            shadow.shadowOffset = CGSize(width: 0, height: 10)
            shadow.shadowBlurRadius = 10.0
    
        let atts = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:chivo_AppFont(size: 50.0, light: true),NSShadowAttributeName:shadow]
       
        let attText = NSMutableAttributedString(string: "T H U R S T", attributes: atts)
        lab.attributedText = attText
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let thurst_logo_Image: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "thurstLogo")
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let containerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        v.layer.shadowOffset = CGSize(width: 5, height: 10)
        v.layer.shadowRadius = 10.0
        v.layer.shadowOpacity = 0.5
        v.tag = 100
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let nameLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 15, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "USERNAME", attributes: atts)
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.adjustsFontSizeToFitWidth = true
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let nameField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.black
        f.font = chivo_AppFont(size: 15.0, light: true)
        f.textAlignment = .left
        f.translatesAutoresizingMaskIntoConstraints = false
        f.alpha = 0.0
//        let lineView = UIView()
//            lineView.alpha = 0.0
//            lineView.backgroundColor = UIColor.black
//            lineView.translatesAutoresizingMaskIntoConstraints = false
//        f.addSubview(lineView)
//            lineView.constrainInView(view: f , top: nil, left: 0, right: 0, bottom: 8)
//            lineView.setHeightTo(constant: 1)
        return f
    }()
    
    let passwordField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.black
        f.font = chivo_AppFont(size: 15, light: true)
        f.textAlignment = .left
        f.isSecureTextEntry = true
        f.translatesAutoresizingMaskIntoConstraints = false
        f.alpha = 0.0
//        let lineView = UIView()
//            lineView.alpha = 0.0
//            lineView.backgroundColor = UIColor.black
//            lineView.translatesAutoresizingMaskIntoConstraints = false
//        f.addSubview(lineView)
//            lineView.constrainInView(view: f , top: nil, left: 0, right: 0, bottom: 8)
//            lineView.setHeightTo(constant: 1)
        return f
    }()
    let passwordLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 15, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "PASSWORD", attributes: atts)
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.adjustsFontSizeToFitWidth = true
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let signInButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "SignInButton"), for: .normal)
        btn.layer.shadowColor = UIColor.black.withAlphaComponent(0.6).cgColor
        btn.layer.shadowOffset = CGSize(width: 5, height: 10)
        btn.layer.shadowRadius = 10.0
        btn.layer.shadowOpacity = 0.5
        btn.adjustsImageWhenHighlighted = false
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let accountButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "NEW ACCOUNT", attributes: [NSFontAttributeName: chivo_AppFont(size: 12, light: true),NSForegroundColorAttributeName: UIColor.lightText])
        button.setAttributedTitle(title, for: .normal)
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var nameGesture: UITapGestureRecognizer?
    var passwdGesture: UITapGestureRecognizer?
    var passwd_active: Bool = false{
        willSet{
            if newValue{
           
                nameField.resignFirstResponder()
                passwordField.becomeFirstResponder()
            }else{
                passwordField.resignFirstResponder()
               
            }
        }
    }
    var name_active: Bool = false{
        willSet{
            if newValue{
                passwordField.resignFirstResponder()
                nameField.becomeFirstResponder()
                
            }else{
                nameField.resignFirstResponder()
               
            }
        }
    }
  
    func name_anim(_ gesture: UITapGestureRecognizer){
        name_active = !name_active
        setnameField(active: name_active)
        
    }
    func setnameField( active: Bool){
        print(nameLabel.frame)
        let x:CGFloat = active ? 0.6 : 1.0
        let y:CGFloat = active ? 0.6 : 1.0
        
        let dx:CGFloat = active ? -10 : 10
        let dy:CGFloat = active ? -10 : 10
        
        let alpha:CGFloat = active ? 1.0 : 0.0
        
        let transform = CGAffineTransform(scaleX: x, y: y)
        UIView.animate(withDuration: 0.5, animations: {
            self.nameLabel.frame = self.nameLabel.frame.offsetBy(dx: dx, dy: dy)
            self.nameLabel.transform = transform
            self.nameField.alpha = alpha
        })
        print(nameLabel.frame)
    }
    func passwd_anim(_ gesture: UITapGestureRecognizer){
        passwd_active = !passwd_active
        setPasswdField(active: passwd_active)
     
    }
    func setPasswdField( active: Bool){
        let x:CGFloat = active ? 0.6 : 1.0
        let y:CGFloat = active ? 0.6 : 1.0
        let dx:CGFloat = active ? -10 : 10
        let dy:CGFloat = active ? -10 : 10
        let alpha:CGFloat = active ? 1.0 : 0.0
        
        let transform = CGAffineTransform(scaleX: x, y: y)
        UIView.animate(withDuration: 0.5, animations: {
            self.passwordLabel.frame.origin.x += dx
            self.passwordLabel.frame.origin.y += dy
            self.passwordLabel.transform = transform
            self.passwordField.alpha = alpha
            
        })
    }
    func signIn(_ sender: UIButton){
         if !userName.isEmpty && !password.isEmpty{
            attemptSignIn()
         }else{
            thurstAlert(title: "Doh!", message: "Looks like you forgot something there", screenColor: UIColor.black , screenAlpha: 0.8)
        }
    }
    
    func newUser(_ sender: UIButton){
        present(TermConPolicyVC(), animated: true , completion: nil)
    }
    func attemptSignIn(){
            Auth.auth().signIn(withEmail: userName , password: password , completion: { (user , error ) in
                if error == nil{
                   AppDatabase().fetchAndSetCurrentUser(user!.uid)
                    print("sign in successful")
                    DispatchQueue.main.async(execute: {
                        self.present(ExplorePageVC(), animated: true , completion: nil)
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.thurstAlert(title: "Doh!", message: "Sorry, Error Signing In ", screenColor: UIColor.black , screenAlpha: 0.8)
                        self.passwordField.text = ""
                        self.nameField.text = ""
                    })
                }
            })
    }
    

}
extension SignInVC: ThurstOptionsDelegate{
    
    func okResponse(){

        if let url = URL(string: "https://itunes.apple.com/us/app/thurst-dating-app/id1281569248?mt=8"){
            UIApplication.shared.open(url)
        }
    }
    func cancelResponse(){
        
    }
}
