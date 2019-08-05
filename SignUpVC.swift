//
//  SignUpVC.swift
//  Thurst
//
//  Created by Rogers, Blake A. on 9/18/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class SignUpVC: KeyBoardManagerVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViews(){
        view.backgroundColor = light_pink
        view.add(views: thurstLabel,cancelButton,containerView)
        setTxtFields([nameField,emailField,passwordField])
        
        thurstLabel.constrainInView(view: self.view , top: 30, left: 0, right: nil, bottom: nil)
        
        cancelButton.constrainInView(view: self.view , top: 30, left: nil, right: -20, bottom: nil)
        cancelButton.addTarget(self , action: #selector(SignUpVC.cancel(_:)), for: .touchUpInside)
        
        containerView.constrainInView(view: self.view, top: 100, left: 30, right: -30, bottom: -100)
        containerView.add(views: thurst_logo_Image,nameField,emailField,
                          passwordField,nameLabel,emailLabel,
                          passwordLabel,signUpButtonView)
        
        thurst_logo_Image.setTopTo(con: containerView.top(), by: 50)
        thurst_logo_Image.setXTo(con: containerView.x(), by: 0)
        thurst_logo_Image.setWidth_Height(width: 75, height: 75)
        
        nameLabel.setLeftTo(con: containerView.left(), by: 10)
        nameLabel.setTopTo(con: thurst_logo_Image.bottom(), by: 30)
        
        //nameField.constrainInView(view: containerView , top: nil, left: 0, right: 0, bottom: nil)
        nameField.setLeftTo(con: nameLabel.left(), by: 10)
        nameField.setTopTo(con: nameLabel.bottom(), by: 0)
        nameField.setRightTo(con: containerView.right(), by: 0)
        
        emailField.setTopTo(con: emailLabel.bottom(), by: 10)
        emailField.setLeftTo(con: emailLabel.left(), by: 10)
        emailField.setRightTo(con: containerView.right(), by: 0)
        
        emailLabel.setLeftTo(con: containerView.left(), by: 10)
        emailLabel.setTopTo(con: nameField.bottom(), by: 30)
        
        passwordField.setTopTo(con: passwordLabel.bottom(), by: 10)
        passwordField.setLeftTo(con: passwordLabel.left(), by: 10)
        passwordField.setRightTo(con: containerView.right(), by: 0)
        
        passwordLabel.setLeftTo(con: containerView.left(), by: 10)
        passwordLabel.setTopTo(con: emailField.bottom(), by: 30)
        
        
        //set up name and password gesture
        nameGesture = UITapGestureRecognizer(target: self , action: #selector(SignUpVC.name_anim(_:)))
        passwdGesture = UITapGestureRecognizer(target: self , action: #selector(SignUpVC.passwd_anim(_:)))
        emailGesture = UITapGestureRecognizer(target: self , action: #selector(SignUpVC.email_anim(_:)))
        nameLabel.addGestureRecognizer(nameGesture!)
        passwordLabel.addGestureRecognizer(passwdGesture!)
        emailLabel.addGestureRecognizer(emailGesture!)
        
        signUpButtonView.setLeftTo(con: containerView.x(), by: -self.view.frame.width*0.25)
        signUpButtonView.setYTo(con: containerView.bottom(), by: -10)
        signUpButtonView.setRightTo(con: containerView.right(), by: 25)
        signUpButtonView.setHeightTo(constant: 75)
        
        signUpGesture = UITapGestureRecognizer(target: self , action:#selector(SignUpVC.signUp(_:)) )
        signUpButtonView.addGestureRecognizer(signUpGesture!)
    
    }
    var signUpGesture: UITapGestureRecognizer?
    var email: String {
        get{
            return emailField.text ?? ""
        }
    }
    var password: String{
        get{
            return passwordField.text ?? ""
        }
    }
    let thurstLabel: UILabel = {
        let lab = UILabel()
            lab.textAlignment = .center
            lab.text = "T H U R S T"
            lab.font = chivo_AppFont(size: 12, light: true)
            lab.textColor = UIColor.white
            lab.backgroundColor = UIColor.clear
            lab.layer.cornerRadius = 0.0
            lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let thurst_logo_Image: UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "thurstLogo")
            iv.contentMode = .scaleAspectFit
            iv.layer.cornerRadius  = 0
            iv.layer.masksToBounds = true
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
        lab.backgroundColor = UIColor.clear
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let nameField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.black
        f.font = chivo_AppFont(size: 15, light: true)
        f.textAlignment = .left
        f.translatesAutoresizingMaskIntoConstraints = false
        f.alpha = 0.0
        return f
    }()
    let emailLabel: UILabel = {
        
        let atts = [NSFontAttributeName:chivo_AppFont(size: 15, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "EMAIL", attributes: atts)
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let emailField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.black
        f.font = chivo_AppFont(size: 15, light: true)
        f.textAlignment = .left
        f.translatesAutoresizingMaskIntoConstraints = false
        f.alpha = 0.0
        
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
        return f
    }()
    let passwordLabel: UILabel = {
        
        let atts = [NSFontAttributeName:chivo_AppFont(size: 15, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "PASSWORD", attributes: atts)
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let signUpButtonView: UIView = {
        let v = SignupButtonView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    let cancelButton: UIButton = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 18, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "X", attributes: atts)
        let btn = UIButton()
            btn.setAttributedTitle(attTxt , for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var nameGesture: UITapGestureRecognizer?
    var passwdGesture: UITapGestureRecognizer?
    var emailGesture: UITapGestureRecognizer?
    var passwd_active: Bool = false{
        willSet{
            if newValue{
                nameField.resignFirstResponder()
                emailField.resignFirstResponder()
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
                emailField.resignFirstResponder()
                nameField.becomeFirstResponder()
            }else{
                nameField.resignFirstResponder()
            }
        }
    }
    var email_active:Bool = false{
        willSet{
            if newValue{
                nameField.resignFirstResponder()
                passwordField.resignFirstResponder()
                emailField.becomeFirstResponder()
            }else{
                emailField.resignFirstResponder()
            }
        }
    }
    func cancel(_ sender: UIButton){
        if let window = UIApplication.shared.keyWindow{
            window.rootViewController = SignInVC()
        }
    }
    func name_anim(_ gesture: UITapGestureRecognizer){
        name_active = !name_active
        let x:CGFloat = name_active ? 0.6 : 1.0
        let y:CGFloat = name_active ? 0.6 : 1.0
        let dx:CGFloat = name_active ? -10 : 10
        let dy:CGFloat = name_active ? -10 : 10
        let alpha:CGFloat = name_active ? 1.0 : 0.0
        let transform = CGAffineTransform(scaleX: x, y: y)
        
        UIView.animate(withDuration: 0.5, animations: {
        self.nameLabel.transform = transform
        self.nameLabel.frame.origin.x += dx
        self.nameLabel.frame.origin.y += dy
        self.nameField.alpha = alpha
        })
    }
    
    func passwd_anim(_ gesture: UITapGestureRecognizer){
        passwd_active = !passwd_active
        let x:CGFloat = passwd_active ? 0.6 : 1.0
        let y:CGFloat = passwd_active ? 0.6 : 1.0
        let dx:CGFloat = passwd_active ? -10 : 10
        let dy:CGFloat = passwd_active ? -10 : 10
        let alpha:CGFloat = passwd_active ? 1.0 : 0.0
        let transform = CGAffineTransform(scaleX: x, y: y)
        
        UIView.animate(withDuration: 0.5, animations: {
        self.passwordLabel.transform = transform
        self.passwordLabel.frame.origin.x += dx
        self.passwordLabel.frame.origin.y += dy
        self.passwordField.alpha = alpha
        })
    }
    
    func email_anim(_ gesture: UITapGestureRecognizer){
        email_active = !email_active
        let x:CGFloat = email_active ? 0.6 : 1.0
        let y:CGFloat = email_active ? 0.6 : 1.0
        let dx:CGFloat = email_active ? -10 : 10
        let dy:CGFloat = email_active ? -10 : 10
        let alpha:CGFloat = email_active ? 1.0 : 0.0
        let transform = CGAffineTransform(scaleX: x, y: y)
        
        UIView.animate(withDuration: 0.5, animations: {
        self.emailLabel.transform = transform
        self.emailLabel.frame.origin.x += dx
        self.emailLabel.frame.origin.y += dy
        self.emailField.alpha = alpha
        })
    }
    func signUp(_ gesture: UITapGestureRecognizer){
        if !password.isEmpty && !email.isEmpty{
            UserDefaults.standard.setValue(email , forKey: "tempSignupEmail")
            UserDefaults.standard.setValue(password , forKey: "tempSignupPassword")
            UserDefaults.standard.setValue(password , forKey: "tempUserName")
            let vc = VerifyPageVC()
            present(vc, animated: true , completion: nil)
        }else{
            thurstAlert(title: "Doh!", message: "You forgot to enter something!", screenColor: UIColor.black , screenAlpha: 0.6)
        }
    }
    func newUser(_ sender: UIButton){
        
    }
   
}

