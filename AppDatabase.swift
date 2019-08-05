
//
import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
//import FBSDKLoginKit
//import FBSDKCoreKit
//import FacebookLogin
//import FacebookCore
//import Crashlytics
public let FirebaseUserPath : String = "Users"
protocol DatabaseExploreDelegate: class{
    func returnUsers(_ users: [ThurstUser])
}
protocol DatabaseDelegate {
    func connectionFailed()
    func failedToGetData()
}

protocol ProfileDelegate: class{
 
    //func fetchedPartnerWorkouts(workouts: [Event])

}

protocol DatabaseSignUpDelegate : class{
    func unauthorizedSignUp()
    func userSignUpSucceeded(_ succeeded: Bool)
    func fbUserSignUpSucceeded()
    func userSignInSucceeded()
    func fbUserSignInSucceeded()
    
}

protocol DatabaseMessageDelegate: class,DatabaseDelegate{
    func messageSent()
    
}

protocol DatabaseChatDelegate: class{
    func foundChatters(chatters: [Chatter])
    func fetchedConvos(conversations: [Convo])
}

public class AppDatabase: NSObject{
    //Keys for Thurs Connection
    private let connectionId = "user_id"
    private let connectionImage = "user_image"
    private let connectionName = "name"
    private let connectionTime = "timestamp"
    private var connectionKeys: [String]{
        return [connectionId,connectionImage,connectionName,connectionTime]
    }
    //Keys for Thurst User
    private let idKey = "id"
    private let nameKey = "name"
    private let imageURLKey = "imageURL"
    private let imageURLsKey = "imageURLs"
    private let emailKey = "email"
    private let phoneNumberKey = "phoneNumber"
    private let bdayKey = "bday"
    private let locationKey = "location"
    private let sexualityKey = "sexuality"
    private let relationshipKey = "relationshipStatus"
    private let genderKey = "gender"
    private let joinedKey = "joined"
    private let signInKey = "lastSignIn"
    private let connectionsKey = "connections"
    private let tokenKey = "apns_token"
    private let emailOnKey = "isTurnOnEmailNotification"
    private let hiddenKey = "isHiddenProfile"
    private let isLocationOnKey = "isTurnOnLocation"
    private let isPushOnKey = "isTurnOnPushNotification"
    private let verifiedKey = "isVerified"
    private let blockKey = "block_list"
    private let stateKey = "state"
    private let coordKey = "coordinate"
    private var userKeys: [String]{
        return [idKey,nameKey,imageURLKey,imageURLsKey,emailKey,
                bdayKey,locationKey,sexualityKey,relationshipKey,
                genderKey,phoneNumberKey,connectionsKey,
                tokenKey,emailOnKey,hiddenKey,isLocationOnKey,
                isPushOnKey,verifiedKey,blockKey,stateKey,coordKey]
    }
    weak var profileDelegate: ProfileDelegate?
    weak var exploreDelegate: DatabaseExploreDelegate?
    weak var signUpDelegate: DatabaseSignUpDelegate?
    weak var messageDelegate: DatabaseMessageDelegate?
    weak var chatDelegate: DatabaseChatDelegate?
    
    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        let queue = OperationQueue.main
        let sessDefined = Foundation.URLSession.shared
        //sessDefined.delegate = self
        return sessDefined
    }()

    
    enum HeaderField: String{
        case Auth
        case JSON
        case None
        case POST
        case GET
        case PUT
        case DEL
    }
    
    static var authCode: String {
        let defaults = UserDefaults.standard
        if let code = defaults.string(forKey: "authCode"){
            return code
        }
        return ""
    }
    
    private var deviceToken: String = {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "deviceToken") else{
            return ""
        }
        
        return token
    }()
    
    private var fcmToken: String = {
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "fcmToken") else{
            return ""
        }
        
        return token
    }()
    
// Create a comma separated list of items in string
    func list(for inputs:[String])->String{
        if inputs.isEmpty{
            return ""
        }
        var string = inputs.reduce("", {value1,value2 in
            return value1 + "," + value2
            
        })
        string.characters.remove(at: string.startIndex)
        
        return string
    }

    typealias SessionTaskHandler = (Data?,URLResponse?,Error?)->()
    
    func sendTaskWithRequest(request: URLRequest, using handler: SessionTaskHandler?){
        guard let comp_handler = handler else { return }
        let task = session.dataTask(with: request, completionHandler:comp_handler )
        task.resume()
    }
    
//    func makeRequestForPath(pathURL:String,handler: SessionTaskHandler?, fields:HeaderField...){
//        
//        guard let url = URL(string: pathURL) else{
//            return
//        }
//        
//        let req = NSMutableURLRequest(url: url)
//        //req.httpBody = path.data(using: .utf8)
//        for field in fields{
//            switch field {
//            case .POST:
//                req.httpMethod = "POST"
//            case .GET:
//                req.httpMethod = "GET"
//            case .JSON:
//                req.addValue("application/json", forHTTPHeaderField: "Content-Type")
//            case .Auth:
//                //req.addValue(AppDatabase.authCode, forHTTPHeaderField: "Authorization")
//                continue
//            case .PUT:
//                req.httpMethod = "PUT"
//            case .DEL:
//                req.httpMethod = "DELETE"
//            default: break
//            }
//        }
//        
//       sendTaskWithRequest(request: req as URLRequest,using: handler)
//    }
    
    func makeThurstUser(_ user: User)-> ThurstUser{
        var appUser = ThurstUser.init(user.uid, name: nil, email: user.email, phoneNumber: user.phoneNumber)
            appUser.apns_token = deviceToken
        return appUser
    }
    
    func fetchAndSetCurrentUser(_ uid: String){
        let query = Database.database().reference().child(FirebaseUserPath).child(uid)
        query.observeSingleEvent(of: .value , with: { (snap) in
            if let keyValues = snap.value as? [String: Any]{
                var user = ThurstUser()
                    user.setValuesForKeys(keyValues)
                    user.setCurrentUser()
                if let token = user.apns_token{
                    if self.fcmToken != token && self.fcmToken != ""{
                        user.apns_token = self.fcmToken
                        user.updateCurrentUser(server: true)
                    }
                }else{
                    if self.deviceToken != ""{
                        user.apns_token = self.fcmToken
                        user.updateCurrentUser(server: true)
                    }
                }
            }
        }) { (error ) in
            if error != nil{
                print(error.localizedDescription)
            }
            
        }
    }
    
    func fetchThurstUser(_ uid: String)->ThurstUser?{
        let query = Database.database().reference().child(FirebaseUserPath).child(uid)
        query.observeSingleEvent(of: .value , with: { (snap) in
            if let keyValues = snap.value as? [String: String]{
                let user = ThurstUser().setValuesForKeys(keyValues)
                return user
            }
        }) { (error ) in
            if error != nil{
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    func createUser(_ user: User ,name: String){
        let appUser = makeThurstUser(user)
            appUser.name = name
        let userObject = appUser.dictionaryWithValues(forKeys: [emailKey,nameKey,phoneNumberKey,idKey,tokenKey])
        
    let ref = Database.database().reference().child(FirebaseUserPath).child(user.uid)
        
        ref.updateChildValues(userObject) { (error , ref) in
            if error == nil{
               self.fetchAndSetCurrentUser(user.uid)
                print("success storing user")
                self.signUpDelegate?.userSignUpSucceeded(true)
            }else{
                Auth.auth().currentUser?.delete(completion: { (error) in
                    if error == nil{
                        print("failed to create user")
                        self.signUpDelegate?.userSignUpSucceeded(false)
                    }
                })
               
            }
        }
    }
    
    func updateUser( user: ThurstUser){
        guard let id = Auth.auth().currentUser?.uid else { return}
        let appUser = user.dictionaryWithValues(forKeys: userKeys)
        let userRef = Database.database().reference().child(FirebaseUserPath).child(id)
        userRef.setValue(appUser) { (error , ref ) in
            if error != nil{
                print("error updating user")
            }else{
                print("success updating user")
            }
        }
//        userRef.updateChildValues(appUser) { (error , ref) in
//            if error == nil{
//                print("success storing user")
//            }else{
//                print("failed to create user")
//            }
//        }
    }
    static  func logOutUser(){
        //make the current user nil in the defaults
        // if signed up manually with gymmie server
        let def = UserDefaults.standard
        def.removeObject(forKey: "authCode")
        //if signed up through facebook or othe social media
        def.removeObject(forKey: "currentUser")
//        let controller = FBController()
//        if controller.checkAccessToken{
//            controller.logOutUser()
//        }
        
    }
    func createConnection(for user: ThurstUser){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        let connection = user.connection()
        guard let connectionId = connection.user_id else { return}
        let connectionObj = connection.dictionaryWithValues(forKeys: connectionKeys)
        let connectionRef = Database.database().reference().child("Connections").child(uid).child(connectionId)
        let userRef = Database.database().reference().child("Users").child(uid).child("connections")
        
        connectionRef.updateChildValues(connectionObj) { (error, ref) in
            if error != nil{
                print("failure creating connection")
            }else{
                userRef.updateChildValues([connection.user_id!:true])
                print("success creating connection")
            }
        }
    }
    func updateUserLocation(lat:String,long:String,city:String,state:String){
        guard let currentUser = ThurstUser().currentUser() else { return }
                currentUser.location = city
                currentUser.state = state
                currentUser.coordinate = "\(lat):\(long)"
                currentUser.updateCurrentUser(server: true)
    }

}
extension AppDatabase{
    func getThurstUsers(){
        let ref = Database.database().reference().child(FirebaseUserPath).observeSingleEvent(of: .value , with: { (snapshot ) in
            if snapshot.value != nil{
                if let userList = snapshot.value as? [String: Any]{
                    print(userList)
                    var users: [ThurstUser] = []
                    for (_, value) in userList{
                        if let userObjects = value as? [String: Any]{
                           let thurstUser = ThurstUser()
                                thurstUser.setValuesForKeys(userObjects)
                            users.append(thurstUser)
                        }
                    }
                    self.exploreDelegate?.returnUsers(users)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}


