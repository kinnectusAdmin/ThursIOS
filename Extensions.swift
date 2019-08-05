
//
//  Extensions.swift
//  5thWave
//
//  Created by Blake Rogers on 12/1/16.
//  Copyright © 2016 kinnectus. All rights reserved.
//


import Foundation
import UIKit

public let appFont_12 = UIFont(name: "Myriad Pro", size: 12.0)
public let appFont_15 = UIFont(name: "Myriad Pro", size: 15.0)
public let appFont_18 = UIFont(name: "Myriad Pro", size: 18.0)
public let appFont_24 = UIFont(name: "Myriad Pro", size: 24.0)

public func appFont( size:CGFloat)->UIFont{
    return UIFont(name:"Myriad Pro", size: size) ?? UIFont.systemFont(ofSize: size)
}
public func chivo_AppFont( size:CGFloat,light:Bool)->UIFont{
    let style = light ? "Chivo-Light" : "Chivo-Regular"
    return UIFont(name:style, size: size) ?? UIFont.systemFont(ofSize: size)

}
public let dark_Pink = createColor(252, green: 151, blue: 151)
public let light_pink = createColor(251, green: 197, blue: 197)
public let themeRed = createColor(155, green: 10, blue: 17)
public let light_orange = createColor(255, green:153,blue:102)
public let themeBlue = createColor(14, green: 19, blue: 51)
public let light_green = createColor(156, green: 254, blue: 205)
public let themeBlack = createColor(2,green: 0, blue:1)

public let themePurp = createColor(177, green: 133, blue: 216)
public let themeLightBlue = createColor(34, green: 76, blue: 100)
public var imageCache = NSCache<AnyObject,UIImage>()
public  func createColor(_ red: CGFloat, green: CGFloat, blue: CGFloat)->UIColor{
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
}
public let green_Yellow = createColor(209, green: 227, blue: 199)
public let blue_Purp = createColor(140, green: 158, blue: 198)
public let salmon_Pink = createColor(255, green: 204, blue: 153)
public let thurst_blue = createColor(35, green: 241, blue: 243)
public let light_grey = createColor(255, green: 220, blue: 187)
class Extensions {
    
}

extension Array{
    func groupBy(limit: Int)->[[Element]]{
        var sorted = self
        var groupedOptions = [[Element]]()
        for i in 0...count{
            let first = sorted.prefix(limit)
            if !first.isEmpty{
                groupedOptions.append(first.map({$0}))
            }
            sorted = sorted.dropFirst(limit).map({$0})
            
        }
        return groupedOptions
    }
}

extension String{
    
    func rectForText(width: CGFloat, textSize: CGFloat)->CGRect{
        let size = CGSize(width: width, height: 1000)
        
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estimateRect = NSString(string: self).boundingRect(with: size, options: options, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: textSize)], context: nil)
        return estimateRect
    }
    
    func replace(strings:[String], with words: [String])->String{
        var newWord = self
        for (index,string) in strings.enumerated(){
            newWord = newWord.replacingOccurrences(of: string , with: words[index])
        }
        return newWord
    }
}

extension UIView {
    func left()->NSLayoutXAxisAnchor{
        return leftAnchor
    }
    func right()->NSLayoutXAxisAnchor{
        return rightAnchor
    }
    func top()->NSLayoutYAxisAnchor{
        return topAnchor
    }
    func bottom()->NSLayoutYAxisAnchor{
        return bottomAnchor
    }
    func x()->NSLayoutXAxisAnchor{
        return centerXAnchor
    }
    func y()->NSLayoutYAxisAnchor{
        return centerYAnchor
    }
    func setTopTo(con: NSLayoutYAxisAnchor, by: CGFloat){
        let con = topAnchor.constraint(equalTo: con, constant: by)
        con.isActive = true
    }

    func setLeftTo(con: NSLayoutXAxisAnchor, by: CGFloat){
        let con = leftAnchor.constraint(equalTo: con, constant: by)
        //NSLayoutConstraint
        con.isActive = true
    }
 
    func setRightTo(con: NSLayoutXAxisAnchor, by: CGFloat){
        let con = rightAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
    }
    func setXTo(con: NSLayoutXAxisAnchor, by: CGFloat){
        let con = centerXAnchor.constraint(equalTo: con , constant: by )
        con.isActive = true
    }
    func setYTo(con: NSLayoutYAxisAnchor, by: CGFloat){
        let con = centerYAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
    }
    func setBottomTo(con: NSLayoutYAxisAnchor, by: CGFloat){
        let con = bottomAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true

    }
    func setHeightTo(constant: CGFloat){
        let con = heightAnchor.constraint(equalToConstant: constant)
        con.isActive = true
    }
    func setWidthTo(constant: CGFloat){
        let con = widthAnchor.constraint(equalToConstant: constant)
        con.isActive = true
    }

    
    /*------------CONSTRAINTS WITH A RETURN ----------------------------*/
    func setTopTo_Return(con: NSLayoutYAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = topAnchor.constraint(equalTo: con, constant: by)
        con.isActive = true
        return con
    }
    func setLeftTo_Return(con: NSLayoutXAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = leftAnchor.constraint(equalTo: con, constant: by)
        con.isActive = true
        return con
    }

    func setRightTo_Return(con: NSLayoutXAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = rightAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
        return con
    }
    func setXTo_Return(con: NSLayoutXAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = centerXAnchor.constraint(equalTo: con , constant: by )
        con.isActive = true
        return con
    }
    func setYTo_Return(con: NSLayoutYAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = centerYAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
        return con
    }
    func setBottomTo_Return(con: NSLayoutYAxisAnchor, by: CGFloat)->NSLayoutConstraint{
        let con = bottomAnchor.constraint(equalTo: con , constant: by)
        con.isActive = true
        return con
    }
    func setHeightTo_Return(constant: CGFloat)->NSLayoutConstraint{
        let con = heightAnchor.constraint(equalToConstant: constant)
        con.isActive = true
        return con
    }
    func setWidthTo_Return(constant: CGFloat)->NSLayoutConstraint{
        
        let con = widthAnchor.constraint(equalToConstant: constant)
        con.isActive = true
        return con
    }
    func setWidth_Height(width: CGFloat, height: CGFloat){
        let htcon = heightAnchor.constraint(equalToConstant: height)
        htcon.isActive = true
        let wcon = widthAnchor.constraint(equalToConstant: width)
        wcon.isActive = true
    }
    func add(views: UIView...){
        for view in views{
            addSubview(view)
        }
    }
    
    func constrainToViews(top:(UIView,CGFloat),left: (UIView,CGFloat),right:(UIView,CGFloat),bottom: (UIView,CGFloat)){
        topAnchor.constraint(equalTo:bottom.0.layoutMarginsGuide.bottomAnchor, constant: top.1).isActive = true
        leftAnchor.constraint(equalTo: left.0.layoutMarginsGuide.leftAnchor, constant: left.1).isActive = true
        rightAnchor.constraint(equalTo: right.0.layoutMarginsGuide.rightAnchor, constant: right.1).isActive = true
        bottomAnchor.constraint(equalTo: top.0.layoutMarginsGuide.topAnchor, constant: bottom.1).isActive = true
    }
    
    func constrainInView(view: UIView,top: CGFloat?,left:CGFloat?,right: CGFloat?,bottom:CGFloat?){
        let margins = view.layoutMarginsGuide
        if let topCon = top{
            topAnchor.constraint(equalTo:margins.topAnchor, constant: topCon).isActive = true
        }
        if let leftCon = left{
            leftAnchor.constraint(equalTo: margins.leftAnchor, constant: leftCon).isActive = true
        }
        if let rightCon = right{
            rightAnchor.constraint(equalTo: margins.rightAnchor, constant: rightCon).isActive = true
        }
        if let bottomCon = bottom{
            bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: bottomCon).isActive = true
        }
    }
    
    func constrainWithMultiplier(view: UIView,width:CGFloat,height: CGFloat){
        centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: height).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: width).isActive = true
    }
    func addConstraintForViews(_ type:NSLayoutAttribute,withView: UIView, toView:UIView?,plusMinus: CGFloat){
        addConstraint(NSLayoutConstraint(item: withView, attribute: type, relatedBy: .equal, toItem: toView , attribute: type, multiplier: 1, constant: plusMinus))
    }
    func joinViewsWithConstraint(_ type:NSLayoutAttribute,type2:NSLayoutAttribute,withView: UIView,toView: UIView){
        addConstraint(NSLayoutConstraint(item: withView, attribute: type, relatedBy: .equal, toItem: toView , attribute: type2, multiplier: 1, constant:0))
        
    }
    func addVisualConstraints(_ constraint: String, views: UIView...){
        var constraintDictionary = [String: UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            constraintDictionary.updateValue(view, forKey: key)
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraint, options: NSLayoutFormatOptions(), metrics: nil, views: constraintDictionary))
        
    }
}

extension Data {
    var hexString: String {
        return map { String(format: "%02.2hhx", arguments: [$0]) }.joined()
    }
}
extension UIImage{
    class func scaleImageToSize(image: UIImage,size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        let rect = CGRect(origin: CGPoint.zero, size: size)
        image.draw(in: rect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
}
extension UIImageView{
    func session()-> URLSession{
        
        let sessDefined = Foundation.URLSession.shared
        
        return sessDefined
    }
    func getImageHandler(data: Data?,response: URLResponse?,error: Error?){
        
        if error == nil{
            if let dataImage = UIImage(data: data!){
                
                imageCache.setObject(dataImage, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = dataImage
                    if let loader = self.viewWithTag(33) as? UIActivityIndicatorView{
                        loader.stopAnimating()
                        loader.removeFromSuperview()
                    }
                }
            }
        }else{
            print(error?.localizedDescription ?? "Error")
        }
    }
    func revealImageHandler(data: Data?,response: URLResponse?,error: Error?){
        
        if error == nil{
            if let dataImage = UIImage(data: data!){
                
                imageCache.setObject(dataImage, forKey: response!.url!.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = dataImage
                    UIView.animate(withDuration: 0.25, animations: {
                        self.alpha = 1.0
                    })
                    if let loader = self.viewWithTag(33) as? UIActivityIndicatorView{
                        loader.stopAnimating()
                        loader.removeFromSuperview()
                    }
                }
            }
        }else{
            print(error?.localizedDescription ?? "Error")
        }
    }
    func loadImageWithURL(url: String){
        
        if let image = imageCache.object(forKey: url as AnyObject){
            DispatchQueue.main.async {
                self.image = image as UIImage
            }
            
        }else{
            let url = URL(string:url)
            if url != nil{
                var task = session().dataTask(with: url!, completionHandler: getImageHandler)
                task.resume()
            }
        }
        
    }
    func revealImageWithURL(url: String){
        
        if let image = imageCache.object(forKey: url as AnyObject){
            DispatchQueue.main.async {
                self.image = image as UIImage
                UIView.animate(withDuration: 0.25, animations: {
                    self.alpha = 1.0
                })
            }
            
        }else{
            let url = URL(string:url)
            if url != nil{
                var task = session().dataTask(with: url!, completionHandler: revealImageHandler)
                task.resume()
            }
        }
        
    }
}

extension CALayer{
    func addLayers(layers: CALayer...){
        for layer in layers{
            self.addSublayer(layer)
        }
    }
}
extension UIViewController{
    func showLoading(){
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
    func removeLoading(){
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
    func withIdentifier(id: String)->UIViewController{
        return storyboard!.instantiateViewController(withIdentifier: id)
    }
    func thurstAlert(title: String, message: String,screenColor: UIColor,screenAlpha: CGFloat){
        let alert = ThurstAlertView(title: title , message: message)
            alert.alpha = 0.0
            alert.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
            alert.center = self.view.center
        let screen = UIView()
            screen.backgroundColor = screenColor.withAlphaComponent(screenAlpha)
            screen.frame = self.view.frame
            screen.alpha = 0.0
            screen.tag = 101
        self.view.add(views: screen,alert)
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                screen.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                alert.alpha = 1.0
            })
        }, completion: nil)
        
    }
    func thurstOptionsAlert(title: String, message: String,screenColor: UIColor,screenAlpha: CGFloat,delegate: ThurstOptionsDelegate){
        let alert = ThurstOptionsView(title: title , message: message)
            alert.delegate = delegate
        alert.alpha = 0.0
        alert.frame = CGRect(x: 0, y: 0, width: 300, height: 250)
        alert.center = self.view.center
        let screen = UIView()
        screen.backgroundColor = screenColor.withAlphaComponent(screenAlpha)
        screen.frame = self.view.frame
        screen.alpha = 0.0
        screen.tag = 101
        self.view.add(views: screen,alert)
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25, animations: {
                screen.alpha = 1.0
            })
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                alert.alpha = 1.0
            })
        }, completion: nil)
        
    }
    func alert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    func showAlert(style: UIAlertControllerStyle, alertTitle: String, alertMessage: String, actionTitles: [String], actions: [((UIAlertAction)-> Void)?], completion: (()-> Void)?){
        
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: style)
        for (index,title) in actionTitles.enumerated(){
            let handler = actions[index]
            let action = UIAlertAction(title: title, style: .default, handler:handler)
            alert.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: completion)
    }
}

extension UIView {
    func addShadow(_ dx:CGFloat,dy:CGFloat,color: UIColor,radius: CGFloat,opacity:Float){
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: dx, height: dy)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
    }
    func addGradientScreen(frame: CGRect, start: CGPoint, end: CGPoint, locations: [NSNumber], colors: [CGColor]){
        let gradient = CAGradientLayer()
        gradient.bounds = self.frame
        gradient.frame = frame
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.locations = locations
        gradient.colors = colors
        layer.insertSublayer(gradient, at: 0)
    }
    
    func addGradientScreen_Return(frame: CGRect, start: CGPoint, end: CGPoint, locations: [NSNumber], colors: [CGColor])-> CAGradientLayer{
        let gradient = CAGradientLayer()
        gradient.bounds = self.frame
        gradient.frame = frame
        gradient.startPoint = start
        gradient.endPoint = end
        gradient.locations = locations
        gradient.colors = colors
        layer.addSublayer(gradient)
        return gradient
    }
}

extension UIButton{
    convenience init(title: String, color: UIColor, target: AnyObject?,selector: Selector){
        self.init()
        self.setTitle(title, for: .normal)
        self.setTitleColor(color, for: .normal)
        self.addTarget(target, action: selector, for: .touchUpInside)
        
    }
}
public let app_policy = """
Welcome to Thurst, operated by Thurst, Inc. (“us”, “we”, “Company”, or “Thurst”). We’re so excited that
you’re here! We want to make sure that you are aware of our legal obligations to you and your legal
obligations as a user on Thurst, so please be sure to read the following Terms of Use carefully.

I. ACCEPTANCE OF THE TERMS OF USE
By accessing the Thurst.com website (the “Website”) and/or mobile application (the “App”), and/or
registering a profile to make use of the Thurst.com service (collectively, the “Service”), you agree to be
bound by these Terms of Use (the “Agreement”). If you do not accept and agree to be bound by all of the
terms of this Agreement, please do not continue to access the Website or the App, and please do not use
the Service.

II. CHANGES TO THE AGREEMENT
Thurst is a work-in- progress, and that means that things might change as we continue to improve our
Service. We may revise this Agreement and/or our Privacy Policy from time to time to reflect
requirements of the law, new features, or changes in our business practices. All changes are effective
immediately upon posting on the Website and the App. If you continue to use the Service following the
posting of any revised Agreement, it means that you accept and agree to the changes, so please be sure to
check this Agreement regularly so you are aware of any changes we have made, as these changes are
binding.

III. ELIGIBILITY
Thurst is only open to people age 18 and up. By creating an account and using the Service, you represent
and warrant that:
- you are at least 18 years of age and have the right, authority, and capability to form a
binding contract with Thurst;
- you will comply with this Agreement and all applicable local, state, national, and
international laws, rules, and regulations.
While use of our Service is not limited to users in the United States, we make no claims that the Service
or any of its content is accessible or appropriate outside of the United States. Because access to and use of

our Service may not be legal in certain countries, if you access or use the Service from outside the United
States, you do so on your own initiative and are responsible for compliance with local laws.

IV. ACCOUNT SECURITY AND TERMINATION
You are solely responsible for all activities on your account. Because of that, it is very important that you
keep your account and password secure at all times. Please do not share your password and/or account
with anyone. You must notify us immediately of any unauthorized use of your credentials, unauthorized
access to your account, or any other breach of security so that we may take appropriate action.

We reserve the right, but have no obligation, to monitor content you submit to the Service and/or make
available on the Website or the App. We also reserve the right to remove any information or material,
including material that violates any applicable law or this Agreement.

We reserve the right to disable or terminate any account if, in our opinion, you have violated any
provision of this Agreement, misused the Service, or behaved in a way that Thurst regards as
inappropriate or unlawful.

Upon termination of your account, this Agreement between you and Thurst will terminate, except for the
following provisions: Section V, Section VI, and Sections XI through XV.

V. INTERACTION WITH OTHER USERS
We hope you enjoy interacting with folks on our Services! That being said, Thurst is not responsible and
cannot be held liable, directly or indirectly, for the conduct of any user in connection with the use of our
Service and/or outside the Service. Please exercise caution in all interactions with other Service users,
particularly if you decide to communicate or meet outside the Service.

While users can opt to send in their government identification for identity verification, we do not
guarantee the truthfulness or accuracy of any content posted by any user through the Service, regardless
of whether they have been marked as identity-verified through the Service. Identity verification means
only that the name on the user’s profile matches the name on the government identification submitted by
the user.

You are solely responsible for your interactions with other Service users. Thurst does not conduct
criminal background checks on its users or otherwise inquire into the background of its users.
Thurst makes no representations or warranties as to the conduct of its users.

VI. USE OF WEBSITE AND SERVICE
Thurst grants you a personal, worldwide, royalty-free, non-assignable, nonexclusive, revocable, and non-
sublicensable license to access and use the Service for the sole purpose of personal, non-commercial use
in compliance with this Agreement.

We want to ensure that all of our users have a positive experience with our Service! Therefore, your use
of the Website, App, and Service must comply with the following:

a. Non-commercial use. Your account is for personal use only. You agree not to:
- use the Service or the Website or the App or any content contained in the Service for
any commercial purposes without Thurst’s written consent;
- advertise or solicit any user to buy or sell any products or services through the
Website, the App, or the Service;
- use any information obtained from the Service or Website or App in order to contact,
advertise to, solicit, defraud, or sell to any user without their prior explicit consent.
b. Information Submitted. Dating can be complicated, but we believe that it’s easier when
everyone is honest. By using the Service, Website, and/or App, you agree that you will
not provide any inaccurate, misleading, or false information to Thurst or to any other
user. If information provided to Thurst or another user subsequently becomes inaccurate,
misleading, or false, please promptly take steps to correct the inaccurate information.
You are solely responsible for, and assume all liability regarding the content you submit
and make available through the Service, Website, or App, including messages, videos,
photographs, and/or profile texts, both public and private.
c. No Harassment of Thurst Representatives. We’d like this to go without saying, but you
agree to be respectful and kind when communicating with our representatives. If we feel
that your behavior towards any of our customer care representatives or other employees
is at any time threatening or offensive, we reserve the right to terminate your account.
d. Community Rules. It’s important to us to create a positive experience for all of our users.
By using the Service, the Website, and/or the App, you agree not to:
- impersonate any person or entity, or post any images through the Service of another
person without their permission;
- bully, stalk, intimidate, harass or defame any person through the Service;
- spam other users through the Service;
- make publicly-accessible through the Service any content that is sexually explicit,
pornographic, or contains nudity;
- post or transmit any content, privately or publicly through the Service, that constitutes
hate speech; is threatening; incites violence; or contains graphic violence;

- post or transmit any content, privately or publicly through the Service, that promotes
racism, gender discrimination, ableism, transphobia, xenophobia, kink shaming, body
shaming, bigotry, hatred, and/or harm of any kind, physical or otherwise, against any
group or individual;
- post or transmit any content, privately or publicly through the Service, that violates or
infringes upon anyone’s rights, including, but not limited to, rights of publicity,
privacy, copyright, trademark, or other intellectual property or contract right;
- post or transmit any content, privately or publicly through the Service that may harm
Thurst’s servers or users’ devices;
- post or transmit any content, privately or publicly through the Service, that provides
instructional information about illegal activities or violating someone’s privacy;
- express or imply that any statement you make is endorsed by Thurst.
If at any time, an account that you’re interacting with violates these terms, please let us know via
[reporting mechanism].

e. Other Users’ Information and Content. Some users may post sensitive content or share
sensitive information via the Service. You agree that you will not copy, modify, publish,
transmit, distribute, perform, display, commercially use, or sell any user content made
available via the Service.
We understand dating sites can provide useful data for social science research, but our
users are not experiments. If you are a researcher who plans on doing research on Thurst
or via Thurst, you must contact us in advance for approval.
Although Thurst reserves the right to review and remove content that violates this Agreement,
such content is the sole responsibility of the user who posts it, and Thurst cannot guarantee that
all content on the Website, the App, or available through the Service will comply with this
Agreement. If you see content on the Service that violates this Agreement, please report it to us
immediately.

Thurst reserves the right to investigate and take any available legal action in response to illegal and/or
unauthorized uses of the Service.

VII. THURST’S PROPRIETARY RIGHTS
Thurst owns and hereby retains all proprietary and intellectual property rights in the Service. Therefore,
you agree not to:
- use any robot, bot, spider, crawler, scraper, site search/retrieval application, proxy or
other manual or automatic device, method or process to access, retrieve, index, “data
mine,” or in any way reproduce or circumvent the navigational structure or presentation
of the Service or its contents;

- forge headers or otherwise manipulate identifiers in order to disguise the origin of any
information transmitted to or through the Service;
- modify, adapt, translate, sell, reverse engineer, decipher, decompile or otherwise
disassemble any portion of the Service or cause others to do so;
- use or develop any third-party applications that interact with the Service or other users’
content or information without our written consent;
- post, copy, modify, transmit, disclose, show in public, create any derivative works from,
distribute, make commercial use of, or reproduce in any way any Thurst copyrighted
material, trademarks, or other proprietary information accessible via the Service, without
first obtaining our written consent.
VIII. THURST’S RIGHTS TO YOUR USER INFORMATION
By creating an account and submitting information and content through the Service, you grant to Thurst a
worldwide, transferable, sub-licensable, royalty-free, right and license to host, store, use, copy, display,
reproduce, adapt, edit, publish, modify and distribute any information or content you make available to
the Service. Our license to your information and any posted content is for the limited purpose of
operating, developing, providing, and improving the Service and its features. We will not sell any of your
information to third parties, and all use of user information will comply strictly with our [Privacy Policy].

We want to make the site better for you and would love receiving your feedback! We may request
feedback, suggestions, or comments from users regarding Service features to improve user experience. By
submitting suggestions or feedback to Thurst regarding the Service, you agree that Thurst may use and
share such feedback for any purpose without compensating you.

While we will not sell any user information to third-parties, you agree that Thurst may access, preserve
and disclose any information you made available to the Service if we are required to do so by law or if we
believe, in good faith, that such access, preservation or disclosure is reasonably necessary for us to: (i)
comply with any legal process or orders from law enforcement; (ii) enforce this Agreement; (iii) respond
to claims that any content violates the rights of third parties; (iv) respond to your requests for customer
service; or (v) protect the rights, property or personal safety of Thurst or any other person. Thurst will not
retain the data of any terminated accounts.

IX. NOTICE AND PROCEDURE FOR MAKING CLAIMS OF COPYRIGHT INFRINGEMENT
We want to make sure that nobody in our community posts content that they do not own or have the right
to post. If you believe that material on the Website and/or App infringes your copyright, please send an
email to our Copyright Agent at admin@thurst.co with the following details:

- A physical or electronic signature of a person authorized to act on behalf of the owner of
the copyright that is allegedly infringed;

- Identification of the copyrighted work claimed to have been infringed;
- Identification of the material that is claimed to be infringing or to be the subject of
infringing activity and that is to be removed or access to which is to be disabled, and
information reasonably sufficient to permit us to locate the material;
- Your address, telephone number, and, e-mail address;
- A statement of good faith belief that use of the material in the manner complained of is
not authorized by the copyright owner, its agent, or the law; and
- A statement that the information in the notification is accurate, and under penalty of
perjury, that you are authorized to act on behalf of the owner of the copyright that is
allegedly infringed.
Thurst will then take appropriate measures under the Digital Millennium Copyright Act to respond to
your notice. Our policy is to terminate the account of repeat copyright infringers. We accommodate and
do not interfere with standard technical measures.

X. DISCLAIMERS OF WARRANTIES
Thurst provides the service on an “as is” and “as available” basis, without any warranties of any
kind, either express or implied, statutory or otherwise, including, but not limited to, any
warranties of merchantability, non-infringement and fitness for a particular purpose. Neither
Thurst nor anyone associated with Thurst represents or warrants that
*   the Website, App, or Service will be accurate, reliable, error-free or uninterrupted;
*   any defects or errors will be corrected;
*   our Website, App, and/or the server that makes them available are free of viruses
or other harmful components;
*   the Website, App, or Service will otherwise meet your needs or expectations.
Thurst takes no responsibility for any content that you or another use or Third Party posts,
sends, or receives through the services. Any material downloaded or otherwise obtained
through the use of the Service is accessed at your own discretion and risk. Thurst does not:
(i) Guarantee the accuracy, completeness or usefulness or any information
provided on the service, or
(ii) Adopt, endorse, or accept responsibility for the accuracy or reliability of any
opinion, advice, or statement made by any part other than Thurst.
Under no circumstances will Thurst be responsible for any loss or damages resulting from
anyone’s reliance on information or other content posted on the Website or Service, or
transmitted to or by any user. The foregoing does not affect any warranties which cannot be
excluded or limited under applicable law.

XI. LIMITATIONS OF LIABILITY

To the fullest extent permitted by applicable law, in no event will Thurst, its affiliates or their
licensors, service providers, employees, agents, officers, or directors be liable for damages of
any kind, whether direct, indirect, special, incidental, consequential, or punitive damages,
including, but not limited to:
*   personal injury,
*   pain and suffering,
*   emotional distress,
*   loss of revenue,
*   loss of profits,
*   loss of business or anticipated savings,
*   loss of use,
*   loss of goodwill, and
*   loss of data,
whether caused by tort (including negligence), breach of contract or otherwise, under any legal
theory, arising out of or in connection with:
(i) your use, or inability to use, the Website, App, and/or Service;
(ii) the conduct or content of other users or third parties on, through, or following
use of the Website, App, and/or Service; or
(iii) any unauthorized access, use, or alteration of your information or content,
even if Thurst knows or has been advised of the possibility of such damages.
XII. INDEMNIFICATION
You agree to defend, indemnify, and hold harmless Thurst, its affiliates, licensors, and service providers,
and its officers, directors, employees, agents, contractors, successors, assigns, and third parties from and
against any claims, liabilities, losses, costs, damages, fees and expenses (including reasonable attorneys’
fees) relating to or arising out of:
(i) your access, use of or inability to use the Service;
(ii) any content made available on to the Service by you;
(iii) your violation of any terms of this Agreement or your violation of any rights of a
third party; or
(iv) your violation of any applicable laws, rules or regulations.
Thurst reserves the right, at its own cost, to assume the exclusive defense and control of any matter
otherwise subject to indemnification by you, in which event you will fully cooperate with Thurst in
asserting any available defenses.

XIII. ARBITRATION, GOVERNING LAW, AND VENUE

We understand that arbitration clauses may sound intimidating. We decided to enforce this clause because
arbitration proceedings are usually simpler, cheaper, and more efficient than going to trial or engaging in
any other judicial proceedings – for you and for us.

a. The exclusive means of resolving any dispute or claim arising out of or relating to this
Agreement (including any alleged breach thereof), the Service, the Website, or the App
shall be BINDING ARBITRATION administered by the American Arbitration
Association under the Consumer Arbitration Rules, and enforced by any court having
jurisdiction thereof.
The one exception to the exclusivity of arbitration is that you have the right to bring an
individual claim against the Company in a small-claims court of competent jurisdiction.
But whether you choose arbitration or small-claims court, you may not under any
circumstances commence or maintain against the Company any class action, class
arbitration, or other representative action or proceeding.
b. By using the Website, the App, or the Service in any manner, you agree to the above
arbitration clause. In doing so, YOU GIVE UP YOUR RIGHT TO GO TO COURT to
assert or defend any claims between you and the Company (except for matters that may
be taken to small-claims court). YOU ALSO GIVE UP YOUR RIGHT TO
PARTICIPATE IN A CLASS ACTION OR OTHER CLASS PROCEEDING. Your
rights will be determined by a NEUTRAL ARBITRATOR, NOT A JUDGE OR JURY,
and the arbitrator shall determine all issues related to the dispute. You are entitled to a
fair hearing before the arbitrator. Decisions by the arbitrator are enforceable in court and
may be overturned by a court only for very limited reasons.
c. Any proceeding to enforce this arbitration agreement, including any proceeding to
confirm, modify, or vacate an arbitration award, may be commenced in any court of
competent jurisdiction. In the event that this arbitration agreement is for any reason held
to be unenforceable, any litigation against the Company (except for small-claims court
actions) may be commenced only in the federal or state courts located in California. You
hereby irrevocably consent to the jurisdiction of those courts for such purposes.
d. This Agreement, and any dispute between you and the Company, shall be governed by
the laws of the state of California without regard to principles of conflicts of law,
provided that this arbitration agreement shall be governed by the Federal Arbitration
Act. For users residing outside the United States where our arbitration agreement may be
prohibited by law, the laws of California, U.S.A. will apply to any disputes arising out of
or relating to this Agreement.
e. All claims arising out of or relating to this Agreement, the Service, the Website, or the
App and not covered by the arbitration provision will be litigated exclusively in the
federal or state courts of California, and you consent to personal jurisdiction in those
courts.

XIV. ENTIRE AGREEMENT
This Agreement constitutes the sole and entire agreement between you and Thurst with respect to use of
the Service, the Website, and the App. If any provision of this Agreement is held invalid, the remainder of
this Agreement shall continue in full force and effect.

The failure of Thurst to exercise or enforce any right or provision of this Agreement shall not constitute a
waiver of such right or provision. You agree that your account is non-transferable and all of your rights to
your profile or contents within your account terminate upon your death. No agency, partnership, joint
venture or employment is created as a result of this Agreement and you may not make any representations
or bind Thurst in any manner.



"""









