//
//  LandViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 25/12/2021.
//

import Foundation
import UIKit
import Firebase
class LandViewController : UIViewController
{
    @IBOutlet weak var signup: UIButton!
    
    @IBOutlet weak var logIn: UIButton!
    
    var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        signup.setTitle(NSLocalizedString("signUp", comment: ""), for: .normal)
        logIn.setTitle(NSLocalizedString("logIn", comment: ""), for: .normal)
    }
}
extension String
{
    var localized: String
    {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}
