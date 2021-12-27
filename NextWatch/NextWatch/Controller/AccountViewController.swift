//
//  AccountViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import UIKit

class AccountViewController: UIViewController {
    @IBOutlet weak var userImageInAccount: UIImageView!
    {
        didSet
        {
            userImageInAccount.isUserInteractionEnabled = true
            let tab = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageInAccount.addGestureRecognizer(tab)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
@objc func selectImage()
    {
     showalert()
    }
    func showalert()
    {

    }
}
