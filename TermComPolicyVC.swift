//
//  TermConPolicyVC.swift
//  Thurst
//
//  Created by Rogers, Blake A. on 9/18/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class TermConPolicyVC: UIViewController {
    var dismissGesture: UITapGestureRecognizer?
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setDismissGesture()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissGesture = nil
    }
    func setDismissGesture(){
        dismissGesture = UITapGestureRecognizer(target: self , action: #selector(TermConPolicyVC.goHome(_:)))
        thurstLabel.addGestureRecognizer(dismissGesture!)
    }
    func setViews(){
        view.addGradientScreen(frame: view.frame , start: CGPoint(x:0,y:0), end: CGPoint(x:0.3,y:1.0), locations: [0.2,1.0], colors: [dark_Pink.cgColor,light_pink.cgColor])
        view.add(views: thurstLabel,termsLabelView,termsTxtView,nextButton)
        //organize views
        
        view.addSubview(container)
        
        container.constrainInView(view: self.view , top: nil, left: nil, right: nil, bottom: 0)
        container.setWidth_Height(width: self.view.frame.width, height: 50)
        container.addSubview(agreeButton)
        
        agreeButton.constrainInView(view: container, top: 0, left: nil, right: 0, bottom: nil)
        thurstLabel.constrainInView(view: self.view , top: 40, left: 20, right: nil, bottom: nil)
        
        termsLabelView.setTopTo(con: thurstLabel.bottom(), by: 20)
        termsLabelView.setHeightTo(constant: 130)
        termsLabelView.setXTo(con: self.view.x(), by: 0)
        termsLabelView.setWidthTo(constant: view.frame.width)
        termsTxtView.setTopTo(con: termsLabelView.bottom(), by: 4)

        termsTxtView.setXTo(con: self.view.x(), by: 0)
        termsTxtView.setWidthTo(constant: view.frame.width*0.85)
        termsTxtView.setBottomTo(con: container.top(), by: -10)
        nextButton.setBottomTo(con: container.top(), by: -4)
        nextButton.setRightTo(con: self.view.right(), by: -8)
        
        view.add(views: com_pol_Label,com_pol_TxtView)
        
        com_pol_Label.setTopTo(con: thurstLabel.bottom(), by: 20)
        com_pol_Label.setHeightTo(constant: 130)
        com_label_leftCon = com_pol_Label.setXTo_Return(con: self.view.x(), by: self.view.frame.width)
        com_pol_Label.setWidthTo(constant: view.frame.width)
        
        com_pol_TxtView.setTopTo(con: com_pol_Label.bottom(), by: 4)
        com_pol_TxtView.setXTo(con: com_pol_Label.x(), by: 0)
        com_pol_TxtView.setWidthTo(constant: view.frame.width*0.85)
        com_pol_TxtView.setBottomTo(con: container.top(), by: -10)
        
        agreeButton.addTarget(self , action: #selector(TermConPolicyVC.set_agree(_:)), for: .touchUpInside)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    let container: UIView = {
        let v = UIView()
            v.backgroundColor = UIColor.black
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let agreeButton: UIButton = {
        let btn = UIButton()
            btn.backgroundColor = UIColor.black
        let atts = [NSFontAttributeName: chivo_AppFont(size: 10, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTitle = NSAttributedString(string: "I  A G R E E", attributes: atts)
            btn.setAttributedTitle(attTitle, for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let nextButton: UIButton = {
        let btn = UIButton()
            btn.setImage( #imageLiteral(resourceName: "next_tri_button"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    let thurstLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 10, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "T H U R S T", attributes: atts)
        let lab = UILabel()
            lab.textAlignment = .center
            lab.attributedText = attTxt
            lab.backgroundColor = UIColor.clear
            lab.layer.cornerRadius = 0.0
            lab.translatesAutoresizingMaskIntoConstraints = false
            lab.isUserInteractionEnabled = true
        return lab
    }()
    let termsLabelView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        let andLabel: UILabel = {
            
            let atts = [NSFontAttributeName: appFont(size: 130),
                        NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.6)]
            let attTxt = NSAttributedString(string: "&", attributes: atts)
            let lab = UILabel()
            lab.textAlignment = .center
            lab.attributedText = attTxt
            lab.backgroundColor = UIColor.clear
            lab.layer.cornerRadius = 0.0
            lab.translatesAutoresizingMaskIntoConstraints = false
            return lab
        }()
        let termsLabel: UILabel = {
            
            let atts = [NSFontAttributeName: chivo_AppFont(size: 30, light: false),
                        NSForegroundColorAttributeName: UIColor.white]
            let attTxt = NSAttributedString(string: "T E R M S \n C O N D I T I O N S", attributes: atts)
            let lab = UILabel()
            lab.textAlignment = .center
            lab.attributedText = attTxt
            lab.backgroundColor = UIColor.clear
            lab.layer.cornerRadius = 0.0
            lab.numberOfLines = 2
            lab.translatesAutoresizingMaskIntoConstraints = false
            return lab
        }()
        v.add(views: andLabel,termsLabel)
        andLabel.constrainWithMultiplier(view: v, width: 1, height: 1)
        termsLabel.setXTo(con: v.x(), by: 0)
        termsLabel.setYTo(con: andLabel.y(), by: 0)
        return v
    }()

    let termsTxtView: UITextView = {
        let v = UITextView()
        v.backgroundColor = UIColor.clear
        v.textAlignment = .center
        v.isEditable = false
        v.allowsEditingTextAttributes = false
        v.font = chivo_AppFont(size: 12, light: true)
        v.text = app_policy
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let com_pol_Label: UILabel = {
        
        let atts = [NSFontAttributeName: appFont(size: 30),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "C O M M U N I T Y \n P O L I C Y", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.numberOfLines = 2
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let com_pol_TxtView: UITextView = {
        let v = UITextView()
        v.backgroundColor = UIColor.clear
        v.textAlignment = .center
        v.isUserInteractionEnabled = false
        v.font = chivo_AppFont(size: 12, light: true)
        v.text = "As a community, we do not tolerate racism, sexism, transphobia, ableism, xenophobia, kink shaming, body shaming, and discriminatory beliefs, practices and imagery. There is a 'first strike, last strike' policy for oppressive and violent behaviors such as harassment, abuse, doxxing, threatening or implying harm. Respect for every user on the platform is required."
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var agreements = 0
    func set_agree(_ sender: UIButton){
        agreements += 1
        agreements <= 1 ? show_com_pol() : go_to_signUp()
    }
    var com_label_leftCon = NSLayoutConstraint()
    var showingComPol = false
    func show_com_pol(){
        
        UIView.animate(withDuration: 1.0, animations: {
            self.termsLabelView.alpha = 0.0
            self.termsTxtView.alpha = 0
            self.com_label_leftCon.constant = 0
            self.view.layoutIfNeeded()
        },completion:{
            _ in
            self.showingComPol = true
        })
    }
    
    func go_to_signUp(){
        showingComPol ? present(SignUpVC(), animated: true , completion: nil) : ()
        
    }
    func goHome(_ gesture: UITapGestureRecognizer){
       dismiss(animated: true , completion: nil)
    }

}
