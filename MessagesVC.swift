//
//  MessagesVC.swift
//  Thurst
//
//  Created by Blake Rogers on 10/29/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//
//retrieve convoKeys and fetch convos from database
//order convos according to timestamp of latest message
//determine if there are any convos that happen on the same day
//group those convos into separate date sections

import UIKit
import Firebase
import FirebaseAuth

class MessagesVC: UIViewController {
    // MARK: - Data
    var deleteMessagePath: IndexPath?
    var convoKeys: [String]?{
        didSet{
            convos = []
            var collectedConvos: [Convo] = []
            for key in convoKeys!{
                let convoRef = Database.database().reference().child("User_Convo").child(key)
                convoRef.observeSingleEvent(of: .value , with: { (snapshot) in
                    print(snapshot.value)
                    if let refObject = snapshot.value as? [String:Any]{
                            let convo = Convo()
                                convo.setValuesForKeys(refObject)
                        collectedConvos.append(convo)
                        
                        }
                    if collectedConvos.count == self.convoKeys!.count{
                        self.convos = collectedConvos
                        self.sortConvosByDate()
                    }
                }, withCancel: nil)
            }
        }
    }
    var dateSections: [ConvoDateSection]?{
        didSet{
            messagesCV.reloadData()
        }
    }
    var sortedConvos: [Convo]?
    var convos: [Convo]?
    // MARK: - UIElements
    var bannerHeightCon = NSLayoutConstraint()
    
    let bannerView: UIView = {
        let v = UIView()
        v.backgroundColor = light_pink
        v.layer.cornerRadius = 0.0
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowRadius = 4.0
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 10)
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
        let attTxt = NSAttributedString(string: "T H U R S T", attributes: atts)
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
        lab.text = "M E S S A G E S"
        lab.alpha = 0.0
        lab.backgroundColor = UIColor.clear
        lab.layer.cornerRadius = 0.0
        lab.font = chivo_AppFont(size: 18, light: false)
        lab.translatesAutoresizingMaskIntoConstraints = false
        return lab
    }()
    let messagesCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 300, height: 150)
        let frame = CGRect(x: 0, y: 0, width:300, height: 150)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clear
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        cv.showsVerticalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.clipsToBounds = false
        
        
        return cv
    }()
    // MARK: - Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        messagesCV.delegate = self
        messagesCV.dataSource = self
        
        messagesCV.register(MessagesCell.self , forCellWithReuseIdentifier: "MessagesCell")
        messagesCV.register(MessagesSectionView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MessageSectionView")
        messagesCV.register(DateSectionView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DateSectionView")
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getConvos()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setViews(){
        view.backgroundColor = UIColor.white
        
        view.add(views: messagesCV,bannerView)
        
        bannerView.constrainInView(view: self.view , top: -20, left: -20 , right: 20, bottom: nil)
        bannerHeightCon = bannerView.setHeightTo_Return(constant: 85)
        bannerView.add(views: navButton,thurstLabel,headingLabel)
        
        thurstLabel.constrainInView(view: bannerView, top: 10, left: 0, right: nil, bottom: nil)
        navButton.constrainInView(view: self.bannerView , top: nil, left: 0, right: nil, bottom: 0)
        navButton.addTarget(self , action: #selector(MessagesVC.show_menu(_:)), for: .touchUpInside)
        
        headingTopCon = headingLabel.setTopTo_Return(con: bannerView.bottom(), by: 0)
        headingLabel.setXTo(con: bannerView.x(), by: 0)
        
        messagesCV.constrainInView(view: self.view , top: 65 , left: nil, right: nil, bottom: 0)
        messagesCV.setWidthTo(constant: self.view.frame.width*0.65)
        
        messagesCV.setXTo(con: self.view.x(), by: 0)
        
        let cvShadow = UIView()
        cvShadow.translatesAutoresizingMaskIntoConstraints = false
        cvShadow.backgroundColor = UIColor.white
        cvShadow.layer.shadowColor = UIColor.black.cgColor
        cvShadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        cvShadow.layer.shadowRadius = 10.0
        cvShadow.layer.shadowOpacity = 0.2
        view.insertSubview(cvShadow , belowSubview: messagesCV)
        cvShadow.constrainWithMultiplier(view: messagesCV , width: 1.2, height: 1.0)
        
        
    }
    
    func show_menu(_ sender: UIButton){
        let menuVC = MenuVC()
            menuVC.fromPage = 1
        present(menuVC , animated: true , completion: nil)
    }
    
    func getConvos(){
        guard let id = Auth.auth().currentUser?.uid else { return}
        if let conversations = convos{
            return
        }
        Database.database().reference().child("User_Convo_Refs").child(id).observeSingleEvent(of: .value , with: { (snapshot) in
            print(snapshot.value)
            if let refObject = snapshot.value as? [String:Any]{
                self.convoKeys = refObject.map({key,value in return key})
                
            }
        }, withCancel: nil)
        
    }
    //get convos that have happened today
    //get convos that have happened yesterday
    //calculate how many days between today and last week and for each corresponding date created
    //determine which convos apply
    //find convos for last week
    //group reaming convos by months
    func sortConvosByDate(){
        let todayConvos = convos!.filter({convo in
            let time = convo.latest_timestamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            return Calendar.current.isDateInToday(date)
        }).map({convo in return convo.convo_id!})
        
        let yesterDaysConvos = convos!.filter({convo in
            let time = convo.latest_timestamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            return Calendar.current.isDateInYesterday(date)
        }).map({convo in return convo.convo_id!})
        
        let daysAfterLastWeek : Int = {
            for i in 1...7{
                let interval = TimeInterval(i)
                let date  = Date().addingTimeInterval(-interval)
                let isSaturday = Calendar.current.component(.weekday, from: date) == 6
                if Calendar.current.isDateInWeekend(date) && isSaturday { return i}
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
        
        let thisWeekConvos = convos!.filter({convo in
            let time = convo.latest_timestamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            let thisWeek = Calendar.current.component(.weekOfYear, from: Date())
            let thatWeek = Calendar.current.component(.weekOfYear , from: date)
            let isToday = Calendar.current.isDateInToday(date)
            let isYesterday = Calendar.current.isDateInYesterday(date)
            return thatWeek == thisWeek && !isToday && !isYesterday
        })
        
        let lastWeekConvos = convos!.filter({convo in
            let time = convo.latest_timestamp?.doubleValue ?? 0
            let date = Date(timeIntervalSince1970: time)
            let thisWeek = Calendar.current.component(.weekOfYear, from: Date())
            let thatWeek = Calendar.current.component(.weekOfYear , from: date)
            let isNotYesterday = !Calendar.current.isDateInYesterday(date)
            return thatWeek == thisWeek - 1 && isNotYesterday
        }).map({convo in return convo.convo_id!})
        
        var dateSection1 = ConvoDateSection()
            dateSection1.date = Date()
            dateSection1.convos = todayConvos
            dateSection1.sectionTitle = "TODAY"
        
        var dateSection2 = ConvoDateSection()
            dateSection2.date = Date().addingTimeInterval(-1.0)
            dateSection2.convos = yesterDaysConvos
            dateSection2.sectionTitle = "YESTERDAY"
        
        var dateSection3 = ConvoDateSection()
            dateSection3.date = dateofLastWeek
            dateSection3.convos = lastWeekConvos
            dateSection3.sectionTitle = "LAST WEEK"
        
        var convoSections = [dateSection1,dateSection2,dateSection3]
        //Collect all of the days this week for which conversations have occured
        var sectionDatesForThisWeek = thisWeekConvos.map { (convo) -> Date in
            let time = convo.latest_timestamp?.doubleValue ?? 0
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
           let sectionsForThisWeek  = sectionDatesForThisWeek.map({date ->ConvoDateSection in
            let convosThisDay = thisWeekConvos.filter({convo in
                let time = convo.latest_timestamp?.doubleValue ?? 0
                let convoDate = Date(timeIntervalSince1970: time)
                return Calendar.current.isDate(convoDate , inSameDayAs: date)
            })
            var section = ConvoDateSection()
                section.date = date
                section.convos = convosThisDay.map({$0.convo_id!})
                section.sectionTitle = MyCalendar.timeSinceEvent(onDate: date)
            return section
        })

        
        convoSections.append(contentsOf: sectionsForThisWeek)
        
        dateSections = convoSections.filter({$0.convos.count > 0})
    }

}
extension MessagesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = indexPath.section
         guard let sections = dateSections else { return CGSize.zero}
        let dateSection = sections[section > 0 ? indexPath.section-1 : section]
            let sectionCount = dateSection.convos.count
        return  sectionCount > 0 ? CGSize(width: self.view.frame.width*0.65, height: 100) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = dateSections else { return 1}
        return 1 + sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let sectionWidth:CGFloat = section == 0 ? self.view.frame.width*0.65 : messagesCV.frame.width*1.2
        let sectionHeight:CGFloat = section == 0 ? 70 : 30
        let sectionSize = CGSize(width: sectionWidth, height: sectionHeight)
        
        guard section > 0 else { return sectionSize}
        guard let sections = dateSections else { return CGSize.zero}
        let dateSection = sections[section-1]
        let sectionCount = dateSection.convos.count
       
        return sectionSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else{
            guard let sections = dateSections else { return 0}
            let dateSection = sections[section-1]
            return dateSection.convos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let sections = dateSections else{ return }
        let section = indexPath.section
        let dateSection = sections[section > 0 ? section-1 : section]
        guard let userconvos = convos else { return }
        let sectionConvos = userconvos.filter({convo in return dateSection.convos.contains(convo.convo_id!)})
        guard let convo = sectionConvos[indexPath.item] as? Convo else { return}
        let vc = ChatVC()
            vc.currentConvo = convo
        present(vc, animated: true , completion: nil)
    }
    
    func messageCell(at path: IndexPath)->MessagesCell{
        if let cell = messagesCV.dequeueReusableCell(withReuseIdentifier: "MessagesCell", for: path) as? MessagesCell{
            guard let sections = dateSections else{ return cell}
            let section = path.section
            let dateSection = sections[section > 0 ? section-1 : section]
            guard let userconvos = convos else { return cell}
            let sectionConvos = userconvos.filter({convo in return dateSection.convos.contains(convo.convo_id!)})
            let convo = sectionConvos[path.row]
            guard let message = convo.last_message else { return cell}
            cell.message = message
            cell.path = path
            cell.delegate = self
            return cell
        }
        return MessagesCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section{
        case 0:
        if let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MessageSectionView", for: indexPath) as? MessagesSectionView{
            return view
        }
         default:
            guard let sections = dateSections else {return UICollectionReusableView()}
            let section = sections[indexPath.section-1]
            
            if let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "DateSectionView", for: indexPath) as? DateSectionView{
                view.dateSection = section
                return view
            }
        }
       
        return MessagesSectionView()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        return messageCell(at: indexPath)
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
class MessagesSectionView: UICollectionReusableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        add(views: sectionLabel)
        sectionLabel.setXTo(con: self.x(), by: 0)
        sectionLabel.setTopTo(con: self.top(), by: 10)
    
        
    }
    var sectionLabel: UILabel = {
        let label = UILabel()
            label.text = "MESSAGES"
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = appFont(size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
}
class DateSectionView: UICollectionReusableView{
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    var dateSection: ConvoDateSection?{
        didSet{
            sectionLabel.text = dateSection!.sectionTitle
        }
    }
    func setViews(){
        //backgroundColor = UIColor.blue.withAlphaComponent(0.6)
        add(views: sectionLabel,lineView)
        clipsToBounds = false
        sectionLabel.constrainInView(view: self , top: 0, left:-20, right: nil, bottom: nil)
        lineView.frame = CGRect(x: -20, y: self.frame.height - 4, width: self.frame.width+20 , height: 1)
    }
    var sectionLabel: UILabel = {
        let label = UILabel()
        label.textColor = createColor(230, green: 230, blue: 230)
        label.textAlignment = .left
        label.font = chivo_AppFont(size: 12, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let lineView: UIView = {
        let v = UIView()
            v.backgroundColor = createColor(230, green: 230, blue: 230)
            v.frame = CGRect(x: 0, y: 140, width: 0, height: 1)
        return v
    }()
}

extension MessagesVC: MessagesDelegate{
    func deleteMessage(at path: IndexPath) {
            deleteMessagePath = path
            messagesCV.deleteItems(at: [path])
    }
}

extension MessagesVC: ThurstOptionsDelegate{
    func okResponse() {
        //Enter response for ok
        guard let path = deleteMessagePath else {return }
        messagesCV.deleteItems(at: [path])
        messagesCV.reloadItems(at: [path])
    }
    func cancelResponse() {
        //Enter response for cancel
    }
}
