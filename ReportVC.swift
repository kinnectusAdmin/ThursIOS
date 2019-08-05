//
//  ReportVC.swift
//  Thurst
//
//  Created by Blake Rogers on 2/11/18.
//  Copyright © 2018 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
protocol ReportDelegate {
    func userReported()
}
class ReportVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        reportTV.delegate = self
        reportTV.dataSource = self
        reportTV.register(ReportCell.self , forCellReuseIdentifier: "ReportCell")
        setViews()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setViews(){
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        view.add(views: reportLabel,reportTV,reportButton,cancelButton)
        reportLabel.constrainInView(view: self.view , top: 20, left: 0, right: 0, bottom: nil)
        reportTV.constrainInView(view: self.view , top: nil, left: 0, right: 0, bottom: -100)
        reportTV.setTopTo(con: reportLabel.bottom(), by: 10)
        reportButton.constrainInView(view: self.view , top: nil, left: 0, right: 0, bottom: -75)
        reportButton.setHeightTo(constant: 50)
        reportButton.addTarget(self , action: #selector(ReportVC.select_sendReport(_:)), for: .touchUpInside)
        cancelButton.constrainInView(view: self.view , top: 0, left: nil, right: 0, bottom: nil)
        cancelButton.addTarget(self , action: #selector(ReportVC.select_cancel(_:)), for: .touchUpInside)
    }
    var delegate: ReportDelegate?
    var offender : String?
    var report: [String] = []
    var offenses: [String]{
        return ["Inappropriate Conversation","Verbal Harassment","Fake Account"]
    }
    var reportLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.text = "Select Offenses"
        label.textAlignment = .center
        label.font = chivo_AppFont(size: 18, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    let reportTV: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.backgroundColor = UIColor.clear
        tv.backgroundView = nil
        tv.allowsMultipleSelection = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let cancelButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = UIColor.white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let reportButton : UIButton = {
        let button = UIButton()
        let title = NSAttributedString(string: "SEND REPORT", attributes: [NSFontAttributeName:chivo_AppFont(size: 12, light: true),NSForegroundColorAttributeName: UIColor.black])
        //button.setImage( , for:.normal)
        button.setAttributedTitle(title, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.backgroundColor = UIColor.white
        button.addShadow(10, dy: 10, color: UIColor.black , radius: 14.0, opacity: 0.6)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 0.0
        }) { (_) in
            self.removeFromParentViewController()
            self.view.removeFromSuperview()
        }
    }
    func select_sendReport(_ sender: UIButton){
        if offenses.count > 0{
            guard let uid = Auth.auth().currentUser?.uid else { return }
            guard let offender_id = offender else {return }
            let reportID = UUID().uuidString
            let reportRef = Database.database().reference().child("Reports").child(uid).child(reportID)
            let userReport: [String:Any] = ["report":report,"offender":offender_id,"report_by":uid,"id":reportID]
            
                reportRef.updateChildValues(userReport)
            let offenseRef = Database.database().reference().child("Offenders").child(offender_id)
                offenseRef.updateChildValues(userReport)
            
           dismiss()
            delegate?.userReported()
        }else{
            thurstAlert(title: "Oops!", message: "You need to add offenses for a report", screenColor: UIColor.black , screenAlpha: 0.8)
        }
        
    }
    func select_cancel(_ sender: UIButton){
        dismiss()
    }
}
extension ReportVC : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offenses.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //add code for selecting offense
            tableView.deselectRow(at: indexPath , animated: false)
            let offense = offenses[indexPath.row]
            if report.contains(offense){
                let index = report.index(of: offense)!.advanced(by: 0)
                report.remove(at: index)
            }else{
                report.append(offense)
            }
        reportTV.reloadRows(at: [indexPath ], with: .none)
    }
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return reportCell(at: indexPath)
    }
    func reportCell(at path: IndexPath)->ReportCell{
        if let cell = reportTV.dequeueReusableCell(withIdentifier: "ReportCell", for: path) as? ReportCell{
            let offense = offenses[path.row]
            cell.offenseLabel.text = offense
            if report.contains(offense){
                cell.selectionImage.image = #imageLiteral(resourceName: "check")
            }else{
                cell.selectionImage.image = nil
            }
            return cell
        }
        return ReportCell()
    }
}
class ReportCell: UITableViewCell{
    override func layoutSubviews() {
        super.layoutSubviews()
        setViews()
    }
    
    func setViews(){
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.add(views: selectionImage,offenseLabel)
       
        offenseLabel.setXTo(con: contentView.x(), by: 0)
        offenseLabel.setYTo(con: contentView.y(), by: 0)
       
        selectionImage.setLeftTo(con: contentView.left(), by: 0)
        selectionImage.setYTo(con: contentView.y(), by: 0)
        selectionImage.setWidth_Height(width: 30, height: 30)
    }
  
    var offenseLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = chivo_AppFont(size: 18, light: true)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let selectionImage : UIImageView = {
        let iv = UIImageView()
            iv.image = #imageLiteral(resourceName: "check")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
}
