//
//  UserInfoViewController.swift
//  itunesTest
//
//  Created by admin on 13.08.2022.
//

import UIKit

class UserInfoViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var secondNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setActiveUserData()
    }
    

    private func setActiveUserData() {
        guard let activeUser = UserDataStorage.shared.activeUser else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: activeUser.birth)
        
        
        nameLabel.text = activeUser.name
        secondNameLabel.text = activeUser.secondName
        birthLabel.text = dateString
        phoneLabel.text = activeUser.phone
        emailLabel.text = activeUser.email
        passwordLabel.text = activeUser.password
    }

}
