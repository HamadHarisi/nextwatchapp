//
//  TabBarViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 12/01/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changRadiusOfTabBar()
        self.changHaightOfTabBar()
//        self.changColorTabBar()
        // Do any additional setup after loading the view.
    }
    

        //-------------Radius------------\\
        func changRadiusOfTabBar(){
            self.tabBar.layer.masksToBounds = true
            self.tabBar.isTranslucent = true
            self.tabBar.layer.cornerRadius = 40
            self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    func changHaightOfTabBar(){
        if UIDevice().userInterfaceIdiom == .phone{
            var tabFrame = tabBar.frame
                tabFrame.size.height = 90
            tabFrame.origin.y = view.frame.size.height - 90
                tabBar.frame = tabFrame
            }
        }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            self.simpleInimitionItem(item)
        }
        func simpleInimitionItem(_ item : UITabBarItem){
            
            guard let barItemView = item.value(forKey: "view") as? UIView else {return}
            let timeInterval: TimeInterval = 0.5
            let propertyAnimmator = UIViewPropertyAnimator(duration: timeInterval, dampingRatio: 0.5){
                barItemView.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }
            propertyAnimmator.addAnimations({barItemView.transform = .identity},delayFactor: CGFloat(timeInterval))
            propertyAnimmator.startAnimation()
        }
//    func changColorTabBar(){
//            self.tabBar.unselectedItemTintColor = .secondaryLabel
        
//        self.tabBar.layer.shadowOffset = CGSize (width: 0, height: 0)
//        self.tabBar.layer.shadowRadius = 2
//        self.tabBar.layer.shadowColor = UIColor.blue.cgColor
//        self.tabBar.layer.shadowOpacity = 0.3
        
        
//        self.tabBar.tint
//    Color = UIColor.init(red: 110/255, green: 47/255, blue: 39/255, alpha: 1)
//}
}
