//
//  ProfileViewController.swift
//  Suivi de Poids
//
//  Created by Gustavo Serra on 19/09/2017.
//  Copyright © 2017 iHealthLabs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var exitButton: UIButton!
    
    @IBOutlet weak var profileTableViewController: ProfileTableViewController!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    private func setupView() {
        
        self.logoutButton.setTitle("logoutTitleButton".localized, for: .normal)
        self.logoutButton.backgroundColor = Colors.backgroundColor.color
        self.logoutButton.setTitleColor(Colors.dangerColor.color, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    @IBAction func exitButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonClicked(_ sender: Any) {
        
        UserDefaults.standard.set(false, forKey: "session")
        UserDefaults.standard.synchronize()
        
        let signinViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "SignInViewController")
        UIApplication.shared.keyWindow?.replaceRootViewControllerWith(signinViewController, animated: true, completion: nil)
    }
}

