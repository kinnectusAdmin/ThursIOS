//
//  EditInfoCell.swift
//  Thurst
//
//  Created by Blake Rogers on 11/22/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit

class EditInfoCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func layoutSubviews() {
        setViews()
        optionsCV.register(InfoOptionCell.self , forCellWithReuseIdentifier: "InfoOptionCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    var infoType: String = ""
    var options:[String] = []{
        didSet{
            optionsCV.reloadData()
        }
    }
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
            dp.datePickerMode = .date
            dp.alpha = 0.0
            dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    let optionsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        layout.itemSize = CGSize(width: 300, height: 400)
        let frame = CGRect(x: 0, y: 0, width:300, height: 500)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.isPagingEnabled = true
        cv.alpha = 0.0
        cv.allowsMultipleSelection = false 
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    func setViews(){
        contentView.add(views: datePicker,optionsCV)
       // contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
        optionsCV.constrainWithMultiplier(view: contentView , width: 1.0, height: 1.0)
        datePicker.constrainInView(view: contentView, top: 0, left: 0, right: 0, bottom: 0)
    }
    
    func setOptionCV(){
        UIView.animate(withDuration: 0.4) {
            self.optionsCV.alpha = 1.0
        }
    }
    
    func setDatePicker(date: String){
        if date.isEmpty{
            
            datePicker.date = Date()
        
        }else{
            datePicker.date = MyCalendar().dateFromString(date: date)
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.datePicker.alpha = 1.0
        })
    }
}

