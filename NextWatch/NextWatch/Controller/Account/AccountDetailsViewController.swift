//
//  AccountDetailsViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 04/01/2022.
//

import Foundation
import UIKit
import Firebase

class AccountDetailsViewController : UIViewController
{
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    var selectedAccount:User?
    var selectedAccountImage:UIImage?
    
    @IBOutlet weak var userImageInAccountDetails: UIImageView!
    {
        didSet
        {
//            userImageInAccountDetails.layer.borderColor = UIColor.systemFill.cgColor
//            userImageInAccountDetails.layer.borderWidth = 1
//            userImageInAccountDetails.layer.cornerRadius = userImageInAccountDetails.bounds.height / 2
            userImageInAccountDetails.layer.masksToBounds = true
            userImageInAccountDetails.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageInAccountDetails.addGestureRecognizer(tabGesture)
        }
    }
    

    @IBOutlet weak var usernameInAccointDetails: UILabel!
    @IBOutlet weak var userNameTextFieldInAccountDetails: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePickerController.delegate = self
        getCurrentUserData()
    }
    
    @IBAction func handelEditAccount(_ sender: Any)
    {
        if let image = userImageInAccountDetails.image,
           let imageData = image.jpegData(compressionQuality: 0.50),
           let userName = userNameTextFieldInAccountDetails.text,
           let currentUser = Auth.auth().currentUser {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            let storageRef = Storage.storage().reference(withPath: "User/\(currentUser.uid)")
            let updloadMeta = StorageMetadata.init()
            updloadMeta.contentType = "image/jpeg"
            storageRef.putData(imageData, metadata: updloadMeta) { storageMeta , error in
                if let error = error {
                    print("Upload error",error.localizedDescription)
                }
                storageRef.downloadURL{ url, error in
                    var userData = [String:Any]()
                    if let url = url {
                        let db = Firestore.firestore()
                        let ref = db.collection("users")
                            userData = [
                                "id":currentUser.uid,
                                "name":userName,
                                "email":currentUser.email!,
                                "imageUrl":url.absoluteString

                            ]
                            ref.document(currentUser.uid).setData(userData)
                            { error in
//                            ref.document(postId).setData(postData)
                                if let error = error {
                                    print("FireStore Error",error.localizedDescription)
                                }
                                Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                self.navigationController?.popViewController(animated: true)
                            }
                    }
                }
            }
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
                                self.userNameTextFieldInAccountDetails.text = currentUserData.name
                                self.userImageInAccountDetails.loadImageUsingCache(with: currentUserData.imageUrl)
                            }
                        }
                    }
                }
            }
        }
    }
}
    
extension AccountDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @objc func selectImage()
    { showAlert() }
    func showAlert()
    {
        let alert = UIAlertController(title: "chose Picture", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title:" Camera ", style: .default)
        { Action in self.getImage(from: .camera ) }
        let galaryAction = UIAlertAction(title: " Photo Album ", style: .default)
        { Action in self.getImage(from: .photoLibrary)}
        let dismissAction = UIAlertAction(title: " Cancle ", style: .destructive)
        { Action in self.dismiss(animated: true, completion: nil) }
        alert.addAction(cameraAction)
        alert.addAction(galaryAction)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    func getImage( from sourceType: UIImagePickerController.SourceType)
    {
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
        {
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController,animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        guard let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        userImageInAccountDetails.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}


