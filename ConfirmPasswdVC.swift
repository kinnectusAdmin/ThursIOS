//
//  ConfirmPasswdVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/19/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class ConfirmPasswdVC: UIViewController {
    
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
        view.add(views: passwdLabel,passwdField,saveButton)
        
        passwdLabel.constrainInView(view: self.view , top: 0, left: 0, right: 0, bottom: nil)
        
        passwdField.setTopTo(con: passwdLabel.bottom(), by: 20)
        passwdField.setLeftTo(con: passwdLabel.left(), by: 0)
        passwdField.setWidth_Height(width: self.view.frame.width * 0.9, height: 75)
        
        saveButton.setTopTo(con: passwdField.bottom(), by: 20)
        saveButton.setXTo(con: self.view.x(), by: 0)
    }
    
    
    
    let passwdLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "Confirm Your Password: ", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let passwdField: UITextField = {
        let f = UITextField()
        f.textColor = UIColor.white
        f.font = chivo_AppFont(size: 24, light: true)
        f.textAlignment = .center
        f.borderStyle = .line
        f.translatesAutoresizingMaskIntoConstraints = false
        return f
    }()
    
    let saveButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "SaveButton"), for: .normal)
        //btn.layer.cornerRadius = 0.0
        //btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


