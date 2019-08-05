//
//  VerifyCompleteVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/29/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class VerifyCompleteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setExploreGesture()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exploreGesture = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setViews(){
        view.backgroundColor = UIColor.clear
        view.add(views: completeImage,completeLabel)
        completeImage.setXTo(con: self.view.x(), by: 0)
        completeImage.setTopTo(con: self.view.top(), by: 50)
        completeImage.setWidth_Height(width: self.view.frame.width , height: self.view.frame.width * 0.5)
        completeLabel.setXTo(con: self.view.x(), by: 0)
        completeLabel.setTopTo(con: completeImage.bottom(), by: 20)
    
    }
    var exploreGesture: UITapGestureRecognizer?
    func setExploreGesture(){
        exploreGesture = UITapGestureRecognizer(target: self , action: #selector(VerifyCompleteVC.goExplore(_:)))
        view.addGestureRecognizer(exploreGesture!)
    }
    
    let completeImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "shield-outline")
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius  = 0
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let completeLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 20, light: true),
                    NSForegroundColorAttributeName: UIColor.black]
        let attTxt = NSAttributedString(string: "YOUR'E ALL SET!", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    func goExplore(_ gesture: UITapGestureRecognizer){
        if let pageVC = self.parent as? UIPageViewController{
            if let window = UIApplication.shared.keyWindow{
                window.rootViewController = ExplorePageVC()
                window.makeKeyAndVisible()
            }
        }
    }
}
