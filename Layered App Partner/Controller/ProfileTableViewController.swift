//
//  ProfileTableViewController.swift
//  Suivi de Poids
//
//  Created by Gustavo Serra on 19/09/2017.
//  Copyright © 2017 iHealthLabs. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileHeightLabel: UILabel!
    @IBOutlet weak var profileHeightUnitLabel: UILabel!
    
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var changePasswordLabel: UILabel!
    
    private func setupView() {

        self.profileNameLabel.textColor = Colors.secondaryColor.color
        self.profileHeightLabel.textColor = Colors.textColor.color
        self.editProfileLabel.textColor = Colors.textColor.color
        self.changePasswordLabel.textColor = Colors.textColor.color
        
        self.editProfileLabel.text = "editProfileTitleButton".localized
        self.changePasswordLabel.text = "changePasswordTitleButton".localized
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        
        if let userStored = DataManager.sharedInstnce.loadData(forKey: "user") as? User {
            
            if userStored.photo != "",
                let userPhotoData = Data(base64Encoded: userStored.photo, options: .ignoreUnknownCharacters) {
                
                self.profileImageView.image = UIImage(data: userPhotoData)
            }
            
            self.profileNameLabel.text = userStored.name
            self.profileHeightLabel.text = userStored.height
        } else {

            self.profileNameLabel.text = "--"
            self.profileHeightLabel.text = "-"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.width/2
        self.profileImageView.layer.masksToBounds = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
