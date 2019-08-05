//
//  OptionsView.swift
//  Thurst
//
//  Created by Blake Rogers on 2/10/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
protocol OptionDelegate{
    func blockUser()
    func unblockUser()
    func reportUser()
}
class OptionsView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        backgroundColor = UIColor.black
        addShadow(10, dy: 10, color: UIColor.black , radius: 10.0, opacity: 0.6)
    
        add(views: blockButton,reportButton)
        
        let blockTitle = isBlocked ? "UNBLOCK" : "BLOCK"
        let title = NSAttributedString(string: blockTitle, attributes: [NSFontAttributeName: chivo_AppFont(size: 15, light: true),NSForegroundColorAttributeName: UIColor.white])
        
        blockButton.setAttributedTitle(title, for: .normal)
        blockButton.constrainInView(view: self , top: 5, left: 10, right: nil, bottom: nil)
        
        reportButton.setTopTo(con: blockButton.bottom(), by: 5)
        reportButton.setLeftTo(con: blockButton.left(), by: 0)
        
        if isBlocked{
            blockButton.addTarget(self , action: #selector(OptionsView.select_unblock(_:)), for: .touchUpInside)
        }else{
            blockButton.addTarget(self , action: #selector(OptionsView.select_block(_:)), for: .touchUpInside)
        }
            reportButton.addTarget(self , action: #selector(OptionsView.select_report(_:)), for: .touchUpInside)
    }
    var isBlocked: Bool = false
    var delegate: OptionDelegate?
    let blockButton : UIButton = {
        let button = UIButton()
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let reportButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "REPORT", attributes: [NSFontAttributeName: chivo_AppFont(size: 15, light: true),NSForegroundColorAttributeName: UIColor.white])
        button.setAttributedTitle(title, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = UIColor.clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    func select_block(_ sender: UIButton){
        delegate?.blockUser()
        dismiss()
    }
    func select_unblock(_ sender: UIButton){
        delegate?.unblockUser()
        dismiss()
    }
    
    func select_report(_ sender: UIButton){
        delegate?.reportUser()
        dismiss()
    }
    
    func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
        }) { _ in
            self.delegate = nil
            self.removeFromSuperview()
        }
    }
}
