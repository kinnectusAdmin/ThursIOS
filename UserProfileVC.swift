//
//  UserProfileVC.swift
//  Thurst
//
//  Created by Blake Rogers on 10/18/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UserProfileVC: KeyBoardManagerVC {

    
    // MARK: - Variables
    var addingConnection: Bool = false
    var viewingOtherUser = false
    var profileWidthCon = NSLayoutConstraint()
    var profileHeightCon = NSLayoutConstraint()
    var nameTopCon = NSLayoutConstraint()
    var showingDetail: Bool = false
    let lightBlue = createColor(153, green: 255, blue: 255)
    let dark_blue = createColor(104, green: 254, blue: 255)
    var containerHeightCon = NSLayoutConstraint()
    var bannerHeightCon = NSLayoutConstraint()
    var showingEdit: Bool = false
    var showingMenu = false;
    var showDetailGesture: UITapGestureRecognizer?
    var userImageURLs: [[String]] = []
    var deletingImage: String?
    var user: ThurstUser?{
        didSet{
            profile_detail.thurstUser = user!
            nameLabel.text = user!.name!
            profile_detail.show_user_data()
            profileCV.reloadData()
        }
    }
    var currentItemViewRect = CGRect()
    // MARK: - UIElements
    
    let profileContainerView: UIView = {
        let v = UIView()
        v.tag = 100
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let profile_detail: Profile_DetailView = {
        let v = Profile_DetailView()

        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let profileShadow: UIView = {
        let shadowView = UIView()
        shadowView.tag = 69
        shadowView.backgroundColor = UIColor.white
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowRadius = 4.0
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.shadowOffset.height = 10.0
       
        return shadowView
    }()
    
    let nameLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .center
        lab.font = chivo_AppFont(size: 18, light: true)
        lab.textColor = UIColor.black
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let altNameField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.textAlignment = .center
        field.font = chivo_AppFont(size: 15, light: true)
        field.alpha = 0.0
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    let editNameButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        button.alpha = 0.0
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let saveNameButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        button.alpha = 0.0
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        //btn.layer.cornerRadius = 0.0
        //btn.layer.masksToBounds = true
        btn.alpha = 0.0
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let profileCV: iCarousel = {
        let car = iCarousel()
        car.type = .linear
        car.isPagingEnabled = true
        car.translatesAutoresizingMaskIntoConstraints = false
        return car
    }()
    
    let imagesCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 50)
        let frame = CGRect(x: 0, y: 0, width:300, height: 50)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.alpha = 0.0
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let bannerView: UIView = {
        let v = UIView()
        let dark_blue = createColor(0, green: 203, blue: 254)
        v.backgroundColor = dark_blue
        v.layer.cornerRadius = 0.0
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 4.0
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset.height = 10.0
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
        let atts = [NSFontAttributeName: chivo_AppFont(size: 10, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "T H U R S T", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let editButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "person_edit"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let profileLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 24, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "PROFILE", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        profileCV.delegate = self
        profileCV.dataSource = self
        
        imagesCV.delegate = self
        imagesCV.dataSource = self
        imagesCV.register(ProfileCell.self , forCellWithReuseIdentifier: "ProfileCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setViews(){
        
        view.backgroundColor = dark_blue
        view.add(views: profileContainerView,bannerView,profileLabel)
        
        bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
        bannerHeightCon = bannerView.setHeightTo_Return(constant: 85)
        bannerView.add(views: navButton,thurstLabel,editButton)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(UserProfileVC.show_menu(_:)), for: .touchUpInside)
        
        editButton.alpha = viewingOtherUser ? 0.0 : 1.0
        editButton.constrainInView(view: bannerView , top: nil, left: nil, right: 0, bottom: 0)
        editButton.addTarget(self , action: #selector(UserProfileVC.select_edit(_ : )), for: .touchUpInside)
        profileLabel.setXTo(con: self.view.x(), by: 0)
        profileLabel.setBottomTo(con: self.bannerView.bottom(), by: -10)
        
        profileContainerView.setXTo(con: self.view.x(), by: 0)
        profileContainerView.setTopTo(con: bannerView.bottom(), by: 20)
        profileContainerView.setWidthTo(constant: self.view.frame.width*0.75)
        containerHeightCon = profileContainerView.setHeightTo_Return(constant: self.view.frame.height*0.9)
        
        profileContainerView.add(views: nameLabel,altNameField,saveNameButton,editNameButton,profileShadow,profile_detail,imagesCV,profileCV,thurstButton,chatButton)
        
        imagesCV.setTopTo(con: profileShadow.top(), by: 0)
        imagesCV.setXTo(con: profileContainerView.x(), by: 0)
        imagesCV.setHeightTo(constant: self.view.frame.height*0.4)
        imagesCV.setWidthTo(constant: self.view.frame.width*0.85)
        
        profileCV.setTopTo(con: profileContainerView.top(), by: 20)
        profileCV.setXTo(con: profileContainerView.x(), by: 0)
        profileCV.setHeightTo(constant: self.view.frame.height*0.4)
        profileCV.setWidthTo(constant: self.view.frame.width*0.85)

        profileShadow.setLeftTo(con: profileCV.left(), by: 0)
        profileShadow.setBottomTo(con: profileCV.bottom(), by: 0)
        profileShadow.setTopTo(con: profileCV.top(), by: 10)
        profileShadow.setRightTo(con: profileCV.right(), by: 0)
        
        nameTopCon = nameLabel.setTopTo_Return(con: profileCV.bottom(), by:20)
        nameLabel.setXTo(con: profileContainerView.x(), by: 0)
        
    
        altNameField.setTopTo(con: nameLabel.top(), by: -4)
        altNameField.setHeightTo(constant: 30)
        
        saveNameButton.setLeftTo(con: profileContainerView.left(), by: 4)
        saveNameButton.setYTo(con: altNameField.y(), by: 0)
        saveNameButton.addTarget(self, action: #selector(UserProfileVC.saveNameInfo(_:)), for: .touchUpInside)
        
        editNameButton.setRightTo(con: profileContainerView.right(), by: -4)
        editNameButton.setYTo(con: altNameField.y(), by: 0)
        editNameButton.addTarget(self , action: #selector(UserProfileVC.pressedShow_HideAltInfo(_:)), for: .touchUpInside)
        
        altNameField.setLeftTo(con: saveNameButton.right(), by: 4)
        altNameField.setRightTo(con: editNameButton.left(), by: -4)
        
        profile_detail.constrainInView(view: profileContainerView, top: nil, left: -10, right: 10, bottom: -75)
        profile_detail.setTopTo(con: nameLabel.bottom(), by: 10)
        
        showDetailGesture = UITapGestureRecognizer(target: self , action: #selector(UserProfileVC.showDetail(_:)))
        profile_detail.addGestureRecognizer(showDetailGesture!)
        
        chatButton.alpha = viewingOtherUser ? 1.0 : 0.0
        chatButton.setRightTo(con: profileContainerView.x(), by: -10)
        chatButton.setTopTo(con: profile_detail.bottom(), by: 10)
        chatButton.addTarget(self , action: #selector(UserProfileVC.pressChat(_:)), for: .touchUpInside)
        thurstButton.alpha = viewingOtherUser ? 1.0 : 0.0
        thurstButton.setLeftTo(con: profileContainerView.x(), by: 10)
        thurstButton.setYTo(con: chatButton.y(), by: 0)
        
        setTxtFields([altNameField])
    }
    
    func select_edit( _ sender: UIButton){
        showingEdit = !showingEdit
        editProfile(edit: showingEdit)
    }
    
    func editProfile( edit: Bool){
        let currentItemIndex = profileCV.currentItemIndex
        if edit{
            currentItemViewRect = profileCV.currentItemView!.frame
        }
        let itemSection = max((currentItemIndex/3),0)
        let itemRow = max((currentItemIndex%3),0)
        let itemPath = IndexPath(item: itemRow, section: itemSection)
        let imageItem = imagesCV.cellForItem(at: itemPath)!
        let rect = edit ? imagesCV.convert(imageItem.frame, to: profileContainerView) : currentItemViewRect
        let height = showingEdit ?  50 : self.view.frame.height*0.4
        let width = showingEdit ? 50 : self.view.frame.width*0.85
        let show: CGFloat = showingEdit ? 0.0 : 1.0
        
        let imageOffset:CGFloat = edit ? 20 : -20
        guard let image = profileCV.currentItemView else { return }
        if !edit{
            self.profileCV.alpha = 1.0
        }
       
        UIView.animate(withDuration: 0.15, animations: {
            image.frame = rect
            self.editNameButton.alpha = edit ? 1.0 : 0.0
            self.saveNameButton.alpha = 0.0
            self.altNameField.alpha = 0.0
            self.editButton.alpha = edit ? 0.3 : 1.0

        },completion: {
            _ in
            self.profileCV.alpha = show
            self.imagesCV.alpha = self.showingEdit ? 1.0 : 0.0
            
                let paths = self.imagesCV.indexPathsForVisibleItems
                for path in paths{
                    guard let cell = self.imagesCV.cellForItem(at: path) as? ProfileCell else { return }
                    let delay: Double = Double(path.item)*0.5
                    cell.showImage(delay: delay,show: self.showingEdit)
                }
            if !edit{
                self.profileCV.reloadData()
            }
        })
        
    }

    func show_hideAltInfo( showing: Bool){
        let alpha: CGFloat = showing ? 1.0 : 0.6
        let fieldAlpha: CGFloat = showing ? 0.0 : 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.altNameField.alpha = fieldAlpha
            self.editNameButton.alpha = alpha
            self.nameLabel.alpha = alpha
            self.saveNameButton.alpha = fieldAlpha
            self.view.layoutIfNeeded()
        })
    }
    
    func showSaved(){
        let newInfo = UILabel()
        newInfo.backgroundColor = UIColor.clear
        newInfo.text = altNameField.text
        newInfo.font = chivo_AppFont(size: 15, light: true)
        newInfo.frame = nameLabel.frame
        view.insertSubview(newInfo, aboveSubview: altNameField)
        UIView.animate(withDuration: 0.25, animations: {
            newInfo.frame.origin.y += 30
            newInfo.alpha = 0.0
        }) { (_) in
            newInfo.removeFromSuperview()
        }
    }
    func pressedShow_HideAltInfo(_ sender: UIButton){
        let showingInfo = sender.alpha < 1.0
        show_hideAltInfo(showing: showingInfo)
    }
    
    func saveNameInfo(_ sender: UIButton){
        guard let name = altNameField.text else {
           show_hideAltInfo(showing: true)
            return
        }
        if name != nameLabel.text{
            user?.name = name
            user?.updateCurrentUser(server: true)
            nameLabel.text = name
        }
        altNameField.text = ""
        show_hideAltInfo(showing: true)
    }
    func pressed_nav(sender: UIButton){
        showMenu(show: showingMenu)
    }
    
    func showMenu(show: Bool){
        
    }
    
    func show_menu(_ sender: UIButton){
        let menuVC = MenuVC()
            menuVC.fromPage = 0
        present(menuVC , animated: true , completion: nil)
    }
    func showDetail(_ gesture: UITapGestureRecognizer){
        if showingEdit{
            dismissGesture = nil
            let editVC = EditProfileVC()
                editVC.user = user
                editVC.delegate = self
                editVC.view.frame = self.view.frame
                addChildViewController(editVC)
                view.add(views: editVC.view)
        }
    }
    
    func pressThurst(_ sender: UIButton){
        addingConnection = true
        thurstOptionsAlert(title: "Add Connection", message: "Save this user for later?", screenColor: UIColor.black, screenAlpha: 0.8, delegate: self)
    }
    
    func pressChat(_ sender: UIButton){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        guard let userID = user?.id else {return}
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
    
    func select_addConnection(_ sender: UIButton){
        let database = AppDatabase()
            database.createConnection(for: self.user!)
    }
    
    func continueConvo(id: String){
        showScreenLoading()
        let convoRef = Database.database().reference().child("User_Convo").child(id)
        convoRef.observeSingleEvent(of: .value , with: { (snapshot) in
            print(snapshot.value)
            if let refObject = snapshot.value as? [String:Any]{
                let convo = Convo()
                convo.setValuesForKeys(refObject)
                DispatchQueue.main.async(execute: {
                    let vc = ChatVC()
                        vc.currentConvo = convo
                    self.removeScreenLoading()
                    self.present(vc, animated: true , completion: nil)
                   
                })
            }else{
                self.removeScreenLoading()
            }
        }, withCancel: nil)
    }
    
    func startConvo(){
        showScreenLoading()
        guard let uid = Auth.auth().currentUser?.uid else { return}
        guard let currentUser = self.user else {return}
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
                    self.removeScreenLoading()
                    vc.currentConvo = newConvo
                    self.present(vc, animated: true , completion: nil)
                    
                })
            }else{
                self.removeScreenLoading()
                self.thurstAlert(title: "Oops", message: "Looks like there was an error", screenColor: UIColor.black, screenAlpha: 0.8)
            }
        }
    }
    
}
extension UserProfileVC: iCarouselDelegate,iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
   
            guard let thurstUser = user else { return 1 }
            var images = thurstUser.images ?? []
                if let imageURL = thurstUser.imageURL{
                    images.insert(imageURL, at: 0)
                }
        
            return  showingEdit ? 1 : images.count > 1 ? images.count : 1
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
//        if showingDetail{
//            expandContractProfile(expand: false)
//        }
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
            switch option{
            case .fadeMin:
                return value
            case .fadeMax:
                return 0.3
            case .spacing:
                return showingEdit ? value : 1.1
            default:
                return value
            }
    }
    
    func profileImage(at index: Int)->UIView{
        var images: [String] = []
        if let userImage = user?.imageURL{
            images.append(userImage)
        }
        images.append(contentsOf: user?.images ?? [])
        let profileIV = UIImageView()
        
        if !images.isEmpty{
            let imageURL = images[index]
            profileIV.revealImageWithURL(url: imageURL)
        }else{
            profileIV.image = #imageLiteral(resourceName: "thurstLogo")
        }
        let height = showingEdit ? 50 : self.view.frame.height*0.4
        let width = showingEdit ? 50 :  self.view.frame.width*0.85
        profileIV.frame = CGRect(x: 0, y: 0, width: width, height: height)
        profileIV.contentMode = .scaleAspectFill
        profileIV.layer.masksToBounds = true
        return profileIV
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
            return profileImage(at: index)
    }
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
    }
}

extension UserProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width*0.85)*0.25, height:(self.view.frame.height*0.4)*0.3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //initiate option to getimage for editing if editing is selected. otherwise expand the image in a modal like view
    }
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        let imageURL = userImageURLs[indexPath.section][indexPath.row]
//        let notPrimary = indexPath.section != 0 && indexPath.row != 0
//        return !imageURL.isEmpty && notPrimary
//
//    }
    func imageCell(at path: IndexPath)->ProfileCell{
        if let cell = imagesCV.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: path) as? ProfileCell{
            cell.imageDelegate = self
            cell.isPrimary = false
            guard let thurstUser = user else { return ProfileCell() }
            var images: [String] = []
            if let userImage = thurstUser.imageURL{
                images.append(userImage)
            }
            images.append(contentsOf: thurstUser.images ?? [])
            
            let imagesMissing = 8 - images.count
            for i in 0...imagesMissing{
                images.append("")
            }
            var imageUrls: [[String]] = []
            for i in 0...2{
                let nxt3Images = images.prefix(through: 2)
                    images = Array(images.dropFirst(3))
                imageUrls.append(Array(nxt3Images))
            }
            userImageURLs = imageUrls
            let imageURL = imageUrls[path.section][path.item]
            if !imageURL.isEmpty{
                    cell.imageURL = imageURL
                    cell.profileImage.revealImageWithURL(url: imageURL)
                let title = NSAttributedString(string: "X", attributes: [NSFontAttributeName: appFont(size: 8),NSForegroundColorAttributeName: UIColor.white])
                cell.deleteButton.setAttributedTitle(title , for: .normal)
            }else{
                cell.profileImage.image = #imageLiteral(resourceName: "thurstLogo")
                let title = NSAttributedString(string: "+", attributes: [NSFontAttributeName: chivo_AppFont(size: 12, light: true),NSForegroundColorAttributeName: UIColor.white])
                cell.deleteButton.setAttributedTitle(title , for: .normal)
            }
                cell.isPrimary = path.section == 0 && path.item == 0
            return cell
        }
        return ProfileCell()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return imageCell(at: indexPath)
    }
    
}

extension UserProfileVC: EditProfileDelegate{
    func saveDetails(sex: String?,rel: String?,gender: String?,bday: String?) {
        let sexuality = sex ?? user?.sexuality
        let relationship = rel ?? user?.relationshipStatus
        let genderStatus = gender ?? user?.gender
        let birthday = bday ?? user?.bday
        user?.sexuality = sexuality
        user?.relationshipStatus = relationship
        user?.gender = genderStatus
        user?.bday = birthday
        user?.updateCurrentUser(server: true)
        profile_detail.thurstUser = user
        profile_detail.show_user_data()
        editProfile(edit: false)
    }
}

extension UserProfileVC: ImageSelectDelegate{
    func addedImage(url: String, for key: String,size:CGSize) {
        var itemIndexToUpdate = 0
        if let userImage = user?.imageURL{
            if let urls = user?.imageURLs{
                user?.imageURLs?.updateValue(url , forKey: key)
                itemIndexToUpdate = user!.images!.count
            }else{
                user?.imageURLs = [key:url]
                itemIndexToUpdate = 1
            }
        }else{
            user?.imageURL = url
        }
        if let itemViewToUpdate = profileCV.itemView(at: itemIndexToUpdate) as? UIImageView{
            itemViewToUpdate.loadImageWithURL(url: url)
        }
        user?.updateCurrentUser(server: true)
        imagesCV.reloadData()
    }
}
extension UserProfileVC: ProfileImageDelegate{
    func showScreenLoading(){
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        spinner.color = UIColor.black
        spinner.alpha = 0.0
        spinner.tag = 102
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x:(self.view.frame.width/2)-50, y: (view.frame.height/2)-50, width: 100, height: 100)
        let screen = UIView()
        screen.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        screen.frame = self.view.frame
        screen.alpha = 0.0
        screen.tag = 101
        self.view.add(views: screen,spinner)
        UIView.animate(withDuration: 0.5, animations: {
            screen.alpha = 1.0
            spinner.alpha = 1.0
        }) { (_) in
            spinner.startAnimating()
        }
    }
    func removeScreenLoading(){
        if let screen = view.viewWithTag(101){
            if let spinner = view.viewWithTag(102) as? UIActivityIndicatorView{
                spinner.stopAnimating()
                UIView.animate(withDuration: 0.25, animations: {
                    spinner.alpha = 0.0
                }, completion: { _ in
                    spinner.removeFromSuperview()
                })
            }
            UIView.animate(withDuration: 0.5, animations: {
                screen.alpha = 0.0
            }, completion: { (_) in
                screen.removeFromSuperview()
            })
        }
    }
    func removeImage(image: String){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            guard let uid = Auth.auth().currentUser?.uid else { return }
            if let userImage = user?.imageURL{
                if image == userImage{
                       showScreenLoading()
                    let userImageRef = Database.database().reference().child("Users").child(uid).child("imageURL")
                        userImageRef.removeValue()
                    user?.imageURL = nil
                    user?.setCurrentUser()
                    self.imagesCV.reloadData()
                    //self.profileCV.reloadData()
                    DispatchQueue.main.async(execute: {
                        self.removeScreenLoading()
                    })
                    
                    return
                }
                
            }
                guard let images = user?.imageURLs else {return}
                showScreenLoading()
                let values = images.map({key,value in return value as! String})
                let index = values.index(of: image)?.advanced(by: 0)
                let imageKeys = images.map({key,value in return key})
                let imageKey = imageKeys[index!]
            
                let imageIndex = images.index(forKey: imageKey)
                user?.imageURLs?.remove(at: imageIndex!)
                user?.setCurrentUser()
            
                let userImageRef = Database.database().reference().child(FirebaseUserPath).child(uid).child("imageURLs").child(imageKey)
                userImageRef.removeValue()
            
                let storageRef = Storage.storage().reference().child("Images").child("Profile_Images").child(uid).child(imageKey)
                storageRef.delete { (error) in
                    if error == nil{
                        self.imagesCV.reloadData()
                        self.profileCV.reloadData()
                        self.removeScreenLoading()
                    }else{
                        self.thurstAlert(title: "Error!", message: "There seems to be problem...", screenColor: UIColor.black, screenAlpha: 0.8)
                        self.removeScreenLoading()
                    }
                }
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
    }
    
    func deleteImage(image: String) {
            deletingImage = image
            thurstOptionsAlert(title: "Delete Image", message: "Sure You Wanna Delete this Beautiful Image?", screenColor: UIColor.black, screenAlpha: 0.8, delegate: self)
       
    }
    
    func insertImage() {
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            let imageSelect = ImageSelectVC()
                imageSelect.view.frame = self.view.frame
                imageSelect.delegate = self
                imageSelect.purpose = .Profile
            self.addChildViewController(imageSelect)
            self.view.add(views: imageSelect.view)
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
    }
    
}
extension UserProfileVC: ThurstOptionsDelegate{
    func okResponse(){
        if let image = deletingImage{
            removeImage(image: image)
            deletingImage = nil
        }
        if addingConnection{
            let database = AppDatabase()
            guard let currentUser = self.user else {return}
            database.createConnection(for: currentUser)
            thurstAlert(title: "Hooray", message: "Connection Made!", screenColor: UIColor.black, screenAlpha: 0.8)
        }
        addingConnection = !addingConnection
    }
    
    func cancelResponse(){
        if addingConnection{
            addingConnection = !addingConnection
        }
    }
}

