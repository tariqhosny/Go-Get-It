//
//  privacy.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class privacy: UIViewController {
    
    @IBOutlet weak var policyName: UILabel!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var privacy: UILabel!
    
    var policies = [productModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            if MOLHLanguage.currentAppleLanguage() == "en"{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            }else{
                menuButton.target = revealViewController()
                menuButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            }
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        privacyHandleRefresh()
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func privacyHandleRefresh() {
        profileApi.privacyApi { (error: Error?, privacy: [productModel]?) in
            if let privacies = privacy{
                self.policies = privacies
                self.privacy.text = self.policies[0].Description
                self.policyName.text = self.policies[0].title
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
