//
//  AccountViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 27/12/2021.
//

import UIKit
import Firebase
class AccountViewController: UIViewController {
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    var selectedAccount:User?
    var selectedAccountImage:UIImage?
    
    
    
    @IBOutlet weak var userEmailLabelInAccount: UILabel!
    
    @IBOutlet weak var userNameLabelInAccount: UILabel!
//    {
//        didSet
//        {
//            userNameLabelInAccount.layer.borderWidth = 0.5
//            userNameLabelInAccount.layer.borderColor = UIColor.systemGray.cgColor
//        }
//    }
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var userImageInAccount: UIImageView!
    {
        didSet
        {
            userImageInAccount.layer.borderColor = UIColor.systemGray.cgColor
            userImageInAccount.layer.borderWidth = 1
            userImageInAccount.layer.cornerRadius = userImageInAccount.bounds.height / 2
            userImageInAccount.layer.masksToBounds = true
            userImageInAccount.isUserInteractionEnabled = true
        }
    }
    
    override func viewDidLoad()
    {
//        func refrash() {}
        
        super.viewDidLoad()
        
//let mvc = AccountViewController
//        mvc.refrash()
        
        if let selectedAccount = selectedAccount,
           let selectedImage = selectedAccountImage {
            userEmailLabelInAccount.text = selectedAccount.email
            userNameLabelInAccount.text = selectedAccount.name
            userImageInAccount.image = selectedImage
            editButton.setTitle("Update", for: .normal)
        }
    
        getCurrentUserData()
    }
    
/*
 let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)

 refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
       print("Handle Ok logic here")
 }))

 refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
       print("Handle Cancel Logic here")
 }))

 present(refreshAlert, animated: true, completion: nil)
 */
    @IBAction func signOutButton(_ sender: Any)
    {
//        let alert = UIAlertController(title: "do you want sign out", message: "", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//            do
//            {
//
//                self.present(alert, animated: true, completion: nil)
//                try Auth.auth().signOut()
//                if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LandingNavigationController") as? UINavigationController
//                {
//                    vc.modalPresentationStyle = .fullScreen
//                    self.present(vc, animated: true, completion: nil)
//                }
//            } catch {
//                print("Error In SignOut",error.localizedDescription)
//
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
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
    
    func getCurrentUserData()
    {
        let refrance = Firestore.firestore()
        if let currentUser = Auth.auth().currentUser
        {
            let currentUserId = currentUser.uid
            refrance.collection("users").document(currentUserId).getDocument{
                userSnapshot, error in if error != nil {
                    print("ERRORRRRRRRR")
                }else{
                    if let userSnapshot = userSnapshot {
                        let userData = userSnapshot.data()
                        if let userData = userData {
                            let currentUserData = User(dict: userData)
                            DispatchQueue.main.async {
                                self.userNameLabelInAccount.text = currentUserData.name
                                self.userEmailLabelInAccount.text = currentUserData.email
                                self.userImageInAccount.loadImageUsingCache(with: currentUserData.imageUrl)
                            }
                        }
                    }
                }
            }
        }
    }
}
