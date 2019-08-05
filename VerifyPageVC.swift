//
//  VerifyPageVC.swift
//  Thurst
//
//  Created by Blake Rogers on 9/27/17.
//  Copyright © 2017 Kinnectus All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class VerifyPageVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        // Do any additional setup after loading the view.

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    let vcs: [UIViewController] = {
        let vc1 = ConfirmNumberVC()
        vc1.view.tag = 0
        let vc2 = VerifyCodeVC()
        vc2.view.tag = 1
        let vc3 = VerifyCompleteVC()
        vc3.view.tag = 2
        return [vc1,vc2,vc3]
    }()
    let dark_purp: UIColor = {
        return createColor(173, green: 107, blue: 255)
    }()
    let light_blue: UIColor = {
        return createColor(116, green: 188, blue: 247)
    }()
    func setViews(){
        view.addGradientScreen(frame: self.view.frame , start: CGPoint.zero, end: CGPoint(x:0.1,y:1.0), locations: [0.4,1.0], colors: [dark_purp.cgColor,light_blue.cgColor])
        //view.add(views: indicator)
        //indicator.constrainInView(view: self.view , top: 30, left: 0, right: nil, bottom: nil)
        let reset1 = ConfirmNumberVC()
        let pageViewVC = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal , options: [:])
        pageViewVC.view.tag = 1
        pageViewVC.setViewControllers([reset1], direction: .forward, animated: true , completion: nil)
        self.addChildViewController(pageViewVC)
        
        self.view.addSubview(pageViewVC.view)
        pageViewVC.view.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: view.frame.height - 70)
        pageViewVC.dataSource = self
        
    }
    
    let indicator : UIPageControl = {
        let ind = UIPageControl()
        ind.currentPage = 0
        ind.currentPageIndicatorTintColor = UIColor.lightText
        ind.numberOfPages = 3
        ind.pageIndicatorTintColor = UIColor.white
        ind.translatesAutoresizingMaskIntoConstraints = false
        return ind
    }()

}
extension VerifyPageVC : UIPageViewControllerDataSource{
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        let prevIndex = index - 1
        guard prevIndex >= 0  && vcs.count > prevIndex  else { return nil }
        indicator.currentPage = prevIndex
        return vcs[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = viewController.view.tag
        let nextIndex = index + 1
        guard nextIndex >= 0  && vcs.count > nextIndex  else { return nil }
        indicator.currentPage = nextIndex
        return vcs[nextIndex]
    }
}
