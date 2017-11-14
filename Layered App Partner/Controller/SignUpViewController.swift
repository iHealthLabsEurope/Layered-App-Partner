//
//  SignUpViewController.swift
//  Partner App
//
//  Created by Gustavo Serra on 19/10/2017.
//  Copyright © 2017 iHealthLabs. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class SignUpViewController: UIViewController {

    @IBOutlet weak var photoButton: UIButton!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    fileprivate let imagePicker = UIImagePickerController()
    fileprivate var hasImage = false
    
    private func setupView() {
        
        self.nameTextField.placeholder = "namePlacaholderLabel".localized
        self.heightTextField.placeholder = "heightPlaceholderLabel".localized
        self.emailTextField.placeholder = "emailPlaceholderLabel".localized
        self.passwordTextField.placeholder = "passwordPlaceholderLabel".localized
        
        self.signUpButton.setTitle("signupTitleButton".localized, for: .normal)
        self.signUpButton.backgroundColor = Colors.secondaryColor.color
        self.signUpButton.setTitleColor(Colors.textWithBackgroudColor.color, for: .normal)
        
        self.cancelButton.setTitle("cancelTitleButton".localized, for: .normal)
        self.cancelButton.backgroundColor = Colors.backgroundColor.color
        self.cancelButton.setTitleColor(Colors.dangerColor.color, for: .normal)
        
        self.imagePicker.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.photoButton.imageView?.contentMode = .scaleAspectFill
        self.photoButton.layer.cornerRadius = self.photoButton.frame.width/2
        self.photoButton.layer.masksToBounds = true
    }

    @IBAction func signUpButtonClicked(_ sender: Any) {
        
        guard let userName = self.nameTextField.text,
                let userHeight = self.heightTextField.text,
                let userEmail = self.emailTextField.text,
                let userPassword = self.passwordTextField.text else { return }
        
        if userName.characters.count > 0,
            userHeight.characters.count > 0,
            userEmail.characters.count > 0,
            userPassword.characters.count > 0 {
            
            var userPhotoString = ""
            
            if self.hasImage,
                let userPhoto = self.photoButton.imageView?.image?.updateImageOrientionUpSide(),
                let userPhotoData = UIImagePNGRepresentation(userPhoto) {

                userPhotoString = userPhotoData.base64EncodedString(options: .lineLength64Characters)
            }
            
            let newUser = User(name: userName,
                               height: userHeight,
                               photo: userPhotoString,
                               email: userEmail,
                               password: userPassword)
            
            DataManager.sharedInstnce.saveData(item: newUser, forKey: "user")
            
            UserDefaults.standard.set(true, forKey: "session")
            UserDefaults.standard.synchronize()
            
            let loadingViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "CallerViewController")
            UIApplication.shared.keyWindow?.replaceRootViewControllerWith(loadingViewController, animated: true, completion: nil)
        } else {
            
            let alert = UIAlertController(title: "fieldsEmptyErrorMessage".localized, message: nil, preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "fieldsEmptyMessageOkButton".localized, style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func photoButtonClicked(_ sender: Any) {
        
        let alert:UIAlertController=UIAlertController(title: "choicePhotoMessage".localized, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let cameraAction = UIAlertAction(title: "choicePhotoCamera".localized, style: UIAlertActionStyle.default) { UIAlertAction in
            
            self.openCamera()
        }
        
        let gallaryAction = UIAlertAction(title: "choicePhotoGallery".localized, style: UIAlertActionStyle.default) { UIAlertAction in
           
            self.openGallary()
        }
        
        let cancelAction = UIAlertAction(title: "choicePhotoCancel".localized, style: UIAlertActionStyle.cancel, handler: nil)

        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            
            openGallary()
        }
    }
    
    private func openGallary() {
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let imageNow = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.hasImage = true
        self.photoButton.setImage(imageNow, for: .normal)
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
}
