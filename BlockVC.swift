//
//  BlockVC.swift
//  Thurst
//
//  Created by Blake Rogers on 2/10/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class BlockVC: UIViewController {
    // MARK: - Data
    var accounts: [String]?{
        didSet{
           blockedCV.reloadData()
        }
    }
    // MARK: - UIElements
    var bannerHeightCon = NSLayoutConstraint()
    
    let bannerView: UIView = {
        let v = UIView()
        v.backgroundColor = light_pink
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
        //btn.layer.cornerRadius = 0.0
        //btn.layer.masksToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let thurstLabel: UILabel = {
        let atts = [NSFontAttributeName: chivo_AppFont(size: 12, light: true),
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
    var headingTopCon = NSLayoutConstraint()
    let headingLabel: UILabel = {
        let lab = UILabel()
        lab.textAlignment = .left
        lab.text = "BLOCKED ACCOUNTS"
        lab.alpha = 0.0
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.font = chivo_AppFont(size: 18, light: true)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let blockedCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 400)
        
        let frame = CGRect(x: 0, y: 0, width:300, height: 500)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = false
        return cv
    }()
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        blockedCV.delegate = self
        blockedCV.dataSource = self
        blockedCV.register(BlockCell.self , forCellWithReuseIdentifier: "BlockCell")
        blockedCV.register(BlockSectionView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BlockSectionView")
        setViews()
        getBlockedUsers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setViews(){
        view.backgroundColor = UIColor.white
        view.add(views: blockedCV, bannerView)
        
        bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
        bannerHeightCon = bannerView.setHeightTo_Return(constant: 85)
        bannerView.add(views: navButton,thurstLabel,headingLabel)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(BlockVC.show_menu(_:)), for: .touchUpInside)
        
        headingTopCon = headingLabel.setTopTo_Return(con: bannerView.bottom(), by: 0)
        headingLabel.setXTo(con: bannerView.x(), by: 0)
        
        blockedCV.constrainInView(view: self.view , top: 65 , left: nil, right: nil, bottom: 0)
        blockedCV.setWidthTo(constant: self.view.frame.width*0.65)
        blockedCV.setXTo(con: self.view.x(), by: 0)
        
        let cvShadow = UIView()
        cvShadow.translatesAutoresizingMaskIntoConstraints = false
        cvShadow.backgroundColor = UIColor.white
        cvShadow.layer.shadowColor = UIColor.black.cgColor
        cvShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cvShadow.layer.shadowRadius = 10.0
        cvShadow.layer.shadowOpacity = 0.2
        view.insertSubview(cvShadow , belowSubview: blockedCV)
        cvShadow.constrainWithMultiplier(view: blockedCV , width: 1.1, height: 1.0)
    }
    
    func show_menu(_ sender: UIButton){
        let menuVC = MenuVC()
        menuVC.fromPage = 2
        present(menuVC , animated: true , completion: nil)
    }
    
    func getBlockedUsers(){
        guard let user = ThurstUser().currentUser() else { return}
        if let blockedList = user.block_list{
            accounts = user.blocked_users
        }else{
            //some visual about not having a list
        }
    }
    
}
extension BlockVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width*0.65, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width*0.65, height: section == 0 ? 70 : 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return accounts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
        guard let blockedAccounts = accounts else { return}
        let account = blockedAccounts[indexPath.item]
        let userRef = Database.database().reference().child("Users").child(account)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let userObject = snapshot.value as? [String:Any]{
                let thurstUser = ThurstUser()
                thurstUser.setValuesForKeys(userObject)
                let vc = UserProfileVC()
                vc.viewingOtherUser = true
                vc.user = thurstUser
                DispatchQueue.main.async(execute: {
                    self.present(vc, animated: true, completion: nil)
                })
            }
        }, withCancel: nil)
        
    }
    func blockCell(at path: IndexPath)->BlockCell{
        guard let blockedAccounts = accounts else { return BlockCell()}
        if let cell = blockedCV.dequeueReusableCell(withReuseIdentifier: "BlockCell", for: path) as? BlockCell{
            cell.delegate = self
            let account = blockedAccounts[path.item]
            let userRef = Database.database().reference().child("Users").child(account)
            userRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if let userObject = snapshot.value as? [String:Any]{
                    let thurstUser = ThurstUser()
                    thurstUser.setValuesForKeys(userObject)
                   cell.account_id = thurstUser.id
                    DispatchQueue.main.async(execute: {
                        if let userImage = thurstUser.imageURL{
                            cell.blockImage.loadImageWithURL(url: userImage)
                        }else{
                            cell.blockImage.image = #imageLiteral(resourceName: "thurstLogo")
                        }
                        cell.nameLabel.text = thurstUser.name
                    })
                    
                }
            }, withCancel: nil)
            
            
            return cell
        }
        return BlockCell()
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "BlockSectionView", for: indexPath) as? BlockSectionView{
            return view
        }
        
        
        return MessagesSectionView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return blockCell(at: indexPath)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height:CGFloat = 50 //half of height of section header
        let offset = scrollView.contentOffset.y
        print(offset)
        let shouldLiftHeading =  offset > height
        if shouldLiftHeading && headingTopCon.constant == 0{
            UIView.animate(withDuration: 0.25, animations: {
                self.headingTopCon.constant = -50
                self.headingLabel.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }
        let shouldLowerHeading = offset < height
        if shouldLowerHeading && headingTopCon.constant < 0{
            UIView.animate(withDuration: 0.25, animations: {
                self.headingTopCon.constant = 0
                self.headingLabel.alpha = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
}
class BlockSectionView: UICollectionReusableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        add(views: sectionLabel)
        sectionLabel.setXTo(con: self.x(), by: 0)
        sectionLabel.setWidthTo(constant: self.frame.width)
        sectionLabel.setTopTo(con: self.top(), by: 10)
        
        
    }
    var sectionLabel: UILabel = {
        let label = UILabel()
        label.text = "BLOCKED ACCOUNTS"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = appFont(size: 35)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}

extension BlockVC: BlockDelegate{
    func unblockUser(id: String){
        let accountsIndex = accounts!.index(of: id)
        let user = ThurstUser().currentUser()
        if let index = user?.block_list?.index(forKey: id){
            user?.block_list?.remove(at: index)
            user?.updateCurrentUser(server: true)
        }
        let path = IndexPath(item: accountsIndex!, section: 0)
        blockedCV.deleteItems(at: [path])
       
    }
}

