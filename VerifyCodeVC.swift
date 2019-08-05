//
//  VerifyCodeVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/19/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class VerifyCodeVC: UIViewController {
    
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
        view.backgroundColor = UIColor.clear
        view.add(views: phoneNumLabel,codeField,verifyButton)
        
        phoneNumLabel.constrainInView(view: self.view , top: 0, left: 0, right: 0, bottom: nil)
        
        codeField.setTopTo(con: phoneNumLabel.bottom(), by: 20)
        codeField.setLeftTo(con: phoneNumLabel.left(), by: 0)
        codeField.setWidth_Height(width: self.view.frame.width * 0.9, height: 75)
        codeField.delegate = self
        
        verifyButton.setTopTo(con: codeField.bottom(), by: 20)
        verifyButton.setXTo(con: self.view.x(), by: 0)
        verifyButton.setWidth_Height(width: 250, height: 50)
        verifyButton.addTarget(self , action: #selector(VerifyCodeVC.select_verify(_:)), for: .touchUpInside)
        
    }
    
    enum VerifyPurpose: String{
        case UserCreation, PhoneNumberUpdate
    }
    var purpose: VerifyPurpose?
    let phoneNumLabel: UILabel = {
      
        let lab = UILabel()
        lab.textAlignment = .center
        lab.text = "Enter Your \n Verification Code: "
        lab.font = chivo_AppFont(size: 24, light: true)
        lab.numberOfLines = 2
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let codeField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.white
        f.font = chivo_AppFont(size: 24, light: true)
        f.textAlignment = .center
        f.borderStyle = .line
        f.keyboardType = .numberPad
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    let verifyButton: UIButton = {
        let btn = UIButton()
        let lightBlue = createColor(153, green: 255, blue: 255).cgColor
        let white = UIColor.white.cgColor
        let colors = [lightBlue,white]
        let frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        btn.addGradientScreen(frame: frame, start: CGPoint(x:0,y:0), end: CGPoint(x:0.5,y:1.0), locations: [0.0,1.0], colors: colors)
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.black]
        let attTxt = NSAttributedString(string: "Save", attributes: atts)
        btn.setAttributedTitle(attTxt, for: .normal)
        //btn.layer.cornerRadius = 0.0
        //btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
        
    }()
    
    func select_verify(_ sender: UIButton){
        switch purpose!{
        case .UserCreation:
            verifyCode()
        case .PhoneNumberUpdate:
            verifyNewPhone()
        }
    }
        func verifyNewPhone(){
            if codeField.isFirstResponder{
                codeField.resignFirstResponder()
            }
            guard let verificationID = UserDefaults.standard.value(forKey: "verificationID") as? String else { return }
             guard let verificationCode = codeField.text else { return }
            let cred = PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: verificationCode)
           
            Auth.auth().currentUser?.updatePhoneNumber(cred, completion: { (error) in
                if error == nil{
                    if let pageVC = self.parent as? UIPageViewController{
                        pageVC.setViewControllers([VerifyCompleteVC()], direction: .forward, animated: true , completion: nil)
                    }
                }
            })
    }
    func verifyCode(){
        if codeField.isFirstResponder{
            codeField.resignFirstResponder()
        }
        guard let verificationCode = codeField.text else { return }
        guard let verificationID = UserDefaults.standard.value(forKey: "verificationID") as? String else { return }
        guard let tempSignUpEmail = UserDefaults.standard.value(forKey: "tempSignupEmail") as? String else { return }
        guard let passwd = UserDefaults.standard.value(forKey: "tempSignupPassword") as? String else{ return }
        guard let tempUserName = UserDefaults.standard.value(forKey: "tempUserName") as? String else { return }
       
        let cred = PhoneAuthProvider.provider().credential(withVerificationID: verificationID , verificationCode: verificationCode)
        
        Auth.auth().createUser(withEmail: tempSignUpEmail, password: passwd) { (user, error) in
            if error == nil{
                
                user?.link(with: cred, completion: { (user , cred_error ) in
                    
                    if cred_error == nil{
                        print("got a new User whoo hoo!")
                        let database = AppDatabase()
                            database.signUpDelegate = self
                        database.createUser(user!,name:tempUserName)
                    }else{
                        Auth.auth().currentUser?.delete(completion: { (error) in
                            print("error signing in")
                            let window = UIApplication.shared.keyWindow
                            let vc = SignInVC()
                            vc.error = cred_error?.localizedDescription
                            window?.rootViewController = vc
                        })
                    }
                })
               
            }else{
                
                print("error signing in")
                let window = UIApplication.shared.keyWindow
                let vc = SignInVC()
                    vc.error = "Error Signing In"
                window?.rootViewController = vc
            }
        }
    }
    
}

extension VerifyCodeVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "/n"{
            textField.resignFirstResponder()
            return false
        }else{
            
        }
        return true
    }
}

extension VerifyCodeVC: DatabaseSignUpDelegate{
    func unauthorizedSignUp(){
    }
    func userSignUpSucceeded(_ succeeded: Bool){
        if succeeded{
            if let pageVC = self.parent as? UIPageViewController{
                pageVC.setViewControllers([VerifyCompleteVC()], direction: .forward, animated: true , completion: nil)
            }
        }else{
            let window = UIApplication.shared.keyWindow
            let vc = SignInVC()
            vc.error = "Error Signing In"
            window?.rootViewController = vc
        }
    }
    func fbUserSignUpSucceeded(){}
    func userSignInSucceeded(){}
    func fbUserSignInSucceeded(){}
}
