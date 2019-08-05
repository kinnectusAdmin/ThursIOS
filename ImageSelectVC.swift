//
//  ImageSelectVC.swift
//  Thurst
//
//  Created by Blake Rogers on 2/7/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
import Photos
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

protocol ImageSelectDelegate{
    func addedImage(url: String,for key: String,size: CGSize)
}

class ImageSelectVC: UIViewController {
        // MARK: - Variables
        var results: PHFetchResult<PHAsset>?{
            didSet{
                userPhotosCV.reloadData()
            }
        }
    
        enum Purpose: String{
            case Profile
            case Chat
        }
    
        var dismissGesture: UITapGestureRecognizer?
        var imageToAdd: UIImage?
        var showingImage: Bool = false //Determine whether user has expanded a view of the carousel
        var delegate: ImageSelectDelegate?
        var purpose: Purpose?
   
        // MARK: - UIElements

        let userPhotosCV: iCarousel = {
            let car = iCarousel()
            car.type = .linear
            car.isPagingEnabled = true
            car.translatesAutoresizingMaskIntoConstraints = false
            return car
        }()
    
        let screenView: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.white.withAlphaComponent(0.99)
            v.addShadow(10, dy: 10, color: UIColor.black, radius: 10.0, opacity: 0.8)
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
    
        let addButton : UIButton = {
            let button = UIButton()
            let title = NSAttributedString(string: "ADD IMAGE", attributes: [NSFontAttributeName: chivo_AppFont(size: 24, light: true),NSForegroundColorAttributeName: UIColor.black])
            //button.setImage( , for:.normal)
            button.setAttributedTitle(title, for: .normal)
            button.adjustsImageWhenHighlighted = false
            button.backgroundColor = UIColor.white
            button.addShadow(10, dy: 10, color: UIColor.black, radius: 10.0, opacity: 0.8)
            return button
        }()
        let cancelButton : UIButton = {
            let button = UIButton()
            button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
            button.layer.cornerRadius = 10.0
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        // MARK: - Functions
    
        override func viewDidLoad() {
            super.viewDidLoad()
            userPhotosCV.delegate = self
            userPhotosCV.dataSource = self
            setViews()
            getImage()
            // Do any additional setup after loading the view.
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
    
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            UIView.animate(withDuration: 0.5) {
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            }
            dismissGesture = UITapGestureRecognizer(target: self , action: #selector(EditProfileVC.dismissEditProfile(_:)))
            
            dismissView.addGestureRecognizer(dismissGesture!)
        }
        
        func setViews(){
            
            view.add(views:screenView,dismissView,cancelButton)
            view.backgroundColor = UIColor.clear
            dismissView.constrainWithMultiplier(view: self.view , width: 1.0, height: 1.0)
           
            screenView.setYTo(con: self.view.y(), by: 0)
            screenView.setWidth_Height(width: self.view.frame.width , height: 250)
            
            cancelButton.constrainInView(view: self.screenView , top: 10, left: 10, right: nil, bottom: nil)
            cancelButton.setWidth_Height(width: 15, height: 15)
            cancelButton.addTarget(self , action: #selector(ImageSelectVC.dismissEditProfile(_:)), for: .touchUpInside)
        }
    
        let dismissView: UIView = {
            let v = UIView()
            v.backgroundColor = UIColor.white.withAlphaComponent(0.1)
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        func dismiss(){
            
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.alpha = 0.0
                    self.userPhotosCV.frame.origin.y += 200
                }) { (_) in
                    self.removeFromParentViewController()
                    self.view.removeFromSuperview()
                }
           
        }
        func dismissEditProfile(_ gesture: UITapGestureRecognizer){
            dismiss()
        }
        func showAddButton(){
            addButton.frame = CGRect(x: 0, y: self.view.frame.height, width: 250, height: 100)
            addButton.center.x = self.view.center.x
            addButton.addTarget(self , action: #selector(ImageSelectVC.addImage(_:)), for: .touchUpInside)
            view.add(views: addButton)
            UIView.animate(withDuration: 0.5) {
                self.addButton.frame.origin.y -= 125
            }
        }
    func hideAddButton(){
        UIView.animate(withDuration: 0.4, animations:{
            self.addButton.frame.origin.y += 150
        }) { _ in
            self.addButton.removeFromSuperview()
        }
    }
        func addImage(_ sender: UIButton){
            
            sender.isEnabled = false
            guard let image = imageToAdd else { return }
            switch purpose!{
            case .Profile:
                selectedImage(image: image)
            case .Chat:
                selectedChatImage(image: image)
            }
        }
    }


extension ImageSelectVC: iCarouselDelegate,iCarouselDataSource{
    func carousel(_ carousel: iCarousel, shouldSelectItemAt index: Int) -> Bool {
        return index == carousel.currentItemIndex ? true : !showingImage
    }
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        showingImage = !showingImage
        if let view = carousel.itemView(at: index) as? UIImageView{
            view.tag = 69
            carousel.bringSubview(toFront: view)
            imageToAdd = showingImage ? view.image : nil
            let xscale:CGFloat = showingImage ? 2.5 : 1.0
            let yscale:CGFloat = showingImage ? 2.5 : 1.0
            let transform = CGAffineTransform(scaleX: xscale, y: yscale)
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [], animations: {
                view.transform = transform
            }, completion: nil)
            showingImage ? showAddButton() : hideAddButton()
        }
        
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
            return results?.count ?? 0
    }
    
    func carouselWillBeginDragging(_ carousel: iCarousel) {
        //        if showingDetail{
        //            expandContractProfile(expand: false)
        //        }
    
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
            switch option{
            case .spacing:
                return 1.1
            default:
                return value
            }
    }

    func userPhotos(at index: Int)->UIView{
        guard let photos = results else { return UIView()}
        let imageAsset = photos[index]
        let imageSize = CGSize(width: 150, height: 150)
        let manager = PHImageManager.default()
        var iv = UIImageView()
        iv.frame = CGRect(origin: CGPoint.zero , size: imageSize)
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 10.0
        iv.layer.masksToBounds = true
        manager.requestImage(for: imageAsset, targetSize: imageSize, contentMode: .aspectFill, options: nil) { (image, nil) in
            if let photo = image{
                iv.image = photo
            }
        }
        return iv.image != nil ? iv : UIView()
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
       return userPhotos(at:index)
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
    }
}
extension ImageSelectVC{
    func photoHandler(_ action: UIAlertAction!){
        
        if let appSettings = URL(string: UIApplicationOpenSettingsURLString){
            UIApplication.shared.openURL(appSettings)
        }
        
    }

    func getImage(){
        let status = PHPhotoLibrary.authorizationStatus()
        switch status{
        case .authorized:
            let imageResults = PHAsset.fetchAssets(with: nil)
            guard imageResults.count > 0 else { return}
            results = imageResults
            userPhotosCV.frame = CGRect(x: 0, y: (self.view.frame.height/2) + 100, width: self.view.frame.width, height: 200)
            
            view.add(views: userPhotosCV)
            UIView.animate(withDuration: 0.25, animations: {
                self.userPhotosCV.frame.origin.y -= 200
            })
        case .denied,.restricted,.notDetermined:
            PHPhotoLibrary.requestAuthorization({ (authStatus) in
                switch authStatus{
                case .authorized:
                    self.getImage()
                case .denied,.restricted,.notDetermined:
                    let alertController = UIAlertController(title: "Settings", message: "Looks like we don't have acces to Photos. Enable access for Thurst to continue.", preferredStyle: .alert)
                    let action = UIAlertAction(title: "Settings", style: .default, handler: self.photoHandler)
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertController.addAction(action)
                    alertController.addAction(cancel)
                    self.present(alertController, animated: true, completion: nil)
                }
            })
            
            break
        }
       
       
    }
    
    func selectedImage(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        //add image to slot selected
        
        let imageData = UIImagePNGRepresentation(image)
        let imageID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("Images").child("Profile_Images").child(uid).child(imageID)
        let width = image.size.width
        let height = image.size.height
        
        storageRef.putData(imageData!, metadata: nil, completion: {
            metaData, error in
            if error != nil{
                self.dismiss()
                return
            }
            if let url = metaData?.downloadURL()?.path{
                print(url)
            }
            if let url = metaData?.downloadURL()?.absoluteString{
                //                    let width = NSNumber(value:Float(imageToSend.size.width))
                //                    let height = NSNumber(value: Float(imageToSend.size.height))
                //                    let timeStamp = String(Date().timeIntervalSince1970)
                
              
                DispatchQueue.main.async {
                    self.delegate?.addedImage(url:url , for: imageID,size: CGSize(width: width, height: height))
                    self.dismiss()
                }
            }
        })
    }
    func selectedChatImage(image: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else {return }
        
        //add image to slot selected
        
        let imageData = UIImagePNGRepresentation(image)
        let imageID = UUID().uuidString
        let storageRef = Storage.storage().reference().child("Images").child("Chat_Images").child(uid).child(imageID)
        let width = image.size.width
        let height = image.size.height
        
        storageRef.putData(imageData!, metadata: nil, completion: {
            metaData, error in
            if error != nil{
                self.dismiss()
                return
            }
            if let url = metaData?.downloadURL()?.path{
                print(url)
            }
            
            if let url = metaData?.downloadURL()?.absoluteString{
                //                    let width = NSNumber(value:Float(imageToSend.size.width))
                //                    let height = NSNumber(value: Float(imageToSend.size.height))
                //                    let timeStamp = String(Date().timeIntervalSince1970)
                
                
                DispatchQueue.main.async {
                    self.delegate?.addedImage(url:url , for: imageID,size:CGSize(width: width, height: height))
                    self.dismiss()
                }
                
            }
        })
    }
    
}
