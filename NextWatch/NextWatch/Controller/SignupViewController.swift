//
//  signInViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 25/12/2021.
//

import Foundation
import UIKit


class SignupViewController : UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
    }
}
