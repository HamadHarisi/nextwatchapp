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
    var selectedAccount:User?
    var selectedAccountImage:UIImage?
    
    
//    var nameresiver = ""
    @IBOutlet weak var userNameLabelInAccount: UILabel!
   
    @IBOutlet weak var usernameTextField: UITextField!
    
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
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageInAccount.addGestureRecognizer(tabGesture)
        }
    }
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        userNameLabelInAccount.text = selectedAccount?.name
        //\\//\\//\\//\\//\\
        imagePickerController.delegate = self
        //\\//\\//\\//\\//\\
        usernameTextField.text = selectedAccount?.name
        //\\//\\//\\//\\//\\
        if let selectedAccount = selectedAccount ,let selectedAccountImage = selectedAccountImage
        {
            userNameLabelInAccount.text = selectedAccount.name
            userImageInAccount.image = selectedAccountImage
        }
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
   

}
    extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @objc func selectImage()
        { showAlert() }
    func showAlert()
    {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "camera", style: .default, handler: {(action: UIAlertAction) in self.getImage(fromSourceType: .camera)}))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in self.getImage(fromSourceType: .photoLibrary)}))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        self.present(alert, animated: true, completion:  nil)
    }
    func getImage( fromSourceType sourceType: UIImagePickerController.SourceType)
    {
            if UIImagePickerController.isSourceTypeAvailable(sourceType)
            {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = sourceType
                self.present(imagePickerController,animated: true, completion: nil)
            }
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
        {
            guard let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            userImageInAccount.image = chosenImage
            dismiss(animated: true, completion: nil)
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
        {
            picker.dismiss(animated: true, completion: nil)
        }
}
