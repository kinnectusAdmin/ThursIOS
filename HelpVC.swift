//
//  HelpVC.swift
//  Thurst
//
//  Created by Blake Rogers on 3/16/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit

class HelpVC: KeyBoardManagerVC{
    // MARK: - Data
    var helpMessage:String{
        return helpTextView.text
    }
    // MARK: - UIElements
    let bannerView: UIView = {
        let v = UIView()
        v.backgroundColor = light_pink
        v.layer.cornerRadius = 0.0
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 4.0
        v.layer.shadowOpacity = 0.1
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
    let headingLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.text = "H E L P"
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.font = chivo_AppFont(size: 18, light: true)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let helpTextView: UITextView = {
        let v = UITextView()
        v.textColor = UIColor.black
        v.textAlignment = .left
        v.layer.borderWidth = 1.0
        v.layer.borderColor = UIColor.black.cgColor
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let helpButton : UIButton = {
        let button = UIButton()
        let font = chivo_AppFont(size: 20, light: false)
        let title = NSAttributedString(string: "GET SOME HELP", attributes: [NSFontAttributeName:font,NSForegroundColorAttributeName: UIColor.gray])
        //button.setImage( , for:.normal)
        button.setAttributedTitle(title, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = UIColor.lightGray
        button.layer.borderColor = UIColor.darkGray.cgColor
        button.layer.borderWidth = 1.0
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // MARK: - Functions
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
        view.backgroundColor = UIColor.white
        view.add(views: bannerView,helpTextView,helpButton)
        
        bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
        bannerView.setHeightTo(constant: 85)
        bannerView.add(views: navButton,thurstLabel,headingLabel)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(HelpVC.show_menu(_:)), for: .touchUpInside)
        
        headingLabel.setTopTo(con: bannerView.bottom(), by: 10)
        headingLabel.setXTo(con: bannerView.x(), by: 0)
        
        helpTextView.setXTo(con: self.view.x(), by: 0)
        helpTextView.setTopTo(con: headingLabel.bottom(), by: 20)
        helpTextView.setWidth_Height(width: self.view.frame.width*0.8, height: self.view.frame.height*0.4)
        
        helpButton.setTopTo(con: helpTextView.bottom(), by: 10)
        helpButton.constrainInView(view: self.view, top: nil, left: 20, right: -20, bottom: nil)
        helpButton.setHeightTo(constant: 75)
        helpButton.addTarget(self , action: #selector(HelpVC.select_help(_:)), for: .touchUpInside)
        
        setTxtViews([helpTextView])
    }
    
    func show_menu(_ sender: UIButton){
        let menuVC = MenuVC()
        menuVC.fromPage = 4
        present(menuVC , animated: true , completion: nil)
    }
    func select_help(_ sender: UIButton){
        if !helpMessage.isEmpty{
            helpTextView.resignFirstResponder()
            helpTextView.text = ""
            thurstAlert(title: "Thank You for Reaching Out", message: "We will work diligently to resolve the above issue", screenColor: UIColor.black , screenAlpha: 0.6)
        }else{
            thurstAlert(title: "Oops", message: "Please express the issue at hand completely.", screenColor: UIColor.black , screenAlpha: 0.6)
        }
    }
}
