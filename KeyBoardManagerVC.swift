//
//  KeyBoardManagerVC.swift
//  Thurst
//
//  Created by Blake Rogers on 11/13/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//


protocol KeyboardManager{
    func setKeyboardViews()
    func setKeyboardFields()
}
class KeyBoardManagerVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setKeyBoardNotification()
       
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var txtContainerView: UIView?{
        return view.viewWithTag(100)
    }
    var didMove: Bool = false
    var delegate: KeyboardManager?
    var offSet: CGFloat = 0
    var duration: Double = 0
    var dismissGesture: UITapGestureRecognizer?
    var activeField: UITextField?
    var activeView: UITextView?
    var dismissingTextField: UITextField?
    var dismissingTextView: UITextView?
    var keyboardEndRect: CGRect?
    func setTxtFields( _ fields:[UITextField]){
        for field in fields{
            field.delegate = self
        }
    }
    func setTxtViews( _ views:[UITextView]){
        for txtView in views{
            txtView.delegate = self
        }
    }
    func setFields(_ activeField: UITextField?, activeView: UITextView?, dismissingTxtField: UITextField?,dismissingTxtView: UITextView?){
        self.activeField = activeField
        self.activeView = activeView
        self.dismissingTextField = dismissingTxtField
        self.dismissingTextView = dismissingTxtView
    }
    
    func removeKeyboard(_ gesture: UITapGestureRecognizer){
        if let v = activeView{
            v.resignFirstResponder()
            activeView = nil
        }
        if let f = activeField{
            f.resignFirstResponder()
            activeField = nil
        }
    }
    func setDismiss(){
        if dismissGesture == nil{
            dismissGesture = UITapGestureRecognizer(target: self , action: #selector(KeyBoardManagerVC.removeKeyboard(_:)))
            self.view.addGestureRecognizer(dismissGesture!)
        }
    }
    func keyBoardWillShow(_ notification: NSNotification){
        keyboardEndRect = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        offSet = keyboardEndRect!.height
        
        let durationNumber = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        duration = Double(durationNumber)
        liftContainer()
        setDismiss()
        
    }
    func liftContainer(){
        didMove = false
        guard let maxY = activeField?.frame.maxY else { return}
        //guard let maxY = txtContainerView?.frame.maxY else { return}
        let diff = abs(maxY - offSet)
        
        /////////
        if let field = activeField{
            if field.frame.intersects(keyboardEndRect!){
                didMove = true
                UIView.animate(withDuration: 0.5) {
                    self.txtContainerView?.frame.origin.y -=  diff
                    self.view.layoutIfNeeded()
                }
            }
        }
        if let tv = activeView{
            if tv.frame.intersects(keyboardEndRect!){
                didMove = true
                UIView.animate(withDuration: 0.5) {
                    self.txtContainerView?.frame.origin.y -=  diff
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
    func lowerContainer(){
        if didMove{
            UIView.animate(withDuration: 0.5) {
                self.txtContainerView?.frame.origin.y += self.offSet ?? 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func keyBoardWillHide(_ notification: NSNotification){
        let durationNumber = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber
        duration = Double(durationNumber)
        lowerContainer()
        dismissGesture = nil
    }
    
    func setKeyBoardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardManagerVC.keyBoardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(KeyBoardManagerVC.keyBoardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
}

extension KeyBoardManagerVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n"{
            textField.resignFirstResponder()
            activeField = nil
            return false
        }
        return true
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == dismissingTextField{
            textField.resignFirstResponder()
            dismissingTextField = nil
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        liftContainer()
        activeField = textField
        delegate?.setKeyboardFields()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        lowerContainer()
        activeField == nil
    }
}
extension KeyBoardManagerVC: UITextViewDelegate{
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        delegate?.setKeyboardViews()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeView = textView
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
        activeView = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
            activeView = nil
            return false
        }
        return true
    }
}
