//
//  EditProfileVC.swift
//  Thurst
//
//  Created by Blake Rogers on 11/22/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
protocol EditProfileDelegate {
    func saveDetails(sex: String?,rel: String?,gender: String?,bday: String?)
}
class EditProfileVC: UIViewController {
    
    // MARK: - Variables
    
    var user: ThurstUser?
    var delegate: EditProfileDelegate?
    var dismissGesture: UITapGestureRecognizer?
    var sexToSet: String? // placeholder for user selected option to edit users sexuality
    var relToSet: String?   //placeholder for user selected option to edit users relationship status
    var genderToSet: String? // placeholder for user selected option to edit users gender status
    var bdayToSet: String? //placeholder for user selected bday
    // MARK: - UIElements
    
    let infoTV:UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.clear
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let screenView: UIView = {
        let v = UIView()
            v.backgroundColor = UIColor.white.withAlphaComponent(0.99)
            v.addShadow(10, dy: 10, color: UIColor.black, radius: 10.0, opacity: 0.8)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    let saveButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "Save", attributes: [NSFontAttributeName: chivo_AppFont(size: 18, light: true),
                                                                    NSForegroundColorAttributeName: UIColor.black])
        button.setAttributedTitle(title, for: .normal)
        //button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 10.0
        button.translatesAutoresizingMaskIntoConstraints = false
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
        infoTV.delegate = self
        infoTV.dataSource = self
        infoTV.register(EditInfoCell.self , forCellReuseIdentifier: "EditInfoCell")
        setViews()
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

        view.add(views:screenView,dismissView,infoTV,saveButton,cancelButton)
        view.backgroundColor = UIColor.clear
        dismissView.constrainWithMultiplier(view: self.view , width: 1.0, height: 1.0)
        infoTV.constrainWithMultiplier(view: self.view , width: 0.8, height: 0.9)
        screenView.constrainWithMultiplier(view: self.view , width: 0.9, height: 0.9)
        
        saveButton.constrainInView(view: self.screenView, top: 0, left: nil, right: 0, bottom: nil)
        saveButton.setWidth_Height(width: 50, height: 40)
        saveButton.addTarget(self , action: #selector(EditProfileVC.saveDetail(_:)), for: .touchUpInside)
    
        cancelButton.constrainInView(view: self.screenView , top: 10, left: 10, right: nil, bottom: nil)
        cancelButton.setWidth_Height(width: 15, height: 15)
        cancelButton.addTarget(self , action: #selector(EditProfileVC.dismissEditProfile(_:)), for: .touchUpInside)
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
        }) { (_) in
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    func dismissEditProfile(_ gesture: UITapGestureRecognizer){
        dismiss()
    }
    func saveDetail(_ sender: UIButton){
        if let cell = infoTV.cellForRow(at: IndexPath(row: 0, section: 0)) as? EditInfoCell{
            if cell.datePicker.alpha == 1.0{
                 bdayToSet = cell.datePicker.date.description
            }
        }
        delegate?.saveDetails(sex: sexToSet, rel: relToSet, gender: genderToSet,bday: bdayToSet)
            dismiss()
    }
}
class ProfileInfoSectionView: UIView{
    let details = ["Birthday","Sexuality","Relationship","Gender"]
    var section: Int = 0{
        didSet{
            altInfoButton.tag = section
            altInfoButton.isHidden = section == 0
            titleLabel.text = details[section]
        }
    }
    // MARK: - UIElements
    let saveButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        button.alpha = 0.0
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = chivo_AppFont(size: 24, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let altInfoField : UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        field.backgroundColor = UIColor.white
        field.textAlignment = .left
        field.font = chivo_AppFont(size: 15, light: true)
        field.alpha = 0.0
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1.0
        return field
    }()
    
    let altInfoButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Functions
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    func setViews(){
        backgroundColor = UIColor.clear
        add(views: saveButton,titleLabel,altInfoField,altInfoButton)
        
        saveButton.setYTo(con: self.y(), by: 0)
        saveButton.setLeftTo(con: self.left(), by: 0)
        saveButton.setWidth_Height(width: 15, height: 15)
        saveButton.addTarget(self , action: #selector(ProfileInfoSectionView.saveInfo(_:)), for: .touchUpInside)
        
        
        titleLabel.setTopTo(con: self.top(), by: 10)
        titleLabel.setXTo(con: self.x(), by: 0)
        
        altInfoField.constrainInView(view: self , top: 0, left: 25, right: nil, bottom: 0)
        altInfoField.setRightTo(con: altInfoButton.left(), by: -4)
        
        altInfoButton.setYTo(con: self.y(), by: 0)
        altInfoButton.setRightTo(con: self.right(), by: 0)
        altInfoButton.setWidth_Height(width: 15, height: 15)
        altInfoButton.addTarget(self , action: #selector(ProfileInfoSectionView.pressedShow_HideAltInfo(_:)), for: .touchUpInside)
    }
    
    func show_hideAltInfo( showing: Bool){
        let alpha: CGFloat = showing ? 1.0 : 0.6
        let fieldAlpha: CGFloat = showing ? 0.0 : 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.altInfoField.alpha = fieldAlpha
            self.altInfoButton.alpha = alpha
            self.titleLabel.alpha = alpha
            self.saveButton.alpha = fieldAlpha
            self.layoutIfNeeded()
        })
    }
    
    func showSaved(){
        let newInfo = UILabel()
            newInfo.backgroundColor = UIColor.clear
            newInfo.text = altInfoField.text
            newInfo.font = chivo_AppFont(size: 15, light: true)
            newInfo.frame = altInfoField.frame
        insertSubview(newInfo, aboveSubview: altInfoField)
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
    
    func saveInfo(_ sender: UIButton){
        showSaved()
        show_hideAltInfo(showing: true)
    }
}
extension EditProfileVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 200 : 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionView = ProfileInfoSectionView()
            sectionView.frame = CGRect(x: 0, y: 0, width: self.infoTV.frame.width , height: 100)
            sectionView.section = section
            sectionView.backgroundColor = UIColor.clear
        return sectionView
    }
    
    func editInfoCell( at path: IndexPath)->EditInfoCell{
        let cell = infoTV.dequeueReusableCell(withIdentifier: "EditInfoCell", for: path) as! EditInfoCell
        if path.section != 0{
            cell.optionsCV.delegate = self
            cell.optionsCV.dataSource = self
            cell.optionsCV.tag = path.section
            cell.setOptionCV()
            cell.optionsCV.reloadData()
        }else{
            let bday = user?.bday ?? ""
            cell.setDatePicker(date: bday)
        }
            return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return editInfoCell(at: indexPath)
    }
}
extension EditProfileVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let no_of_items = [0,17,2,13]
        let width = self.infoTV.frame.width*0.5
        return CGSize(width: width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let no_of_items = [0,18,2,12]
        let type = collectionView.tag
        return no_of_items[type]
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoOptionCell", for: indexPath) as? InfoOptionCell{
            collectionView.scrollToItem(at: indexPath , at: .left, animated: true)
            var options: [String] = []
            switch collectionView.tag{
            case 1:
                options = ["Homosexual","Lesbian","Bisexual",
                           "Pansexual","Bicurious","Polysexual",
                           "Monosexual","Allosexual","Androsexual",
                           "Gynosexual","Questioning","Asexual",
                           "Demisexual","Heterosexual","Grey Asexual",
                           "Perioriented","Varioriented","Queer"]
                sexToSet = options[indexPath.item]
            case 2:
                options = ["Poly","Mono"]
                relToSet = options[indexPath.item]
            case 3:
                options = ["Cis","Transgender","Genderfluid",
                           "Agender","Bigender","Polygender",
                           "Nuetrois","Androgyne","Intergender",
                           "Demigender","Greygender","Aporagender"]
                genderToSet = options[indexPath.item]
            default: break
                
            }
          
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoOptionCell", for: indexPath) as? InfoOptionCell{
            var options:[String] = []
            var userOption: String = ""
            
            
            switch collectionView.tag{
            case 1:
                options = ["Homosexual","Lesbian","Bisexual","Pansexual","Bicurious","Polysexual","Monosexual","Allosexual","Androsexual",
                           "Gynosexual","Questioning","Asexual","Demisexual","Heterosexual","Grey Asexual","Perioriented","Varioriented","Queer"]
                userOption = user?.sexuality ?? ""
                
            case 2:
                options = ["Poly","Mono"]
                userOption = user?.relationshipStatus ?? ""
                
            case 3:
                options = ["Cis","Transgender","Genderfluid","Agender","Bigender","Polygender","Nuetrois","Androgyne",
                           "Intergender","Demigender","Greygender","Aporagender"]
                userOption = user?.gender ?? ""
               
            default: break
            }
            let section = collectionView.tag
            let optionViewed =  options[indexPath.item]
       
            if userOption == optionViewed{
                cell.optionLabel.textColor = createColor(0, green: 203, blue: 254)
                collectionView.scrollToItem(at: indexPath , at: .centeredHorizontally, animated: true)
            }
            cell.optionLabel.text = optionViewed
            return cell
        }
        return UICollectionViewCell()
    }
    
}
