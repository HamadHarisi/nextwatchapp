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
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var userImageInAccount: UIImageView!
    {
        didSet
        {
            userImageInAccount.layer.borderColor = UIColor.systemFill.cgColor
            userImageInAccount.layer.borderWidth = 1
            userImageInAccount.layer.cornerRadius = userImageInAccount.bounds.height / 2
            userImageInAccount.layer.masksToBounds = true
            userImageInAccount.isUserInteractionEnabled = true
         //   let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
//            userImageInAccount.addGestureRecognizer(tabGesture)
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
