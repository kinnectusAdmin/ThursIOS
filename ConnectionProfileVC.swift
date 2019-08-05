//
//  ConnectionProfileVC.swift
//  Thurst
//
//  Created by Blake Rogers on 11/7/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class ConnectionProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        profileCV.delegate = self
        profileCV.dataSource = self
        expandContractProfile(expand: true)
        imagesCV.delegate = self
        imagesCV.dataSource = self
        imagesCV.register(ConnectionProfileCell.self , forCellWithReuseIdentifier: "ConnectionProfileCell")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let lightBlue = createColor(153, green: 255, blue: 255)
    
    func setViews(){
        view.backgroundColor = lightBlue
        view.add(views: bannerView,exploreLabel,profileContainerView)
        
        bannerView.constrainInView(view: self.view , top: 0, left: -20 , right: 20, bottom: nil)
        bannerHeightCon = bannerView.setHeightTo_Return(constant: 65)
        bannerView.add(views: navButton,thurstLabel)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(ConnectionProfileVC.show_menu(_:)), for: .touchUpInside)
        
        exploreLabel.setXTo(con: self.view.x(), by: 0)
        exploreLabel.setBottomTo(con: self.bannerView.bottom(), by: -10)
        
        profileContainerView.setXTo(con: self.view.x(), by: 0)
        profileContainerView.setTopTo(con: exploreLabel.bottom(), by: 20)
        profileContainerView.setWidthTo(constant: self.view.frame.width*0.75)
        containerHeightCon = profileContainerView.setHeightTo_Return(constant: self.view.frame.height*0.6)
        
        profileContainerView.add(views: nameLabel,profileShadow,profile_detail,imagesCV,profileCV,thurstButton,chatButton)
        
        imagesCV.setTopTo(con: profileShadow.top(), by: 0)
        imagesCV.setXTo(con: profileContainerView.x(), by: 0)
        imagesCV.setHeightTo(constant: self.view.frame.height*0.4)
        imagesCV.setWidthTo(constant: self.view.frame.width*0.84)
        
        profileCV.setTopTo(con: profileContainerView.top(), by: 20)
        profileCV.setXTo(con: profileContainerView.x(), by: 0)
        profileCV.setHeightTo(constant: self.view.frame.height*0.4)
        profileCV.setWidthTo(constant: self.view.frame.width*0.85)
        
        profileShadow.setLeftTo(con: profileCV.left(), by: 0)
        profileShadow.setBottomTo(con: profileCV.bottom(), by: 0)
        profileShadow.setTopTo(con: profileCV.top(), by: 10)
        profileShadow.setRightTo(con: profileCV.right(), by: 0)
        
        nameTopCon = nameLabel.setTopTo_Return(con: profileCV.bottom(), by: -15)
        nameLabel.setXTo(con: profileContainerView.x(), by: 0)
        
        profile_detail.constrainInView(view: profileContainerView, top: nil, left: -10, right: 10, bottom: -75)
        profile_detail.setHeightTo(constant: 160)
        
        chatButton.setRightTo(con: profileContainerView.x(), by: -10)
        chatButton.setTopTo(con: profile_detail.bottom(), by: 10)
        
        thurstButton.setLeftTo(con: profileContainerView.x(), by: 10)
        thurstButton.setYTo(con: chatButton.y(), by: 0)
    }
    
    var profileWidthCon = NSLayoutConstraint()
    var profileHeightCon = NSLayoutConstraint()
    
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
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    var pullProfileGesture: UIPanGestureRecognizer?
    var bannerHeightCon = NSLayoutConstraint()
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
        let atts = [NSFontAttributeName: chivo_AppFont(size: 10, light: true),
                    NSForegroundColorAttributeName: UIColor.white]
        let attTxt = NSAttributedString(string: "THURST", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .left
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
 


    var showingDetail: Bool = false
    
    func expandProfile(_ gesture: UIPanGestureRecognizer){
        let yTrans = gesture.translation(in: profileContainerView).y
        let current = self.view.frame.height*0.6
        let changePoint = current/3
        var change: CGFloat = yTrans
        let direction:CGFloat = gesture.velocity(in: profileContainerView).y > 0 ? 1.0 : -1.0
        
        switch gesture.state{
        case .changed:
            let maxHeight = direction == 1.0 ? self.view.frame.height*0.9 : self.view.frame.height*0.6
            change = current + CGFloat(yTrans)
            containerHeightCon.constant += yTrans/10
            let percent_change = (change*direction/maxHeight)
            profileImage.layer.borderWidth = min(5.0, 10.0*percent_change)
            nameLabel.alpha += percent_change/10
            nameTopCon.constant =  min(15,20*percent_change)
            swipeLabel.alpha -= percent_change/10
            profile_detail.alpha += percent_change/40
            chatButton.alpha += percent_change/40
            thurstButton.alpha += percent_change/40
            
            var bannerShadowOffset = bannerView.layer.shadowOffset.height
            bannerView.layer.shadowOffset.height = bannerShadowOffset < -4.0 ? -3.0 : bannerShadowOffset > 10.0 ? 9.0 : bannerShadowOffset
            let shouldAdjustBannerShadow = bannerShadowOffset > -4.0 && bannerShadowOffset < 10.0
            //print("offset = \(bannerShadowOffset)")
            bannerView.layer.shadowOffset.height +=  shouldAdjustBannerShadow ? percent_change/2 : 0
            
            var imgShadowOffset = profileShadow.layer.shadowOffset.height
            profileShadow.layer.shadowOffset.height = imgShadowOffset < -4.0 ? -3.0 : imgShadowOffset > 10.0 ? 9.0 : imgShadowOffset
            let shouldAdjustImgShadow = imgShadowOffset > -4.0 && imgShadowOffset < 10.0
            print("offset = \(imgShadowOffset)")
            profileShadow.layer.shadowOffset.height +=  shouldAdjustImgShadow ? percent_change/2 : 0
        case .ended:
            let shouldExpand = change > changePoint
            // print("should expand: \(shouldExpand) because change is \(change)")
            expandContractProfile(expand: shouldExpand)
            break
        default: break
        }
    }
    
    func expandContractProfile(expand: Bool){
        
        let height = expand ? self.view.frame.height * 0.9 : self.view.frame.height * 0.6
        let nameTop:CGFloat = expand ? 15 : -15
        let nameAlpha:CGFloat = expand ? 1.0 : 0.0
        let swipeAlpha: CGFloat = expand ? 0.0 : 1.0
        print("swipe alpha: \(swipeAlpha)")
        let shadow_height: CGFloat = expand ? 10.0 : -3.0
        let shadow_anim = CABasicAnimation(keyPath: "shadowOffset.height")
        shadow_anim.toValue = shadow_height
        shadow_anim.duration = 0.5
        profileShadow.layer.shadowOffset.height = shadow_height
        bannerView.layer.shadowOffset.height = shadow_height
        profileShadow.layer.add(shadow_anim, forKey: nil)
        bannerView.layer.add(shadow_anim, forKey: nil)
        
        expand ? profile_detail.show_user_data() : profile_detail.hide_user_data()
        UIView.animate(withDuration: 0.5, delay: 0.0,options: [], animations: {
            
            self.containerHeightCon.constant = height
            self.nameTopCon.constant = nameTop
            self.nameLabel.alpha = nameAlpha
            self.swipeLabel.alpha = swipeAlpha
            self.profile_detail.alpha = nameAlpha
            self.chatButton.alpha = nameAlpha
            self.thurstButton.alpha = nameAlpha
            self.view.layoutIfNeeded()
            
        }, completion:{ _ in
            self.showingDetail = expand
        })
    }
    
    let exploreLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 18, light: true),
                    NSForegroundColorAttributeName: UIColor.black]
        let attTxt = NSAttributedString(string: "PROFILE", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    var showingMenu = false;
    
    func pressed_nav(sender: UIButton){
        showMenu(show: showingMenu)
    }
    
    func showMenu(show: Bool){
        
    }
    
    var containerHeightCon = NSLayoutConstraint()
    let profileContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let profile_detail: Profile_DetailView = {
        let v = Profile_DetailView()
        v.alpha = 0
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
        return shadowView
    }()
    
    let profileImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "profile1")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius  = 0
        iv.alpha = 0.0
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.masksToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    var nameTopCon = NSLayoutConstraint()
    let nameLabel: UILabel = {
        
        let atts = [NSFontAttributeName: chivo_AppFont(size: 18, light: true),
                    NSForegroundColorAttributeName: UIColor.lightGray]
        let attTxt = NSAttributedString(string: "Alejandro Delayna", attributes: atts)
        let lab = UILabel()
        lab.textAlignment = .center
        lab.attributedText = attTxt
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
        btn.setImage(#imageLiteral(resourceName: "MailButton"), for: .normal)
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
    
    func show_menu(_ sender: UIButton){
        let menuVC = MenuVC()
        menuVC.fromPage = 0
        present(menuVC , animated: true , completion: nil)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ConnectionProfileVC: iCarouselDelegate,iCarouselDataSource{
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 5
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
            return 1.1
        default:
            return value
        }
    }
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let profileIV = UIImageView(image: #imageLiteral(resourceName: "profile1"))
        let height = self.view.frame.height*0.4
        let width = self.view.frame.width*0.85
        profileIV.frame = CGRect(x: 0, y: 0, width: width, height: height)
        profileIV.contentMode = .scaleAspectFill
        profileIV.layer.masksToBounds = true
        return profileIV
    }
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
    }
}
extension ConnectionProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width*0.85)/4, height:(self.view.frame.height*0.35)/4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func imageCell(at path: IndexPath)->ConnectionProfileCell{
        if let cell = imagesCV.dequeueReusableCell(withReuseIdentifier: "ConnectionProfileCell", for: path) as? ConnectionProfileCell{
            
            return cell
        }
        return ConnectionProfileCell()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return imageCell(at: indexPath)
    }
    
}

