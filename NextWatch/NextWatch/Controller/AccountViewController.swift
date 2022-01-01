//
//  AccountViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import UIKit
import Firebase
class AccountViewController: UIViewController {
  
    
    @IBOutlet weak var userNameLabelInAccount: UILabel!
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
    func configure(with movie:Movie) -> UITableViewCell
    {
        userImageInAccount.loadImageUsingCache(with: movie.user.imageUrl)
        userNameLabelInAccount.text = movie.user.name
        return self
    }
    @IBAction func signOutButton(_ sender: Any)
    {
    do
    {
    try Auth.auth().signOut()
    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController
    {
    vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
    }
    } catch {
    print("Error In SignOut",error.localizedDescription)
    
    }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let identifier = segue.identifier
//        {
//            if identifier == "toAccountVC" {
//
//            }
//        }
//    }
@objc func selectImage()
    {
     showalert()
    }
    func showalert()
    {

    }
}

