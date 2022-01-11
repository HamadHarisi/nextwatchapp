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
    let refreshControl = UIRefreshControl()
    
    
    
    @IBOutlet weak var scrollViewInAccount: UIScrollView!
    @IBOutlet weak var userEmailLabelInAccount: UILabel!
    
    @IBOutlet weak var userNameLabelInAccount: UILabel!
    {
        didSet
        {
            userNameLabelInAccount.text = nameResaver
        }
    }
    var imageResaver = ""
    var nameResaver = ""
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var userImageInAccount: UIImageView!
    {
        didSet
        {
            if let imageUrl = URL(string: imageResaver) {
                DispatchQueue.global().async {
                    if let imageData = try? Data(contentsOf: imageUrl) {
                        DispatchQueue.main.async {
                            if let imageHolder = UIImage(data: imageData) {
                                self.userImageInAccount.image = imageHolder
                            }
                        }
                    }
                }
            }
            userImageInAccount.layer.borderColor = UIColor.systemGray.cgColor
            userImageInAccount.layer.borderWidth = 1
            userImageInAccount.layer.cornerRadius = userImageInAccount.bounds.height / 2
            userImageInAccount.layer.masksToBounds = true
            userImageInAccount.isUserInteractionEnabled = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getCurrentUserData()
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let selectedAccount = selectedAccount,
           let selectedImage = selectedAccountImage {
            userEmailLabelInAccount.text = selectedAccount.email
            userNameLabelInAccount.text = selectedAccount.name
            userImageInAccount.image = selectedImage
            editButton.setTitle("Update", for: .normal)
        }
        getCurrentUserData()
        
        
        refreshControl.tintColor = UIColor.systemRed
        refreshControl.addTarget(self, action: #selector(getCurrentUserData), for: .valueChanged)
        scrollViewInAccount.addSubview(refreshControl)
        
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
    
    @objc func getCurrentUserData()
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
//                                self.loadData()
                            }
                        }
                    }
                }
            }
        }
    }
}
