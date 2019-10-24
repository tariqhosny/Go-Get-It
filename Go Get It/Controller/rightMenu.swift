//
//  rightMenu.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class rightMenu: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Select Language".localized, message: "", preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction(title: "English", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("en")
            helper.restartApp()
        }))
        alert.addAction(UIAlertAction(title: "עברית", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("he")
            helper.restartApp()
        }))
        alert.addAction(UIAlertAction(title: "عربى", style: .destructive, handler: { (action: UIAlertAction) in
            MOLH.setLanguageTo("ar")
            helper.restartApp()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel".localized, comment: ""), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func logOut(_ sender: UIButton) {
        let alert = UIAlertController(title: "Are you sure you want to log out?".localized, message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Log out".localized, style: .destructive, handler: { (action: UIAlertAction) in
            let defUser = UserDefaults.standard
            defUser.removeObject(forKey: "user_token")
            helper.restartApp()
        }))
        alert.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
