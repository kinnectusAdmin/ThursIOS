//
//  ThurstUser.swift
//  Thurst
//
//  Created by Blake Rogers on 1/13/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase
class ThurstUser: NSObject,NSCoding {
    // MARK: - Data
    
    var id: String?//firebase user id
    var name: String?
    var image: UIImage? //downloaded and transmuted image from imageURL
    var imageURL: String? //designated image url for profile
    var email: String?
    var phoneNumber: String?
    var apns_token: String?
    var bday: String?
    var location: String?
    var state:String?
    var coordinate: String?
    var sexuality: String?
    var relationshipStatus: String?
    var gender: String?
    var joined: String?//date that the user joined
    var lastSignIn: String?//last time that the user signed In
    var connections: [String:Any]?
    var isHiddenProfile: Bool = false
    var isTurnOnEmailNotification: Bool = false
    var isTurnOnLocation: Bool = true
    var isTurnOnPushNotification: Bool =  false
    var isVerified:Bool =  true
    var block_list: [String:Any]?//reference ids to users that are blocked
    var blocked_users: [String]{
        guard let list = block_list else { return []}
        return list.flatMap({key,value in return key})
    }
    var connectionCount: Int{
        guard let userconns = connections else {return 0}
        return userconns.keys.count
    }
    var connectionIDs : [String]{
        guard let userconns = connections else {return []}
        return userconns.flatMap({key,value in return key})
    }
    var imageURLs: [String:Any]? //reference urls to images other than profileImage url
    var images: [String]?{
        guard let imageurls = imageURLs else { return nil}
        return imageurls.map({ key,value in return value as! String })
    }
    
    private var userKeys: [String]{
        return [idKey,nameKey,profileImageURLKey,
                emailKey,bdayKey,locationKey,
                sexualityKey,relationshipKey,
                genderKey,imageURLsKey,phoneNumberKey,
                tokenKey,hiddenKey,isLocationOnKey,
                emailOnKey,isPushOnKey,verifiedKey,blockKey,stateKey,coordKey]
    }
    
    override init() {}
    
    convenience init(_ id: String?, name: String?, email: String?, phoneNumber: String?) {
        self.init()
        self.id = id
        self.name = name
        self.email = email
        
    }
     func currentUser()-> ThurstUser?{
        let defaults = UserDefaults.standard
        guard let userData = defaults.data(forKey: "currentUser") else { return nil}
        let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as! ThurstUser
        return user
        
    }
    func setCurrentUser(){
        let userData = NSKeyedArchiver.archivedData(withRootObject: self)
        UserDefaults.standard.set(userData , forKey: "currentUser")
    }
    func updateCurrentUser(server:Bool){
        setCurrentUser()
        
        if server{
            let data = AppDatabase()
            data.updateUser(user: self)
        }
    }
    
    private let idKey = "id"
    private let nameKey = "name"
    private let imageKey = "image"
    private let profileImageURLKey = "profileImageURL"
    private let emailKey = "email"
    private let phoneNumberKey = "phoneNumber"
    private let bdayKey = "bday"
    private let locationKey = "location"
    private let sexualityKey = "sexuality"
    private let relationshipKey = "relationshipStatus"
    private let genderKey = "gender"
    private let joinedKey = "joined"
    private let signInKey = "lastSignIn"
    private let imagesKey = "images"
    private let connectionsKey = "connections"
    private let imageURLsKey = "imageURLs"
    private let tokenKey = "apns_token"
    private let emailOnKey = "isTurnOnEmailNotification"
    private let hiddenKey = "isHiddenProfile"
    private let isLocationOnKey = "isTurnOnLocation"
    private let isPushOnKey = "isTurnOnPushNotification"
    private let verifiedKey = "isVerified"
    private let blockKey = "block_list"
    private let stateKey = "state"
    private let coordKey = "coordinate"
    // MARK: - Functions
   
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: idKey)
        aCoder.encode(self.name, forKey: nameKey)
        if let image = self.image{
            let png = UIImagePNGRepresentation(image)
              aCoder.encode(png, forKey: imageKey)
        }
        aCoder.encode(self.imageURL, forKey: profileImageURLKey)
        aCoder.encode(self.email , forKey: emailKey)
        aCoder.encode(self.phoneNumber , forKey: phoneNumberKey)
        aCoder.encode(self.bday, forKey: bdayKey)
        aCoder.encode(self.location, forKey: locationKey)
        aCoder.encode(self.sexuality, forKey: sexualityKey)
        aCoder.encode(self.relationshipStatus, forKey: relationshipKey)
        aCoder.encode(self.gender, forKey: genderKey)
        aCoder.encode(self.joined, forKey: joinedKey)
        aCoder.encode(self.lastSignIn, forKey: signInKey)
        aCoder.encode(self.imageURLs, forKey: imageURLsKey)
        aCoder.encode(self.connections, forKey: connectionsKey)
        aCoder.encode(self.apns_token, forKey: tokenKey)
        aCoder.encode(self.isHiddenProfile, forKey: hiddenKey)
        aCoder.encode(self.isTurnOnEmailNotification, forKey: emailOnKey)
        aCoder.encode(self.isTurnOnEmailNotification, forKey: isLocationOnKey)
        aCoder.encode(self.isTurnOnPushNotification, forKey: isPushOnKey)
        aCoder.encode(self.isVerified, forKey: verifiedKey)
        aCoder.encode(self.block_list,forKey: blockKey)
        aCoder.encode(self.state,forKey: stateKey)
        aCoder.encode(self.coordinate,forKey: coordKey)
        
 
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.id = aDecoder.decodeObject(forKey: idKey) as? String
        self.name = aDecoder.decodeObject(forKey: nameKey) as? String
        if let imageData = aDecoder.decodeObject(forKey: imageKey) as? Data{
            self.image = UIImage(data: imageData)
        }
        self.imageURL = aDecoder.decodeObject(forKey: profileImageURLKey) as? String
        self.email = aDecoder.decodeObject(forKey: emailKey) as? String
        self.phoneNumber = aDecoder.decodeObject(forKey: phoneNumberKey) as? String
        self.bday = aDecoder.decodeObject(forKey: bdayKey) as? String
        self.location = aDecoder.decodeObject(forKey: locationKey) as? String
        self.sexuality = aDecoder.decodeObject(forKey: sexualityKey) as? String
        self.relationshipStatus = aDecoder.decodeObject(forKey: relationshipKey) as? String
        self.gender = aDecoder.decodeObject(forKey: genderKey) as? String
        self.joined = aDecoder.decodeObject(forKey: joinedKey) as? String
        self.lastSignIn = aDecoder.decodeObject(forKey: signInKey) as? String
        self.imageURLs = aDecoder.decodeObject(forKey: imageURLsKey) as? [String:Any]
        self.connections  = aDecoder.decodeObject(forKey: connectionsKey) as? [String:Any]
        self.apns_token = aDecoder.decodeObject(forKey: tokenKey) as? String
        self.isTurnOnEmailNotification = aDecoder.decodeBool(forKey: emailOnKey)
        self.isHiddenProfile = aDecoder.decodeBool(forKey: hiddenKey)
        self.isTurnOnPushNotification = aDecoder.decodeBool(forKey: isPushOnKey)
        self.isTurnOnLocation = aDecoder.decodeBool(forKey: isLocationOnKey)
        self.isVerified = aDecoder.decodeBool(forKey: verifiedKey)
        self.block_list = aDecoder.decodeObject(forKey: blockKey) as? [String:Any]
        self.state = aDecoder.decodeObject(forKey: stateKey) as? String
        self.coordinate = aDecoder.decodeObject(forKey: coordKey) as? String
    }
    func connection()->Connection{
        var connection = Connection()
            connection.timestamp = NSNumber.init(value: Date().timeIntervalSince1970)
            connection.name = name
            connection.user_image = imageURL
            connection.user_id = id
        return connection
    }
}
