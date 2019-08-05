//
//  ChatView.swift
//  Thurst
//
//  Created by Blake Rogers on 12/7/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//

import UIKit
protocol MessageDelegate{
    func sendMessage( message: String)
    func sendImage()
    func resizeFor(height: CGFloat)
}
class ChatView: UIView {
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func layoutSubviews() {
        setViews()
        
    }
    var beginGesture:UITapGestureRecognizer?
    func dismissBeginLabel(_ gesture: UITapGestureRecognizer){
        UIView.animate(withDuration: 0.3, animations: {
            self.beginLabel.alpha = 0.0
            self.sendButton.alpha = 1.0
        },completion: {
            _ in
            self.chatTextView.becomeFirstResponder()
        })
    }
    func resetBeginLabel(){
        var textInField = chatTextView.hasText
        UIView.animate(withDuration: 0.3, animations: {
            self.beginLabel.alpha = textInField ? 0.0 : 1.0
            self.sendButton.alpha = textInField ? 1.0 : 0.0
        })
    }
    
    func dismissedKeyboard(){
        if chatTextView.isFirstResponder{
            chatTextView.resignFirstResponder()
        }
    }
    
    let getImageButton : UIButton = {
        let button = UIButton()
            button.tag = 10
            button.setImage(#imageLiteral(resourceName: "greyCameraButton"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
            button.tag = 11
            button.alpha = 0.0
            button.setImage(#imageLiteral(resourceName: "sendButton"), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let chatTextView: UITextView = {
        let v = UITextView()
        v.textColor = UIColor.black
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 8.0
        v.font = chivo_AppFont(size: 15, light: true)
        v.textAlignment = .left
        v.backgroundColor = UIColor.white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let beginLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 18, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "Begin Typing. . .", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.isUserInteractionEnabled = true
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    var delegate: MessageDelegate?
    var message:  String{
        return chatTextView.text
    }
    func setViews(){
        backgroundColor = UIColor.white
        add(views: getImageButton,sendButton,chatTextView,beginLabel)
        
        getImageButton.constrainInView(view: self, top: 0, left: 0, right: nil, bottom: 0)
        getImageButton.addTarget(self , action: #selector(ChatView.sendHandler(_:)), for: .touchUpInside)
        
        chatTextView.constrainWithMultiplier(view: self, width: 0.7, height: 0.7)
        chatTextView.delegate = self
        
        sendButton.constrainInView(view: self, top: 0, left: nil, right: 0, bottom: 0)
        sendButton.setLeftTo(con: chatTextView.right(), by: 4)
        sendButton.addTarget(self , action: #selector(ChatView.sendHandler(_:)), for: .touchUpInside)
        
        beginLabel.setXTo(con: chatTextView.x(), by: 0)
        beginLabel.setTopTo(con: chatTextView.top(), by: 0)
        beginGesture = UITapGestureRecognizer(target: self , action: #selector(ChatView.dismissBeginLabel(_:)))
        beginLabel.addGestureRecognizer(beginGesture!)
    }
    
    var chatHeight = CGFloat()
    func sendHandler(_ sender: UIButton){
        if sender.tag == 10{
            delegate?.sendImage()
        }else{
            if !chatTextView.text.isEmpty{
                delegate?.sendMessage(message: message)
            }
            chatTextView.text = ""
            delegate?.resizeFor(height: chatTextView.contentSize.height+10)
        }
        
        if chatTextView.isFirstResponder{
            chatTextView.resignFirstResponder()
        }
    }
}
extension ChatView: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let alltext = textView.text.appending(text)
        let textRect = alltext.rectForText(width: chatTextView.frame.width,textSize: 15)
        if text == "\n"{
            textView.resignFirstResponder()
            return false
        }
        if textView.frame.height < textRect.height{
            delegate?.resizeFor(height: textRect.height)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        UIView.animate(withDuration: 0.3, animations: {
            self.beginLabel.alpha = 0.0
            
            self.sendButton.alpha = 1.0
        })
    }
}
