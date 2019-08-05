//
//  Convo.swift
//  Thurst
//
//  Created by Blake Rogers on 8/2/16.
//  Copyright © 2016 T3. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

protocol ConvoDelegate{
    func updateConvo()
}
class Convo: NSObject, NSCoding{
    var convoDelegate: ConvoDelegate?
    var convo_id:  String?
    var conversant_ids:  [String:Bool]?
    var last_message: String?
    var latest_timestamp: NSNumber?
    var messages = [ChatMessage]()
    var message_refs : [String]{
        guard let refs = message_ids else { return []}
        return refs.map({ key,value in return key })
    }
    var conversants: [String]{
        get{
            guard let ids = conversant_ids else{ return []}
            return ids.map({ key,value in return key})
        }
    }
    
    var message_ids: [String: Any]?{
        didSet{
            for id in message_refs{
               let messageRef =  Database.database().reference().child("Messages").child(id)
                messageRef.observe(.value , with: { (snapshot) in
                    print(snapshot.value )
                    if let refObject = snapshot.value as? [String:Any]{
                        let message = ChatMessage()
                            message.setValuesForKeys(refObject)
                        self.messages.append(message)
                    }
                }, withCancel: nil)
            }
        }
    }
    var latestChat: ChatMessage?{
        return messages.filter({message in return message.timeStamp == latest_timestamp}).first
    }
    
    private var messageKeys:[String]{
        return  ["message_id","from_id","to_id","sender_url",
                 "receiver_url","message","convo_id",
                 "image_URL","image_height","image_width","timeStamp"]
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(conversant_ids, forKey: "conversant_ids")
        aCoder.encode(messages, forKey: "messages")
        aCoder.encode(convo_id, forKey: "convo_id")
    }
    static func idForConversants(_ ids: String...)->String{
            var sortedIDs = ids.sorted()
             let id =  sortedIDs.reduce("",{result,next in return result + next })
            return id
        }
    
    override init(){
        
    }
    
    required init(coder aDecoder: NSCoder){
        super.init()
        self.conversant_ids = aDecoder.decodeObject(forKey: "conversant_ids") as? [String:Bool] ?? [:]
        self.messages = aDecoder.decodeObject(forKey: "messages") as? [ChatMessage] ?? []
        self.convo_id = aDecoder.decodeObject(forKey: "convo_id") as? String ?? ""
        }

    func sendImageMessage(message: ChatMessage){
        let firDatabase = Database.database().reference()
        let messageReference = firDatabase.child("Messages")
            messageReference.keepSynced(true)
        guard let id = convo_id else { return}
        guard let currentUser = Auth.auth().currentUser?.uid else{return}
        guard let message_id = message.message_id else { return }
        guard let thurstUser = ThurstUser().currentUser() else {return}
        let convoReference = firDatabase.child("User_Convo").child(id)
            convoReference.keepSynced(true)
        let messageObj = message.dictionaryWithValues(forKeys: messageKeys)
        let time = message.timeStamp ?? NSNumber(value:Date().timeIntervalSince1970)
        messageReference.child(message_id).updateChildValues(messageObj, withCompletionBlock: {
        (error,ref) in
            convoReference.child("message_ids").updateChildValues([message_id:true])
            convoReference.updateChildValues(["last_message":message_id,
                                          "latest_timestamp":time])
        })
    }
    
    func sendTextMessage(message: ChatMessage){
        let firDatabase = Database.database().reference()
        let messageReference = firDatabase.child("Messages")
        let timeStamp = message.timeStamp!.stringValue
        guard let currentUser = Auth.auth().currentUser?.uid else{
            return
        }
        guard let conversant = message.to_id else {return}
        guard let thurstUser = ThurstUser().currentUser() else {return}
        guard let id = convo_id else { return}
        let convoReference = firDatabase.child("User_Convo").child(id)
            convoReference.keepSynced(true)
        let message_id = message.message_id!
        let object: [String:Any] = ["message":message.message!,
                                    "from_id":currentUser,
                                    "to_id":conversant,
                                    "timeStamp":timeStamp,
                                    "convo_id":id,
                                    "sender_url": thurstUser.imageURL,
                                    "message_id":message_id]
        let userConvoRef = firDatabase.child("User_Convo_Refs").child(conversant)
        userConvoRef.updateChildValues([id:true])
        messageReference.child(message_id).updateChildValues(object, withCompletionBlock: {
            (error,ref) in
            let key = ref.key
            convoReference.child("message_ids").updateChildValues([message_id:true])
            convoReference.updateChildValues(["last_message":message_id,
                                              "latest_timestamp":timeStamp])
        })
    }
    
    func observeConvo(){
        let firDatabase = Database.database().reference()
        let messageReference = firDatabase.child("Messages")
        guard let id = convo_id else{   return }
        guard let chatterID = Auth.auth().currentUser?.uid else{return}
        
        let convoReference = firDatabase.child("User_Convo").child(id).child("message_ids")
        convoReference.observe(.childAdded, with: {
            snapshot in
            
            let newMessageID = snapshot.key
            guard !self.message_refs.contains(newMessageID) else {
                self.convoDelegate?.updateConvo()
                return
            }
            
            
            messageReference.child(newMessageID).observeSingleEvent(of: .value, with: {messageSnap in
                guard  let messageObject = messageSnap.value as? [String: AnyObject] else{
                    return
                }
                
                let chatMessage = ChatMessage()
                    chatMessage.setValuesForKeys(messageObject)
                
                if !self.message_refs.contains(where: {id in id == chatMessage.message_id!}){
                    self.messages.append(chatMessage)
                    self.last_message = chatMessage.message
                    self.latest_timestamp = chatMessage.timeStamp
                }
                self.convoDelegate?.updateConvo()
            
            })
        })
        
    }
}
