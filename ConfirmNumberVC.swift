//
//  ConfirmNumberVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/19/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ConfirmNumberVC: KeyBoardManagerVC {
    
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
        view.add(views: phoneNumLabel,phoneNumField,enterButton)
        phoneNumLabel.constrainInView(view: self.view , top: 0, left: 0, right: 0, bottom: nil)
        phoneNumField.setTopTo(con: phoneNumLabel.bottom(), by: 20)
        phoneNumField.setLeftTo(con: phoneNumLabel.left(), by: 0)
        phoneNumField.setWidth_Height(width: self.view.frame.width * 0.9, height: 125)
        enterButton.setTopTo(con: phoneNumField.bottom(), by: 20)
        enterButton.setXTo(con: self.view.x(), by: 0)
        enterButton.setWidth_Height(width: 250, height: 50)
        enterButton.addTarget(self , action: #selector(ConfirmNumberVC.select_enter(_:)), for: .touchUpInside)
    }
    
    let phoneNumLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.text = "Confirm your \n phone number: "
        lab.font = chivo_AppFont(size: 24, light: true)
        lab.numberOfLines = 2
        lab.textColor = UIColor.white
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let phoneNumField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.white
        f.keyboardType = .numberPad
        f.font = chivo_AppFont(size: 24, light: true)
        f.textAlignment = .center
        f.borderStyle = .line
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    let enterButton: UIButton = {
        let btn = UIButton()
        let lightBlue = createColor(153, green: 255, blue: 255).cgColor
        let white = UIColor.white.cgColor
        let colors = [lightBlue,white]
        let frame = CGRect(x: 0, y: 0, width: 250, height: 50)
        btn.addGradientScreen(frame: frame, start: CGPoint(x:0,y:0), end: CGPoint(x:0.5,y:1.0), locations: [0.0,1.0], colors: colors)
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.black] as [String : Any]
        let attTxt = NSAttributedString(string: "ENTER", attributes: atts)
        btn.setAttributedTitle(attTxt, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    func select_enter(_ sender: UIButton){
        sendPhoneVerification()
    }
    func sendPhoneVerification(){
        
        guard var phoneNumber = phoneNumField.text else { return }
                phoneNumber = "+1"+phoneNumber
        if phoneNumber.characters.count != 12{
            thurstAlert(title: "Oops", message: "Thats an invalid phone number!", screenColor: UIColor.white , screenAlpha: 0.8)
        }else{
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber , uiDelegate: self) { (string , error) in
                if error == nil{
                    print(string)
                    UserDefaults.standard.setValue(string, forKeyPath: "verificationID")
                    
                        let vc = VerifyCodeVC()
                            vc.purpose = .UserCreation
                    if let pageVC = self.parent as? UIPageViewController{
                        pageVC.setViewControllers([vc], direction: .forward, animated:true , completion: nil)
                        //pageVC.view.frame = self.view.frame
                        //self.addChildViewController(pageVC)
                        //self.view.addSubview(pageVC.view)
                    }
                }else{
                    print(error?.localizedDescription)
                }
            }
        }

    }
    
}
extension ConfirmNumberVC: AuthUIDelegate{

}


