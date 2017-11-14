//
//  SignInViewController.swift
//  Partner App
//
//  Created by Gustavo Serra on 19/10/2017.
//  Copyright © 2017 iHealthLabs. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    private func setupView() {
        
        self.emailTextField.placeholder = "emailPlaceholderLabel".localized
        self.passwordTextField.placeholder = "passwordPlaceholderLabel".localized
        
        self.signInButton.setTitle("signinTitleButton".localized, for: .normal)
        self.signInButton.backgroundColor = Colors.secondaryColor.color
        self.signInButton.setTitleColor(Colors.textWithBackgroudColor.color, for: .normal)
        
        self.signUpButton.setTitle("signupTitleButton".localized, for: .normal)
        self.signUpButton.backgroundColor = Colors.backgroundColor.color
        self.signUpButton.setTitleColor(Colors.secondaryColor.color, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
    }
    
    @IBAction func signInButtonClicked(_ sender: Any) {
        
        guard let userEmail = self.emailTextField.text,
            let userPassword = self.passwordTextField.text else { return }
        
        if userEmail.characters.count > 0,
            userPassword.characters.count > 0 {
            
            let userStored = DataManager.sharedInstnce.loadData(forKey: "user") as? User
            
            if userStored?.email == userEmail &&
                userStored?.password == userPassword {
                
                UserDefaults.standard.set(true, forKey: "session")
                UserDefaults.standard.synchronize()
                
                let loadingViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CallerViewController")
                UIApplication.shared.keyWindow?.replaceRootViewControllerWith(loadingViewController, animated: true, completion: nil)
            } else {
                
                let alert = UIAlertController(title: "signinErrorMessage".localized, message: nil, preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "signinMessageOkButton".localized, style: .default, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            
            let alert = UIAlertController(title: "fieldsEmptyErrorMessage".localized, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "fieldsEmptyMessageOkButton".localized, style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "segueToSignUp", sender: sender)
    }
}
