//
//  MenuVC.swift
//  Thurst
//
//  Created by Blake Rogers on 10/13/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class MenuVC: UIViewController {

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
        self.view.backgroundColor = light_orange
        setOptions(current: fromPage)
        self.view.add(views: thurstLabel,logoutView)
        
        thurstLabel.constrainInView(view: self.view , top: 30, left: 0, right: nil, bottom: nil)
        
        logoutView.constrainInView(view: self.view , top: nil, left: -20, right: 20, bottom: 0)
        logoutView.setHeightTo(constant: 50)
        
        logoutView.addSubview(logoutButton)
        logoutButton.constrainInView(view: logoutView , top: 10, left: 10, right: nil, bottom: nil)
        logoutButton.addTarget(self, action: #selector(MenuVC.select_logout(_:)), for: .touchUpInside)
        
    }
    
    var fromPage: Int = 0
    let thurstLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 10, light: true),
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
    
    func setOptions(current: Int){
        let options = ["PROFILE","MESSAGES","CONNECTIONS","EXPLORE","HELP","SETTINGS"]
        
        for i in 0...5{
            let btn = UIButton()
            let color: UIColor = current == i ? UIColor.white : createColor(230, green: 230, blue: 230)
            let atts = [NSFontAttributeName: chivo_AppFont(size: 24, light: true),
                        NSForegroundColorAttributeName: color]
            let attTitle = NSAttributedString(string: options[i], attributes: atts)
            btn.setAttributedTitle(attTitle, for: .normal)
            btn.tag = i
            btn.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(btn)
            btn.setXTo(con: view.x(), by: 0)
            btn.setTopTo(con: view.top(), by: CGFloat(70 + 55*i))
            btn.addTarget(self , action: #selector(MenuVC.select_menuOption(_:)), for: .touchUpInside)
        }
    }
    
    let logoutView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let logoutButton: UIButton = {
        let btn = UIButton()
        let atts = [NSFontAttributeName: chivo_AppFont(size: 10, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTitle = NSAttributedString(string: "LOG OUT", attributes: atts)
        btn.setAttributedTitle(attTitle, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    func select_logout( _ sender: UIButton){
        do{
            try? Auth.auth().signOut()
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = SignInVC()
                window.makeKeyAndVisible()
                UserDefaults.standard.removeObject(forKey: "currentUser")
            }
        }
    }
    
    func select_menuOption(_ sender: UIButton){
        switch sender.tag{
        case 0:
            guard let user = ThurstUser().currentUser() else { return }
            //go to profile
            let vc = UserProfileVC()
                vc.user = user
            present(vc, animated: true , completion: nil)
            break
        case 1:
            //go to messages
           present(MessagesVC(), animated: true , completion: nil)
            break
        case 2:
            //go to connections
            present(ConnectionsVC(), animated: true, completion: nil)
            break
        case 3:
            //go to explore
            present(ExplorePageVC(), animated: true , completion: nil)
        case 4:
            //go to help
              present(HelpVC(), animated: true , completion: nil)
            break
        case 5:
            //go to settings
            present(SettingsVC(), animated: true , completion: nil)
        default: break
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
