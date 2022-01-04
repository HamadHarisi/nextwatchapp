//
//  signInViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 25/12/2021.
//

import UIKit
import Firebase


class SignupViewController : UIViewController
{
    let imagePickerController = UIImagePickerController()
    var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var userImageView: UIImageView!
    {
        didSet
        {
            userImageView.layer.borderColor = UIColor.systemFill.cgColor
            userImageView.layer.borderWidth = 1
            userImageView.layer.cornerRadius = userImageView.bounds.height / 2
            userImageView.layer.masksToBounds = true
            userImageView.isUserInteractionEnabled = true
            let tabGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
            userImageView.addGestureRecognizer(tabGesture)
        }
    }
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var rePasswordTextField: UITextField!
    
    //    @IBOutlet weak var handleSignup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        imagePickerController.delegate = self
    }
    @IBAction func handleSignup(_ sender: Any)
    {
        if let image = userImageView.image,
           let imageData = image.jpegData(compressionQuality: 0.50),
           let name = nameTextField.text,
           let email = emailTextField.text,
           let password = passwordTextField.text,
           let rePassword = rePasswordTextField.text,
           password == rePassword
        {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().createUser(withEmail: email, password: password)
            {
                authResult, error in if let error = error {
                    print("Auth Error!!!!!!!",error.localizedDescription)
                }
                if let authResult = authResult
                {
                    let storageRef = Storage.storage().reference(withPath: "users/\(authResult.user.uid)")
                    let uploadMeta = StorageMetadata.init()
                    uploadMeta.contentType = "image/jpeg"
                    storageRef.putData(imageData, metadata: uploadMeta) { storageMeta, error in
                        if let error = error
                        {
                            print("Storage Error !!!!!!!!",error.localizedDescription)
                        }
                        storageRef.downloadURL {url, error in
                            if let error = error
                            {
                                print("Storage Download Url Error !!!!!!!!",error.localizedDescription)
                            }
                            if let url = url {
                                print("URL",url.absoluteString)
                                let db = Firestore.firestore()
                                let userData: [String:String] = [
                                    "id":authResult.user.uid,
                                    "name":name,
                                    "email":email,
                                    "imageUrl":url.absoluteString
                                ]
                                db.collection("users").document(authResult.user.uid).setData(userData) { error in
                                    if let error = error {
                                        print("Database error !!!!!!!!!!! ",error.localizedDescription)
                                    }
                                    else
                                    {
                                        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                                            vc.modalPresentationStyle = .fullScreen
                                            Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                                            self.present(vc, animated: true, completion: nil)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
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
        userImageView.image = chosenImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
}
