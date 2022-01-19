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
        tabBar.items![0].title = NSLocalizedString("tab1".localized, comment: "")
        tabBar.items![1].title = NSLocalizedString("tab2".localized, comment: "")
        tabBar.items![2].title = NSLocalizedString("tab3".localized, comment: "")
    }
    

        // radius
        func changRadiusOfTabBar(){
            self.tabBar.layer.masksToBounds = true
            self.tabBar.isTranslucent = true
            self.tabBar.layer.cornerRadius = 40
            self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    // haight
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
}
