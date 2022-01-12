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
    
    @IBOutlet weak var scrollView: UIScrollView!
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
    // TextField IBOutlet
    @IBOutlet weak var nameTextField: UITextField!
    {
        didSet{
            nameTextField.layer.cornerRadius = 15
            nameTextField.layer.borderColor = UIColor.systemFill.cgColor
            nameTextField.layer.borderWidth = 0.5
            nameTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var emailTextField: UITextField!
    {
        didSet{
            emailTextField.layer.cornerRadius = 15
            emailTextField.layer.borderColor = UIColor.systemFill.cgColor
            emailTextField.layer.borderWidth = 0.5
            emailTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var passwordTextField: UITextField!
    {
        didSet{
            passwordTextField.layer.cornerRadius = 15
            passwordTextField.layer.borderColor = UIColor.systemFill.cgColor
            passwordTextField.layer.borderWidth = 0.5
            passwordTextField.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var rePasswordTextField: UITextField!
    {
        didSet{
            rePasswordTextField.layer.cornerRadius = 15
            rePasswordTextField.layer.borderColor = UIColor.systemFill.cgColor
            rePasswordTextField.layer.borderWidth = 0.5
            rePasswordTextField.layer.masksToBounds = true
        }
    }
    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      if textField == nameTextField {
//         textField.resignFirstResponder()
//          emailTextField.becomeFirstResponder()
//      } else if textField == emailTextField {
//         textField.resignFirstResponder()
//          passwordTextField.becomeFirstResponder()
//      } else if textField == passwordTextField {
//          textField.resignFirstResponder()
//          rePasswordTextField.becomeFirstResponder()
//       }
//        else if textField == passwordTextField {
//         textField.resignFirstResponder()
//      }
//     return true
//    }
  
 // Label IBOutlet With Localized
    @IBOutlet weak var userName: UILabel!
    {didSet{ userName.text = "userNameTitle".localized} }
    @IBOutlet weak var email: UILabel!
    {didSet{ email.text = "emailTitle".localized} }
    @IBOutlet weak var password: UILabel!
    {didSet{ password.text = "passwordTitle".localized} }
    @IBOutlet weak var rePassword: UILabel!
    {didSet{ rePassword.text = "rePasswordTitle".localized} }
    @IBOutlet weak var handleSignup: UIButton!
    @IBOutlet weak var haveAccount: UILabel!
    {didSet{ haveAccount.text = "haveAccount".localized} }
    @IBOutlet weak var signinInSignupPage: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
        
        self.navigationItem.title = NSLocalizedString("SignupMainTitle", comment: "")
        // Localization
        
        handleSignup.setTitle(NSLocalizedString("handleSignup", comment: ""), for: .normal)
        signinInSignupPage.setTitle(NSLocalizedString("LogininInSignupPage", comment: ""), for: .normal)
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
        
     let title = NSLocalizedString("chose Picture", comment: "")
        let alert = UIAlertController(title: title, message: "", preferredStyle: .actionSheet)
        let cameraTitle = NSLocalizedString("CameraTitle", comment: "")
        let cameraAction = UIAlertAction(title: cameraTitle , style: .default)
        { Action in self.getImage(from: .camera ) }
        let galaryTitle = NSLocalizedString("galaryTitle", comment: "")
        let galaryAction = UIAlertAction(title: galaryTitle, style: .default)
        { Action in self.getImage(from: .photoLibrary)}
        let dismissTitle = NSLocalizedString("dismissTitle", comment: "")
        let dismissAction = UIAlertAction(title: dismissTitle, style: .cancel)
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
//    @objc func keyboardWillShow(notification:NSNotification) {
//
//        guard let userInfo = notification.userInfo else { return }
//        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
//
//        var contentInset:UIEdgeInsets = self.scrollView.contentInset
//        contentInset.bottom = keyboardFrame.size.height + 20
//        scrollView.contentInset = contentInset
//    }
//
//    @objc func keyboardWillHide(notification:NSNotification) {
//
//        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
//        scrollView.contentInset = contentInset
//    }
}
extension String
{
    var localizedInSignUp: String
    {
        return NSLocalizedString(self, tableName: "Localizable", bundle: .main, value: self, comment: self)
    }
}

