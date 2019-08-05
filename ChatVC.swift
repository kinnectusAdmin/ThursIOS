//
//  ChatVC.swift
//  ThurstApp
//
//  Created by Akosua Acheamponmaa on 7/4/17.
//  Copyright © 2017 Kinnectus. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Photos
class ChatVC: UIViewController {
    // MARK: - Data
    var blockingUser: Bool = false
    var reportingUser: Bool = false
    var showingOptions: Bool = false
    var dismissGesture: UITapGestureRecognizer?
    var chatHeightCon = NSLayoutConstraint()
    var chatBottomCon = NSLayoutConstraint()
    var imageToSend: UIImage?
    var dateSections: [MessageDateSection]?
    var imagePicker = UIImagePickerController()
    
    var currentConvo: Convo?{
        didSet{
            currentConvo?.convoDelegate = self
            conversants = currentConvo?.conversants
            currentConvo?.observeConvo()
            sortMessagesByDate()
            convoCV.reloadData()
        }
    }
    
    var conversants: [String]?{
        didSet{
            let userReference = Database.database().reference().child("Users")
            guard let userReferences = conversants?.map({ ref in
                return userReference.child(ref)
            }) else{
                return
            }
            var chatters = [ThurstUser]()
            for ref in userReferences{
                ref.observeSingleEvent(of: .value, with: {userSnap in
                    
                    guard let userObject = userSnap.value as? [String: AnyObject] else{
                        return
                    }
                    
                    let chatter = ThurstUser()
                    chatter.setValuesForKeys(userObject)
                    chatters.append(chatter)
                    
                    if chatters.count == userReferences.count{//Both users have been fetched
                        self.currentMessageConversant_s = chatters
                    }
                })
            }
        }
    }
    var conversant: ThurstUser?{
        didSet{
            if let imageURL = conversant?.imageURL{
                chateeImage.revealImageWithURL(url: imageURL)
            }else{
                chateeImage.image = #imageLiteral(resourceName: "thurstLogo")
            }
            chateeNameLabel.text = conversant?.name ?? ""
        }
    }
    var currentMessageConversant_s = [ThurstUser](){
        didSet{
            // conversant =
            if let otherUser = currentMessageConversant_s.filter({$0.id != Auth.auth().currentUser?.uid}).first{
                conversant = otherUser
            }
            
        }
    }
   // MARK: - UIElements
   
    var chateeGradient = CAGradientLayer()
    var chatImageHeightCon = NSLayoutConstraint()
    var viewUserGesture: UITapGestureRecognizer?
    let backButton: UIButton = {
        let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "backButtonWhite"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let optionsButton: UIButton = {
        let btn = UIButton()
            btn.setImage(#imageLiteral(resourceName: "settingsButtonWhite"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
 
    let chateeImage: UIImageView = {
        let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.layer.cornerRadius  = 0
            iv.layer.masksToBounds = true
            iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    let chateeNameLabel: UILabel = {
        let lab = UILabel()
            lab.textColor = UIColor.white
            lab.font = chivo_AppFont(size: 30.0, light: true)
            lab.textAlignment = .center
            lab.isUserInteractionEnabled = true
            lab.backgroundColor = UIColor.clear
            lab.layer.cornerRadius = 0.0
            lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    
    let convoCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: 300, height: 400)
        let frame = CGRect(x: 0, y: 0, width: 300, height: 500)
        let cv = UICollectionView(frame: frame , collectionViewLayout: layout)
            cv.backgroundColor = UIColor.clear
            cv.showsVerticalScrollIndicator = false
            cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let chatBoxView: ChatView = {
        let v = ChatView()
            v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
 
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        convoCV.delegate = self
        convoCV.dataSource = self
        convoCV.register(ChatDetailCell.self , forCellWithReuseIdentifier: "ChatDetailCell")
        convoCV.register(ChatImageCell.self , forCellWithReuseIdentifier: "ChatImageCell")
        convoCV.register(SectionView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionView")
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setKeyBoardNotification()
    }
    
    
    func setViews(){
        view.backgroundColor = UIColor.white
        view.add(views: chateeImage,backButton, chateeNameLabel,optionsButton)
        
        backButton.constrainInView(view: self.view , top: 10, left: 8, right: nil, bottom: nil)
        backButton.addTarget(self , action: #selector(ChatVC.goBackHome(_:)), for: .touchUpInside)
        
        chateeNameLabel.setTopTo(con: self.view.top(), by: 30)
        chateeNameLabel.setXTo(con: self.view.x(), by: 0)
        viewUserGesture = UITapGestureRecognizer(target: self , action: #selector(ChatVC.select_user(_:)))
        chateeNameLabel.addGestureRecognizer(viewUserGesture!)
        
        optionsButton.constrainInView(view: self.view , top: 10, left: nil, right: -8, bottom: nil)
        optionsButton.addTarget(self , action: #selector(ChatVC.select_option(_:)), for: .touchUpInside)
        
        chateeImage.constrainInView(view: self.view , top: -20, left: -20, right: 20, bottom: nil)
        chatImageHeightCon = chateeImage.setHeightTo_Return(constant: 300)
        
        let colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        chateeGradient = self.view.addGradientScreen_Return(frame: CGRect(x:0,y:0,width:self.view.frame.width, height:300), start: CGPoint(x:0,y:0), end: CGPoint(x:0,y:1), locations: [0.3,1.0], colors: colors)
        
        view.add(views: convoCV, chatBoxView)
        convoCV.setTopTo(con: chateeImage.bottom(), by: 8)
        convoCV.constrainInView(view: self.view , top: nil, left: 0, right: 0, bottom: -50)
        
        chatBoxView.constrainInView(view: self.view , top: nil, left: 0, right: 0, bottom: nil)
        chatHeightCon = chatBoxView.setHeightTo_Return(constant: 50)
        chatBottomCon = chatBoxView.setBottomTo_Return(con: self.view.bottom(), by: 0)
        chatBoxView.delegate = self
        
    }
    
    func goBackHome(_ sender: UIButton){
        self.dismiss(animated: true , completion: nil)
    }
    
    func dismissChat(_ gesture: UITapGestureRecognizer){
        if let screen = self.view.viewWithTag(98){
            screen.removeGestureRecognizer(dismissGesture!)
            screen.removeFromSuperview()
            chatBoxView.chatTextView.resignFirstResponder()
            chatBoxView.resetBeginLabel()
        }
    }
    func select_option(_ sender: UIButton){
        showingOptions = !showingOptions
        if showingOptions{
            let x = optionsButton.frame.origin.x - 150
            let y = optionsButton.frame.maxY + 10
            var optionView = OptionsView()
            optionView.frame = CGRect(x: x, y: y, width: 150, height: 75)
            optionView.delegate = self
            optionView.tag = 299
            
            view.add(views: optionView)
            UIView.animate(withDuration: 0.25, animations: {
                optionView.alpha = 1.0
            }, completion: nil)
            
        }else{
            
            if let optView = view.viewWithTag(299) as? OptionsView{
                optView.dismiss()
            }
        }
    }
    func select_user(_ sender: UITapGestureRecognizer){
        viewUser()
    }
    func viewUser(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let conversant = currentMessageConversant_s.filter { $0.id != uid }.first!
        let vc = UserProfileVC()
        vc.user = conversant
        vc.viewingOtherUser = true
        present(vc, animated: true , completion: nil)
    }
    func sortMessagesByDate(){
        guard let messages = currentConvo?.messages else { return }
        let todayMessages = messages.filter({message in
            let time = message.timeStamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            return Calendar.current.isDateInToday(date)
        }).map({message in return message.message_id!})
        
        let yesterDaysMessages = messages.filter({message in
            let time = message.timeStamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            return Calendar.current.isDateInYesterday(date)
        }).map({message in return message.message_id!})
        
        let daysAfterLastWeek : Int = {
            for i in 1...7{
                let interval = TimeInterval(i)
                let date  = Date().addingTimeInterval(-interval)
                if Calendar.current.isDateInWeekend(date){ return i}
            }
            return 0
        }()
        
        let dateofLastWeek : Date = {
            for i in 0...daysAfterLastWeek{
                let interval = TimeInterval(i)
                let date  = Date().addingTimeInterval(-interval)
                if Calendar.current.isDateInWeekend(date){ return date}
            }
            return Date()
        }()
        
        let thisWeekMessages = messages.filter({message in
            let time = message.timeStamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            let thisWeek = Calendar.current.component(.weekOfYear, from: Date())
            let thatWeek = Calendar.current.component(.weekOfYear , from: date)
            let isToday = Calendar.current.isDateInToday(date)
            let isYesterday = Calendar.current.isDateInYesterday(date)
            return thatWeek == thisWeek && !isToday && !isYesterday
        })
        
        let lastWeekMessages = messages.filter({message in
            let time = message.timeStamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            let thisWeek = Calendar.current.component(.weekOfYear, from: Date())
            let thatWeek = Calendar.current.component(.weekOfYear , from: date)
            let isNotYesterday = !Calendar.current.isDateInYesterday(date)
            return thatWeek == thisWeek - 1 && isNotYesterday
        }).map({message in return message.message_id!})
        
        var dateSection1 = MessageDateSection()
        dateSection1.date = Date()
        dateSection1.messages = todayMessages
        dateSection1.sectionTitle = "TODAY"
        
        var dateSection2 = MessageDateSection()
        dateSection2.date = Date().addingTimeInterval(-1.0)
        dateSection2.messages = yesterDaysMessages
        dateSection2.sectionTitle = "YESTERDAY"
        
        var dateSection3 = MessageDateSection()
        dateSection3.date = dateofLastWeek
        dateSection3.messages = lastWeekMessages
        dateSection3.sectionTitle = "LAST WEEK"
        
        var messageSections = [dateSection1,dateSection2,dateSection3]
        //Collect all of the days this week for which conversations have occured
        var sectionDatesForThisWeek = thisWeekMessages.map { (message) -> Date in
            let time = message.timeStamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            return date
        }
        //Make each element in the array distinct according to the day
        for sectionDate in sectionDatesForThisWeek {
            var tempSections = sectionDatesForThisWeek.filter({ !Calendar.current.isDate($0, inSameDayAs: sectionDate)})
            tempSections.append(sectionDate)
            sectionDatesForThisWeek = tempSections
        }
        //create array of sections for this week
        let sectionsForThisWeek  = sectionDatesForThisWeek.map({date ->MessageDateSection in
            let messagesThisDay = thisWeekMessages.filter({message in
                let time = message.timeStamp?.doubleValue ?? 0
                let messageDate = Date(timeIntervalSince1970: time)
                return Calendar.current.isDate(messageDate , inSameDayAs: date)
            })
            var section = MessageDateSection()
            section.date = date
            section.messages = messagesThisDay.map({$0.message_id!})
            section.sectionTitle = MyCalendar.timeSinceEvent(onDate: date)
            return section
        })
        
        
        messageSections.append(contentsOf: sectionsForThisWeek)
        
        dateSections = messageSections.filter({$0.messages.count > 0})
    }
}
extension ChatVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func dismissImage(_ gesture: UITapGestureRecognizer){
        if let screen = view.viewWithTag(99){
            UIView.animate(withDuration: 0.25, animations: {
                screen.alpha = 0.0
            }, completion: { (_) in
                screen.removeFromSuperview()
            })
        }
         let transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
        if let image = view.viewWithTag(100){
            UIView.animate(withDuration: 0.25, animations: {
                image.alpha = 0.0
                image.transform = transform
            }, completion: { (_) in
                image.removeFromSuperview()
            })
        }
    }
    func showImage(image: UIImage){
        let screen = UIView()
            screen.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            screen.alpha = 0.0
        let dismissGesture = UITapGestureRecognizer(target: self , action: #selector(ChatVC.dismissImage(_:)))
            screen.addGestureRecognizer(dismissGesture)
        let iv = UIImageView()
            iv.image = image
            iv.contentMode = .scaleAspectFill
            iv.layer.masksToBounds = true
            iv.layer.cornerRadius = 25
            iv.frame = CGRect(x: (self.view.frame.width/2)-25, y: (self.view.frame.height/2)-25, width: 50, height: 50)
        
        view.add(views: screen,iv)
        let transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
        
        UIView.animate(withDuration: 0.25, animations: {
            iv.frame = iv.frame.applying(transform)
            iv.center = self.view.center
            screen.alpha = 1.0
        }, completion: nil)
    }
    func chatWithImage(at indexPath: IndexPath, wasSent: Bool, message: ChatMessage)->ChatImageCell{
        if let chatCell = convoCV.dequeueReusableCell(withReuseIdentifier: "ChatImageCell", for: indexPath) as? ChatImageCell{
            let interval = message.timeStamp!
            let date = Date(timeIntervalSince1970: TimeInterval(interval))
            chatCell.contentView.add(views: chatCell.chatterImage,chatCell.timeStamp,chatCell.messageImage)
            chatCell.timeStamp.text = MyCalendar.timeSinceEvent(onDate: date)
            let image_width = chatCell.contentView.frame.width - 70//message.image_width?.floatValue ?? 0
            let image_height = chatCell.contentView.frame.height - 20//message.image_height?.floatValue ?? 0
            let cgwidth = CGFloat(image_width)*0.8
            let cgheight = CGFloat(image_height)*0.8
            let radius = (cgheight + 10)/2
            let imageX:CGFloat = wasSent ? 70 : 5
            chatCell.messageImage.frame = CGRect(x: imageX,y: 0, width: cgwidth, height: cgheight)
        
            //chatCell.messageView.layer.cornerRadius = radius
            if wasSent{
                chatCell.chatterImage.frame = CGRect(x: 5, y: 0, width: 50, height: 50)
                chatCell.timeStamp.frame = CGRect(x: 5, y: 60, width: 100, height: 30)
                
            }else{
                chatCell.chatterImage.frame = CGRect(x: chatCell.messageImage.frame.maxX + 10, y: 0, width: 50, height: 50)
                chatCell.timeStamp.frame = CGRect(x: chatCell.messageImage.frame.maxX + 10 , y: 60, width: 100, height: 40)
            }
            chatCell.messageImage.revealImageWithURL(url: message.image_URL!)
            chatCell.chatterImage.loadImageWithURL(url: message.sender_url!)
            return chatCell
        }
        return ChatImageCell()
    }
    func chatWithText(at indexPath: IndexPath, wasSent: Bool, message: ChatMessage)->ChatDetailCell{
        if let chatCell = convoCV.dequeueReusableCell(withReuseIdentifier: "ChatDetailCell", for: indexPath) as? ChatDetailCell{
            let interval = message.timeStamp!
            let date = Date(timeIntervalSince1970: TimeInterval(interval))
            
                chatCell.timeStamp.text = MyCalendar.timeSinceEvent(onDate: date)
                chatCell.messageView.text = message.message ?? ""
            let height = chatCell.messageView.contentSize.height
            var width = chatCell.messageView.contentSize.width
                width += abs(chatCell.contentView.frame.width - width)/2
            let radius = (height + 10)/2
            let estimateSize = message.message!.rectForText(width: width,textSize:16)
            let midWidth = (width+estimateSize.width)/2
            //let midHeight = min(chatCell.frame.height,(height + estimateSize.height)/2)
            let messageX:CGFloat = wasSent ? chatCell.frame.width-midWidth-10 : 10
            let messageTextColor = wasSent ? UIColor.black : UIColor.white
                chatCell.messageView.frame = CGRect(x: messageX,y: 0, width: width, height: height+10)
                chatCell.messageView.textColor = messageTextColor
                chatCell.messageView.backgroundColor = wasSent ? UIColor.clear : createColor(110, green: 199, blue: 110)
                //chatCell.messageView.layer.cornerRadius = radius
            if wasSent{
                chatCell.chatterImage.frame = CGRect(x: 20, y: 0, width: 50, height: 50)
                chatCell.timeStamp.frame = CGRect(x: 20, y: 60, width: 100, height: 30)
                chatCell.messageView.frame.origin = CGPoint(x: 80, y: 10)
            }else{
                chatCell.chatterImage.frame = CGRect(x: chatCell.contentView.frame.width - 80, y: 0, width: 50, height: 50)
                chatCell.timeStamp.frame = CGRect(x: chatCell.contentView.frame.width - 80, y: 60, width: 100, height: 40)
                chatCell.messageView.frame.origin = CGPoint(x: 20, y: 10)
            }
            chatCell.contentView.add(views: chatCell.chatterImage,chatCell.timeStamp,chatCell.messageView)
            
            chatCell.chatterImage.loadImageWithURL(url: message.sender_url!)
        return chatCell
        }
        return ChatDetailCell()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatImageCell", for: indexPath) as? ChatImageCell{
//            if let image = cell.messageImage.image{
//                showImage(image: image)
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = dateSections else {return 0}
        let section = sections[section]
        return section.messages.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: 30)
    }
  
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let sections = dateSections else {return UICollectionReusableView()}
        let section = sections[indexPath.section]
        
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SectionView", for: indexPath) as! SectionView
            view.dateSection = section
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let basicSize =  CGSize(width: view.frame.width, height: 50)
        guard let sections = dateSections else { return CGSize.zero}
        let section = sections[indexPath.section]
        
        guard var messages = currentConvo?.messages else {return basicSize }
        let sectionMessages = section.messages.map({messageID -> ChatMessage in
            return messages.filter({$0.message_id! == messageID}).first!
        })
                messages = sectionMessages.sorted(by: {message1,message2 in return message1.timeStamp!.intValue > message2.timeStamp!.intValue })
        
            let message = messages[indexPath.item]
            guard let chat = message.message else{
                guard let imageURL = message.image_URL else { return CGSize.zero}
                let image_height = message.image_height?.floatValue ?? 0
                let cgheight = CGFloat(image_height)
                let size = CGSize(width: view.frame.width, height:cgheight)
                return size
            }
            
            let size = CGSize(width: collectionView.frame.width, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateSize = NSString(string: chat).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 18)], context: nil)
            return CGSize(width: view.frame.width, height: max(estimateSize.height+20,80))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = dateSections else {return 0}
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = dateSections else { return UICollectionViewCell()}
        let section = sections[indexPath.section]
        guard var messages = currentConvo?.messages else {return UICollectionViewCell() }
        let sectionMessages = section.messages.map({messageID -> ChatMessage in
            return messages.filter({$0.message_id! == messageID}).first!
        })
        messages = sectionMessages.sorted(by: {message1,message2 in return message1.timeStamp!.intValue > message2.timeStamp!.intValue })
        
        let message = messages[indexPath.item]
        let wasSent = message.from_id! == Auth.auth().currentUser!.uid
        if let image = message.image_URL{
            return chatWithImage(at: indexPath , wasSent: wasSent, message: message)
        }
        return chatWithText(at: indexPath , wasSent: wasSent, message: message)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yTranslation = scrollView.panGestureRecognizer.translation(in: scrollView).y
        let visibleCellsCount = convoCV.visibleCells.count
        let isScrolledUp = scrollView.contentOffset.y < 10 && yTranslation > 0
        guard let messagesCount = currentConvo?.messages.count else { return }
        guard messagesCount > visibleCellsCount || isScrolledUp else { return }
        let norm_colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        let alt_colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        //Scrolling up
        if scrollView.contentOffset.y < 10 && yTranslation < 0{
            
//                    let bounds = chateeGradient.bounds
//                    let heightAnim = CABasicAnimation(keyPath: "locations")
//                    heightAnim.fromValue = [0.3,1.0]
//                    heightAnim.toValue = [0.0,0.4]
//
//                    heightAnim.fillMode = kCAFillModeBoth
//                    chateeGradient.colors = alt_colors
//                    chateeGradient.add(heightAnim, forKey: nil)
//                    chateeGradient.locations = [0.0,0.4]
//                    print("do animation")
            
            if let optView = view.viewWithTag(299) as? OptionsView{
                optView.dismiss()
            }
            
            UIView.animate(withDuration:0.25, animations: {
                self.chatImageHeightCon.constant = 50
                self.chateeImage.alpha = 0.5
                self.view.layoutIfNeeded()
                  self.chateeNameLabel.textColor = UIColor.black
                self.backButton.setImage(#imageLiteral(resourceName: "backButtonBlack"), for: .normal)
                self.optionsButton.setImage(#imageLiteral(resourceName: "settingsButtonBlack"), for: .normal)
            })
        }
        //Scrolling down
        if scrollView.contentOffset.y < 10 && yTranslation > 0{
            if chatImageHeightCon.constant == 50 {
               
//                let heightAnim = CABasicAnimation(keyPath: "locations")
//                heightAnim.fromValue = [0.0,0.4]
//                heightAnim.toValue = [0.3,1.0]
//
//                heightAnim.fillMode = kCAFillModeBoth
//                chateeGradient.colors = norm_colors
//                chateeGradient.add(heightAnim, forKey: nil)
//                chateeGradient.locations = [0.3,1.0]
//                print("do animation")
                if let optView = view.viewWithTag(299) as? OptionsView{
                    optView.dismiss()
                }
                UIView.animate(withDuration:0.25, animations: {
                    self.chatImageHeightCon.constant = 300
                    self.chateeImage.alpha = 1.0
                    self.view.layoutIfNeeded()
                    self.chateeNameLabel.textColor = UIColor.white
                    self.backButton.setImage(#imageLiteral(resourceName: "backButtonWhite"), for: .normal)
                    self.optionsButton.setImage(#imageLiteral(resourceName: "settingsButtonWhite"), for: .normal)
                    
                })
            }
        }
    }

}

class SectionView: UICollectionReusableView{
    override func layoutSubviews() {
        add(views: underlineView,dateTimeStamp)
        
        underlineView.setHeightTo(constant: 1)
        underlineView.setYTo(con: self.y(), by: 0)
        underlineView.setWidthTo(constant: self.frame.width)
        
        dateTimeStamp.setXTo(con: self.x(), by: 0)
        dateTimeStamp.setYTo(con: self.y(), by: 0)
    }
    
    var dateSection: MessageDateSection?{
        didSet{
            date = dateSection!.date
            let description = dateSection!.sectionTitle
            dateTimeStamp.text = description
            //dateTimeStamp.setWidthTo(constant: description.rectForText(width: 100, textSize: 100).width)
        }
    }
    var date:Date?
    let underlineView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        v.layer.cornerRadius = 0.0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let dateTimeStamp: UILabel = {
        let label = UILabel()
            label.font = chivo_AppFont(size: 18, light: true)
            label.textAlignment = .center
            label.backgroundColor = UIColor.white
            label.textColor = UIColor.darkGray
            label.numberOfLines = 0
        
            label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
}
extension ChatVC: ConvoDelegate{
    func updateConvo() {
        guard let chat = currentConvo?.latestChat else { return }
            sortMessagesByDate()
            convoCV.reloadData()
    }
}
extension ChatVC: MessageDelegate{
    func sendMessage( message: String){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let timeStamp = Date().timeIntervalSince1970
            let chat = ChatMessage(date: timeStamp , message: message , url: nil)
            chat.message_id = UUID().uuidString
            chat.convo_id = currentConvo?.convo_id ?? ""
            chat.from_id = uid
            chat.sender_url = ThurstUser().currentUser()?.imageURL ?? ""
            chat.to_id = currentMessageConversant_s.first?.id ?? ""
            chat.receiver_url = currentMessageConversant_s.first?.imageURL ?? ""
            currentConvo?.sendTextMessage(message: chat)
            chatBoxView.chatTextView.resignFirstResponder()
        }else{//Wifi is not available
            chatBoxView.chatTextView.resignFirstResponder()
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
        
    }
    
    func sendImage(){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            insertImage()
            chatBoxView.chatTextView.resignFirstResponder()
            if let logo = UIApplication.shared.keyWindow?.viewWithTag(13){
                logo.alpha = 0
            }
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
       
    }
    
    func resizeFor(height: CGFloat){
        chatHeightCon.constant = height
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
}

extension ChatVC: UITextViewDelegate{
    func removeChatScreen(){
        if let screen = self.view.viewWithTag(98){
            screen.removeGestureRecognizer(dismissGesture!)
            screen.removeFromSuperview()
            chatBoxView.chatTextView.resignFirstResponder()
            chatBoxView.resetBeginLabel()
        }
    }
    func setChatScreen(){
        let screen = UIView()
        screen.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        screen.alpha = 0.0
        screen.frame = self.view.bounds
        self.view.insertSubview(screen, belowSubview: chatBoxView)
        dismissGesture = UITapGestureRecognizer(target: self , action: #selector(ChatVC.dismissChat(_:)))
        screen.tag = 98
        screen.addGestureRecognizer(dismissGesture!)
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [], animations: {
            screen.alpha = 1.0
        }, completion: nil)
    }
    func scrollToBottom(){
        if let items = currentConvo?.messages.count{
            if items > 1{
                let lastPath = IndexPath(item: items-1, section: 0)
                let firstPath = IndexPath(item: 0, section: 0)
                let visibleCells = convoCV.visibleCells.map({cell in
                    return convoCV.indexPath(for: cell)
                })
                if !visibleCells.contains(where: {path in path == firstPath}){
                    //convoCV.selectItem(at: lastPath, animated: true, scrollPosition: .bottom)
                    convoCV.scrollToItem(at: firstPath, at: .top, animated: true)
                }
            }
        }
    }
    
    func moveChat(byOffset offSet: CGFloat,withDuration duration: Double){
        let chatY = chatBoxView.frame.maxY
        if offSet < chatY{
            
            let difference = offSet-chatY
            UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
                self.chatBottomCon.constant = -offSet
                self.view.layoutIfNeeded()
            }, completion: nil)
            return
        }
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseOut, animations: {
            self.chatBottomCon.constant = offSet
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func keyBoardWillShow(_ notification: Foundation.Notification){
        let keyBoardEndRect = ((notification as NSNotification).userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let offSet = keyBoardEndRect.height
        let durationNumber = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveChat(byOffset: offSet , withDuration: duration)
        setChatScreen()
        //scrollToBottom()
        
    }
    
    func keyBoardWillHide(_ notification: Foundation.Notification){
        let durationNumber = (notification as NSNotification).userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        let duration = Double(durationNumber)
        moveChat(byOffset: 0, withDuration: duration)
        removeChatScreen()
    }
    
    func setKeyBoardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyBoardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.keyBoardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}
extension ChatVC: ImageSelectDelegate{
    func insertImage() {
        let imageSelect = ImageSelectVC()
        imageSelect.view.frame = self.view.frame
        imageSelect.delegate = self
        imageSelect.purpose = .Chat
        self.addChildViewController(imageSelect)
        self.view.add(views: imageSelect.view)
    }
    
    func addedImage(url: String, for key: String,size:CGSize) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let image_width = NSNumber(value:Float(size.width))
        let image_height = NSNumber(value: Float(size.height))
        let timeStamp = Date().timeIntervalSince1970
        let chat = ChatMessage(date: timeStamp, message: nil, url: url)
            chat.convo_id = currentConvo?.convo_id ?? ""
            chat.from_id = uid
            chat.to_id = currentMessageConversant_s.first?.id ?? ""
            chat.sender_url = ThurstUser().currentUser()?.imageURL ?? ""
            chat.receiver_url = currentMessageConversant_s.first?.imageURL ?? ""
            chat.image_height = image_height
            chat.image_width = image_width
        self.currentConvo?.sendImageMessage(message:chat)
        
    }
}
extension ChatVC: OptionDelegate{
    func blockUser(){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            showingOptions = false
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let conversant_id = conversant?.id else { return }
            
            let blockRef = Database.database().reference().child(FirebaseUserPath).child(uid).child("block_list")
            blockRef.updateChildValues([conversant_id: true], withCompletionBlock: { (error , ref ) in
                if error != nil{
                    self.thurstAlert(title: "Oops!", message: "There seems to have been an issue", screenColor: UIColor.black , screenAlpha: 0.8)
                }else{
                    self.thurstAlert(title: "Boom!", message: "User Blocked", screenColor: UIColor.black , screenAlpha: 0.8)
                }
            })
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
       
    }
    
    func unblockUser(){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            showingOptions = false
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let conversant_id = conversant?.id else { return }
            
            let blockRef = Database.database().reference().child(FirebaseUserPath).child(uid).child("block_list").child(conversant_id)
            blockRef.removeValue()
            thurstAlert(title: "Boom!", message: "User Unblocked", screenColor: UIColor.black , screenAlpha: 0.8)
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
       
    }
    func reportUser(){
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return }
        if appDel.reachable!.isReachable(){
            showingOptions = false
            let vc = ReportVC()
            vc.view.alpha = 0.0
            vc.offender = conversant?.id
            vc.view.frame = self.view.frame
            self.addChildViewController(vc)
            self.view.add(views: vc.view)
            UIView.animate(withDuration: 0.25) {
                vc.view.alpha = 1.0
            }
        }else{//Wifi is not available
            thurstAlert(title: "Ugh Oh!", message: "Looks like your wifi connection is down...", screenColor: UIColor.black, screenAlpha: 0.6)
        }
        
    }
}
extension ChatVC: ReportDelegate{
    func userReported(){
        guard let offenderName = conversant?.name else { return }
        thurstAlert(title: "Report Received", message: "We apologize for your negative experience \(offenderName) has been reported", screenColor: UIColor.black , screenAlpha: 0.8)
    }
}



