//
//  loginViewController.swift
//  NextWatch
//
//  Created by حمد الحريصي on 25/12/2021.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController
{
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var scrollView1: UIScrollView!
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      if textField == emailTextField {
         textField.resignFirstResponder()
          passwordTextField.becomeFirstResponder()
      } else if textField == passwordTextField {
         textField.resignFirstResponder()
          passwordTextField.becomeFirstResponder()
      }
     return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Localized for title
        self.navigationItem.title = NSLocalizedString("LoginMainTitle", comment: "")
        //
        view.addGestureRecognizer(UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing(_:))))
        
        //\\/\/\//\/\/\/\/\/\/
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func handleLogin(_ sender: Any)
    {
        if let email = emailTextField.text,
           let password = passwordTextField.text {
            Activity.showIndicator(parentView: self.view, childView: activityIndicator)
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let _ = authResult {
                    if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeNavigationController") as? UITabBarController {
                        vc.modalPresentationStyle = .fullScreen
                        Activity.removeIndicator(parentView: self.view, childView: self.activityIndicator)
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            }
        }
        
    }
    @objc func keyboardWillShow(notification:NSNotification) {

        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)

        var contentInset:UIEdgeInsets = self.scrollView1.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView1.contentInset = contentInset
    }

    @objc func keyboardWillHide(notification:NSNotification) {

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView1.contentInset = contentInset
    }
}
