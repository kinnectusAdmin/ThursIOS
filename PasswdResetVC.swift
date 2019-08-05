//
//  PasswdResetVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/19/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class PasswdResetVC: UIViewController {

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
        view.add(views: forgotLabel, forgotImage,emailNotifyLabel,switchButton)
        
        forgotLabel.constrainInView(view: self.view , top: 0, left: 0, right: 0, bottom: nil)
        
        forgotImage.setTopTo(con: forgotLabel.bottom(), by: 10)
        forgotImage.setXTo(con: self.view.x(), by: 0)
        forgotImage.setWidth_Height(width: self.view.frame.width*0.8, height: self.view.frame.height*0.5)
        
        emailNotifyLabel.setLeftTo(con: forgotImage.left(), by: 0)
        emailNotifyLabel.setTopTo(con: forgotImage.bottom(), by: 20)
       
        switchButton.setRightTo(con: self.view.right(), by: -20)
        switchButton.setYTo(con: emailNotifyLabel.y(), by: 0)
        switchButton.setWidth_Height(width: 50, height: 20)
    }
    
    var switchButton : CustomSwitch = {
        let sw = CustomSwitch(frame: CGRect(x: 0 , y: 0, width: 50, height: 20))
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
   
    let forgotLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 15, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "Forgot your password?", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let forgotImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "p_wdReset")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius  = 0
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let emailNotifyLabel: UILabel = {
        let atts = [NSFontAttributeName:chivo_AppFont(size: 15, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "Email notifications", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
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
