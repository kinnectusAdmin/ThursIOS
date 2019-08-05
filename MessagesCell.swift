//
//  MessagesCell.swift
//  Thurst
//
//  Created by Blake Rogers on 10/29/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol MessagesDelegate {
    func deleteMessage(at path: IndexPath)
}
class MessagesCell: UICollectionViewCell {
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        add(views: deleteButton, messengerImage,messageLabel)
        contentView.clipsToBounds = false
        self.clipsToBounds = false
        
        deleteButton.setWidth_Height(width: 50, height: 50)
        deleteButton.setRightTo(con: contentView.left(), by: 0)
        deleteButton.setYTo(con: contentView.y(), by: 0)
        deleteButton.addTarget(self , action: #selector(MessagesCell.deleteMessage(_:)), for: .touchUpInside)
        
        messengerImage.setWidth_Height(width: 50, height:50)
        messengerImage.setLeftTo(con: deleteButton.right(), by: 0)
        messengerImage.setTopTo(con: deleteButton.top(), by: 0)
        
        messageLabel.setLeftTo(con: messengerImage.right() , by: 16)
        messageLabel.setTopTo(con: messengerImage.top(), by: 0)
        messageLabel.setRightTo(con: contentView.right() , by: 0)
        
        let shadow = UIView()
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.backgroundColor = UIColor.white
        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOffset = CGSize(width: 0, height: 10)
        shadow.layer.shadowRadius = 4.0
        shadow.layer.shadowOpacity = 0.2
        contentView.insertSubview(shadow , belowSubview: deleteButton)
        shadow.setLeftTo(con: deleteButton.left(), by: 0)
        shadow.setRightTo(con: messengerImage.right(), by: 0)
        shadow.setTopTo(con: deleteButton.top(), by: 0)
        shadow.setBottomTo(con: deleteButton.bottom(), by: 0)
    }
    
    func deleteMessage(_ sender: UIButton){
        delegate?.deleteMessage(at: path)
        if let id = convoId{
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let convoRef = Database.database().reference().child("User_Convo_Refs").child(uid).child(id)
            convoRef.removeValue()
            
        }
    }
    var convoId: String?
    var message: String?{
        didSet{
            let messageRef = Database.database().reference().child("Messages").child(message!)
                messageRef.observeSingleEvent(of: .value , with: { (snapshot) in
                print(snapshot.value)
                if let refObject = snapshot.value as? [String:Any]{
                    let message = ChatMessage()
                    message.setValuesForKeys(refObject)
                    DispatchQueue.main.async(execute: {
                        var wasSent = false
                        if let from_id = message.from_id{
                            if from_id == Auth.auth().currentUser?.uid{
                                wasSent = true
                                if let recv_url = message.receiver_url{
                                     self.messengerImage.loadImageWithURL(url: recv_url)
                                }else{
                                    self.messengerImage.image = #imageLiteral(resourceName: "thurstLogo")
                                }
                            }else{
                                wasSent = false
                                if let sendr_url = message.sender_url{
                                    self.messengerImage.loadImageWithURL(url: sendr_url)
                                }else{
                                    self.messengerImage.image = #imageLiteral(resourceName: "thurstLogo")
                                }
                            }
                        }
                        if let url = message.image_URL{
                            self.messageLabel.text = wasSent ? "Image Sent" : "Image Received"
                        }else{
                            self.messageLabel.text = message.message ?? ""
                        }
                    })
                   
                }
            }, withCancel: nil)
        }
    }
  
    var delegate: MessagesDelegate?
    var path = IndexPath()
    var messageLabel: UILabel = {
        let label = UILabel()
            label.text = ""
            label.textColor = UIColor.black
            label.textAlignment = .left
            label.font = chivo_AppFont(size: 12, light: true)
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let messengerImage : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true 
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let deleteButton : UIButton = {
        let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "deleteButton"), for: .normal)
            button.backgroundColor = light_green
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
   
}
