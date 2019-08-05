//
//  ExplorePageVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/30/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class ExplorePageVC: UIViewController {

 
    // MARK: - Variables
    
    var addingConnection = false //Marker to determine action taken for thurst option
    var showingMenu = false;
    var showingProfile = false
    var showingDetail: Bool = false
    var pullProfileGesture: UIPanGestureRecognizer?
    var bannerHeightCon = NSLayoutConstraint()
    var containerHeightCon = NSLayoutConstraint()
    var profileHeightCon = NSLayoutConstraint()
    var profileWidthCon = NSLayoutConstraint()
    var nameTopCon = NSLayoutConstraint()
    var profileTapGesture: UITapGestureRecognizer?
    var nextProfileTapGesture: UITapGestureRecognizer?
    lazy var database: AppDatabase = {
        let d = AppDatabase()
            d.exploreDelegate = self
        return d
    }()
    var thurstUsers: [ThurstUser]?{
        didSet{
            
            profileCV.reloadData()
        }
        
    }
    var currentUserIndex: Int?{
        didSet{
            let currentUser = thurstUsers?[currentUserIndex ?? 0]
            profile_detail.thurstUser = currentUser
            nameLabel.text = currentUser?.name
        }
    }
    
    // MARK: - Constants
    
    let lightBlue = createColor(153, green: 255, blue: 255)
    let darkBlue = createColor(104, green: 254, blue: 255)
    // MARK: - UI Elements
    let profileCV: iCarousel = {
        let car = iCarousel()
        car.type = .linear
        car.isPagingEnabled = true
        car.translatesAutoresizingMaskIntoConstraints = false
        return car
    }()
    let profileDragView: UIView = {
        let v = UIView()
        v.backgroundColor = createColor(230, green: 230, blue: 230)
        v.layer.cornerRadius = 10.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let bannerView: UIView = {
        let v = UIView()
        v.backgroundColor = createColor(153, green: 255, blue: 255)
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
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let thurstLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.black]
        let attTxt = NSAttributedString(string: "T H U R S T", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let exploreLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 24, light: true),
                    NSForegroundColorAttributeName: UIColor.black]
        let attTxt = NSAttributedString(string: "EXPLORE", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let nameLabel: UILabel = {
        let lab = UILabel()
        lab.font = chivo_AppFont(size: 18, light: true)
        lab.textColor = UIColor.black
        lab.textAlignment = .center
        lab.text = ""
        lab.alpha = 0.0
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let swipeLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "Swipe down to view profile", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let chatButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "messageButtonLrg"), for: .normal)
        btn.alpha = 0.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let thurstButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "ThurstButton"), for: .normal)
        btn.alpha = 0.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let profileContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 0.0
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 10)
        v.layer.shadowRadius = 10.0
        v.layer.shadowOpacity = 0.6
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let profile_detail: Profile_DetailView = {
        let v = Profile_DetailView()
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let doubleTapLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "Double tap to proceed", attributes: atts)
        let lab = UILabel()
        lab.isUserInteractionEnabled = true
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    // MARK: - Functions
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        print("transitioning")
    }
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        print("rotating")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        
        profileCV.delegate = self
        profileCV.dataSource = self
        // Do any additional setup after loading the view.
        database.exploreDelegate = self
        database.getThurstUsers()
        getLocation()
        askForPicture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func setViews(){
        view.backgroundColor = lightBlue
        view.add(views: bannerView,exploreLabel,profileContainerView)
        
        
        bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
        bannerHeightCon = bannerView.setHeightTo_Return(constant: 85)
        bannerView.add(views: navButton,thurstLabel)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(ExplorePageVC.show_menu(_:)), for: .touchUpInside)
        
        exploreLabel.setXTo(con: self.view.x(), by: 0)
        exploreLabel.setBottomTo(con: self.bannerView.bottom(), by: -10)
        
        profileContainerView.setXTo(con: self.view.x(), by: 0)
        profileContainerView.setTopTo(con: exploreLabel.bottom(), by: 20)
        profileContainerView.setWidthTo(constant: self.view.frame.width*0.75)
        containerHeightCon = profileContainerView.setHeightTo_Return(constant: self.view.frame.height*0.55)
        
        profileContainerView.add(views: doubleTapLabel,nameLabel,profile_detail,profileCV,swipeLabel, thurstButton,chatButton)
        
        doubleTapLabel.constrainInView(view: profileContainerView , top: 10, left: 20, right: nil, bottom: nil)
        
        profileCV.setTopTo(con: doubleTapLabel.bottom(), by: 20)
        profileCV.setXTo(con: profileContainerView.x(), by: 0)
        profileCV.setHeightTo(constant: self.view.frame.height*0.4)
        profileCV.setWidthTo(constant: self.view.frame.width*0.85)
        
        nameTopCon = nameLabel.setTopTo_Return(con: profileCV.bottom(), by: -15)
        nameLabel.setXTo(con: profileContainerView.x(), by: 0)
        
        swipeLabel.setTopTo(con: profileContainerView.bottom(), by: -20)
        swipeLabel.setLeftTo(con: profileContainerView.left(), by: 20)
       
        profile_detail.constrainInView(view: profileContainerView, top: nil, left: -10, right: 10, bottom: -75)
        profile_detail.setTopTo(con: nameLabel.bottom(), by: 10)
        
        chatButton.setRightTo(con: profileContainerView.x(), by: -10)
        chatButton.setTopTo(con: profile_detail.bottom(), by: 10)
        chatButton.addTarget(self , action: #selector(ExplorePageVC.pressChat(_:)), for: .touchUpInside)
        
        thurstButton.setLeftTo(con: profileContainerView.x(), by: 10)
        thurstButton.setYTo(con: chatButton.y(), by: 0)
        thurstButton.addTarget(self , action: #selector(ExplorePageVC.pressThurst(_:)), for: .touchUpInside)
        pullProfileGesture = UIPanGestureRecognizer(target: self , action: #selector(ExplorePageVC.expandProfile(_:)))
        profileContainerView.addGestureRecognizer(pullProfileGesture!)
        
    }
    func expandProfile(_ gesture: UIPanGestureRecognizer){
        let yTrans = gesture.translation(in: profileContainerView).y
        let current = self.view.frame.height*0.55
        let changePoint = current/8
        var change: CGFloat = yTrans
        let direction:CGFloat = gesture.velocity(in: profileContainerView).y > 0 ? 1.0 : -1.0
        let location = gesture.location(in: gesture.view!)
        let light_blue = createColor(153, green: 255, blue: 255)
        let dark_blue = createColor(0, green: 203, blue: 254)
        var shouldAnimate = false
        let bannerColor = yTrans > 10.0 && shouldAnimate ? dark_blue : light_blue
        let backGroundColor = yTrans > 10.0 && shouldAnimate ? darkBlue : lightBlue
        let exploreColor = yTrans > 10.0 && shouldAnimate ? UIColor.white : UIColor.black
        
        UIView.animate(withDuration: 0.1, animations: {
            self.bannerView.backgroundColor = bannerColor
            self.view.backgroundColor = backGroundColor
            self.exploreLabel.textColor = exploreColor
            self.thurstLabel.textColor = exploreColor
        })
        
        switch gesture.state{
        case .changed:
            
            if location.y > gesture.view!.frame.height*0.8{
                shouldAnimate = true
                let maxHeight = direction == 1.0 ? self.view.frame.height*0.9 : self.view.frame.height*0.6
                change = current + CGFloat(yTrans)
                containerHeightCon.constant += yTrans/10
                let percent_change = (change*direction/maxHeight)
                print("percent change is \(percent_change)")
                
                nameLabel.alpha += percent_change/10
                nameTopCon.constant =  min(20,20*percent_change)
                swipeLabel.alpha -= percent_change/10
                profile_detail.alpha += percent_change/40
                chatButton.alpha += percent_change/40
                thurstButton.alpha += percent_change/40
                
                var bannerShadowOffset = bannerView.layer.shadowOffset.height
                bannerView.layer.shadowOffset.height = bannerShadowOffset < -4.0 ? -3.0 : bannerShadowOffset > 10.0 ? 9.0 : bannerShadowOffset
                let shouldAdjustBannerShadow = bannerShadowOffset > -4.0 && bannerShadowOffset < 10.0
                bannerView.layer.shadowOffset.height +=  shouldAdjustBannerShadow ? percent_change/2 : 0
                
            }
        case .ended:
            let shouldExpand = change > changePoint
            // print("should expand: \(shouldExpand) because change is \(change)")
            
            expandContractProfile(expand: shouldExpand)
            break
        default: break
        }
        
    }
    
    func expandContractProfile(expand: Bool){
        showingProfile = expand
        let height = expand ? self.view.frame.height * 0.9 : self.view.frame.height * 0.55
        let nameTop:CGFloat = expand ? 20 : -15
        let nameAlpha:CGFloat = expand ? 1.0 : 0.0
        let swipeAlpha: CGFloat = expand ? 0.0 : 1.0
        print("swipe alpha: \(swipeAlpha)")
        let shadow_height: CGFloat = expand ? 10.0 : -3.0
        let shadow_anim = CABasicAnimation(keyPath: "shadowOffset.height")
        shadow_anim.toValue = shadow_height
        shadow_anim.duration = 0.5
        let light_blue = createColor(153, green: 255, blue: 255)
        let dark_blue = createColor(0, green: 203, blue: 254)
        let bannerColor = expand ? dark_blue : light_blue
        let exploreColor = expand ? UIColor.white : UIColor.black
        bannerView.layer.shadowOffset.height = shadow_height
        bannerView.layer.add(shadow_anim, forKey: nil)
        let backgroundColor = expand ? darkBlue : lightBlue
        let profileScaleXY: CGFloat = expand ? 0.9 : 1.0
      
        expand ? profile_detail.show_user_data() : profile_detail.hide_user_data()
        UIView.animate(withDuration: 0.5, delay: 0.0,options: [], animations: {
            self.bannerView.backgroundColor = bannerColor
            self.view.backgroundColor = backgroundColor
            self.exploreLabel.textColor = exploreColor
            self.thurstLabel.textColor = exploreColor
            self.containerHeightCon.constant = height
            self.nameTopCon.constant = nameTop
            self.nameLabel.alpha = nameAlpha
            self.swipeLabel.alpha = swipeAlpha
            self.profile_detail.alpha = nameAlpha
            self.chatButton.alpha = nameAlpha
            self.thurstButton.alpha = nameAlpha
            self.view.layoutIfNeeded()
            self.profileCV.currentItemView?.viewWithTag(99)!.transform = CGAffineTransform(scaleX: profileScaleXY, y: profileScaleXY)
            
        }, completion:{
            _ in
            self.showingDetail = expand
        })
    }
    
    func pressed_nav(sender: UIButton){
        showMenu(show: showingMenu)
    }
    
    func showMenu(show: Bool){
        
    }
    
    func showProfileTap(_ gesture: UITapGestureRecognizer){
        expandContractProfile(expand: !showingProfile)
    }
    func nextProfileTap(_ gesture: UITapGestureRecognizer){
        expandContractProfile(expand: false)
        profileCV.scrollToItem(at: profileCV.currentItemIndex+1, animated: true)
    }
    
    func show_menu(_ sender: UIButton){
        let settingsVC = MenuVC()
        settingsVC.fromPage = 3
        present(settingsVC , animated: true , completion: nil)
    }
    
    func pressThurst(_ sender: UIButton){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            guard let user = thurstUsers?[currentUserIndex ?? 0] else { return }
            guard let isConnection = ThurstUser().currentUser()?.connectionIDs.contains(user.id ?? "") else {return }
            if !isConnection{
            addingConnection = true
            thurstOptionsAlert(title: "Add Connection", message: "Save this user for later?", screenColor: UIColor.black, screenAlpha: 0.8, delegate: self)
            }else{
                thurstAlert(title: "Connection Already Made", message: "Looks like you've already saved this connection.", screenColor: UIColor.black, screenAlpha: 0.6)
            }
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
        
    }
    func pressChat(_ sender: UIButton){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            findConvo()
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
    }
    func findConvo(){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        guard let currentUser = self.thurstUsers?[currentUserIndex ?? 0] else {return}
        guard let userID = currentUser.id else {return}
        let chatRef = Database.database().reference().child("User_Convo_Refs").child(uid)
        chatRef.observeSingleEvent(of: .value , with: { (snapshot) in
            if let convoObjs = snapshot.value as? [String:Any]{
                let convoIds = convoObjs.flatMap({key,value in return key})
                var foundConvo = false
                for key in convoIds{
                    let nsKey = NSString(string: key)
                    if nsKey.contains(userID){
                        self.continueConvo(id: key)
                        foundConvo = true
                    }
                }
                if !foundConvo{
                    self.startConvo()
                }
            }
        }, withCancel: nil)
    }
    
    func continueConvo(id: String){
        let convoRef = Database.database().reference().child("User_Convo").child(id)
        convoRef.observeSingleEvent(of: .value , with: { (snapshot) in
            print(snapshot.value)
            if let refObject = snapshot.value as? [String:Any]{
                let convo = Convo()
                convo.setValuesForKeys(refObject)
            
                    let vc = ChatVC()
                    vc.currentConvo = convo
                    self.present(vc, animated: true , completion: nil)
                
            }
        }, withCancel: nil)
    }
    
    func startConvo(){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        guard let currentUser = self.thurstUsers?[currentUserIndex ?? 0] else {return}
        guard let userID = currentUser.id else {return}
        let newConvoId =  "\(uid)_\(userID)"
        let newConvo = Convo()
        newConvo.convo_id = newConvoId
        newConvo.conversant_ids = [uid:true,userID:true]
        let newConvoObj = newConvo.dictionaryWithValues(forKeys: ["convo_id","conversant_ids"])
        let userConvoRef = Database.database().reference().child("User_Convo_Refs").child(uid)
        let conversantConvoRef =  Database.database().reference().child("User_Convo_Refs").child(userID)
        let convoRef = Database.database().reference().child("User_Convo").child(newConvoId)
        convoRef.updateChildValues(newConvoObj) { (error, ref) in
            if error == nil{
                userConvoRef.updateChildValues([newConvoId:true])
                conversantConvoRef.updateChildValues([newConvoId:true])
                DispatchQueue.main.async(execute: {
                    let vc = ChatVC()
                    vc.currentConvo = newConvo
                    self.present(vc, animated: true , completion: nil)
                    
                })
            }else{
                self.thurstAlert(title: "Oops", message: "Looks like there was an error", screenColor: UIColor.black, screenAlpha: 0.8)
            }
        }
    }
    
    func getLocation(){
        if let appDel = UIApplication.shared.delegate as? AppDelegate{
            let status = CLLocationManager.authorizationStatus()
            switch status{
            case .authorizedAlways,.authorizedWhenInUse:
                //get location
                appDel.locationManager.requestLocation()
            case .denied, .notDetermined:
                //ask for permission
                appDel.locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
            }
        }
    }
    func askForPicture(){
        guard let currentUser = ThurstUser().currentUser() else { return }
        let url = currentUser.imageURL ?? ""
        if url.isEmpty{
            thurstAlert(title: "Major Key Alert!", message: "Show off your good looks by adding a pic to your profile!", screenColor: UIColor.black, screenAlpha: 0.6)
        }
    }
}
extension ExplorePageVC: iCarouselDelegate,iCarouselDataSource{
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        currentUserIndex = carousel.currentItemIndex
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        return thurstUsers?.count ?? 0
    }
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        if showingDetail{
            expandContractProfile(expand: false)
        }
    }
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        switch option{
        case .fadeMin:
            return value
        case .fadeMax:
            return 0.3
        case .spacing:
            return 1.1
        default:
            return value
        }
    }
   
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        guard let users = thurstUsers else { return  UIView()}
        let user = users[index]
       
        let shadowView = UIView()
            shadowView.backgroundColor = UIColor.white
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: 0, height: 10)
            shadowView.layer.shadowRadius = 10.0
            shadowView.layer.shadowOpacity = 0.6
            shadowView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width*0.85, height:self.view.frame.height*0.4)
        let userImageURL = user.imageURL ?? ""
        
        let profileIV = UIImageView()
            profileIV.alpha = 0.0
            profileIV.layer.masksToBounds = true
            profileIV.contentMode = .scaleAspectFill
            profileIV.tag = 99
            profileIV.translatesAutoresizingMaskIntoConstraints = false
            profileIV.isUserInteractionEnabled = true
        
        if userImageURL.isEmpty{
            profileIV.image = #imageLiteral(resourceName: "thurstLogo")
            profileIV.contentMode = .scaleAspectFit
            UIView.animate(withDuration: 0.25, animations: {
                profileIV.alpha = 1.0
            })
        }else{
            profileIV.revealImageWithURL(url: userImageURL)
        }
        
        profileTapGesture = UITapGestureRecognizer(target: self , action: #selector(ExplorePageVC.showProfileTap(_:)))
        profileTapGesture?.numberOfTapsRequired = 1
        nextProfileTapGesture?.delegate = self
        nextProfileTapGesture = UITapGestureRecognizer(target: self , action: #selector(ExplorePageVC.nextProfileTap(_:)))
        nextProfileTapGesture?.numberOfTapsRequired = 2
        profileIV.addGestureRecognizer(nextProfileTapGesture!)
        profileIV.addGestureRecognizer(profileTapGesture!)
        let connectionBadgeImage : UIImageView = {
            let iv = UIImageView()
                iv.image = #imageLiteral(resourceName: "thurstLogo")
            iv.contentMode = .scaleAspectFill
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        shadowView.add(views: profileIV)
        
        profileIV.constrainWithMultiplier(view: shadowView, width: 1.0, height: 1.0)
        
        guard let isConnection = ThurstUser().currentUser()?.connectionIDs.contains(user.id ?? "") else {return shadowView}
        if isConnection{
            profileIV.addSubview(connectionBadgeImage)
            connectionBadgeImage.constrainInView(view: profileIV, top: 8, left: nil, right: -8, bottom: nil)
            connectionBadgeImage.setWidth_Height(width: 20, height: 20)
        }
        
        return shadowView
    }
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
    }
}

extension ExplorePageVC: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.profileTapGesture! && otherGestureRecognizer == self.nextProfileTapGesture{
            return false
        }
        return true
    }
}

extension ExplorePageVC : DatabaseExploreDelegate{
    func returnUsers(_ users: [ThurstUser]) {
        var notHiddenUsers = users.filter { $0.isHiddenProfile == false }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        notHiddenUsers = notHiddenUsers.filter({$0.id != uid})
        thurstUsers = notHiddenUsers
    }
}
extension ExplorePageVC: ThurstOptionsDelegate{
    func okResponse() {
        if addingConnection{
            let database = AppDatabase()
            guard let currentUser = self.thurstUsers?[currentUserIndex ?? 0] else {return}
            database.createConnection(for: currentUser)
            thurstAlert(title: "Hooray", message: "Connection Made!", screenColor: UIColor.black, screenAlpha: 0.8)
        }
        addingConnection = !addingConnection
    }
    func cancelResponse() {
        addingConnection = !addingConnection
    }
}
