//
//  editProfile.swift
//  Go Get It
//
//  Created by Tariq on 10/1/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit
import MOLH

class editProfile: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var oldPasswordStack: UIStackView!
    @IBOutlet weak var newPasswordStack: UIStackView!
    @IBOutlet weak var profileDataBtn: UIButton!
    @IBOutlet weak var profilePasswordBtn: UIButton!
    @IBOutlet weak var nameLb: UITextField!
    @IBOutlet weak var phoneLb: UITextField!
    @IBOutlet weak var emailLb: UITextField!
    @IBOutlet weak var oldPasswordLb: UITextField!
    @IBOutlet weak var newPasswordLb: UITextField!
    @IBOutlet weak var viewToShadow: UIView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var profile = [productModel]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControl.Event.valueChanged)
        scroll.refreshControl = refreshControl
        
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
        
        profilePasswordBtn.backgroundColor = UIColor.lightGray
        profileDataBtn.backgroundColor = UIColor.white
        profilePasswordBtn.setTitleColor(UIColor.white, for: .normal)
        profileDataBtn.setTitleColor(UIColor.lightGray, for: .normal)
        nameStack.isHidden = false
        phoneStack.isHidden = false
        emailStack.isHidden = false
        oldPasswordStack.isHidden = true
        newPasswordStack.isHidden = true
        
        // Do any additional setup after loading the view.
        dropShadow()
        profileHandleRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
        
    override func viewDidDisappear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    @objc func refresh(sender:AnyObject) {
        profileHandleRefresh()
        refreshControl.endRefreshing()
    }
    
    @objc fileprivate func profileHandleRefresh() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        profileApi.profileApi { (error: Error?, profile: [productModel]?) in
            if let profileData = profile{
                self.profile = profileData
                self.nameLb.text = self.profile[0].name
                self.phoneLb.text = self.profile[0].phone
                self.emailLb.text = self.profile[0].email
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func dropShadow(scale: Bool = true) {
        viewToShadow.layer.masksToBounds = false
        viewToShadow.layer.shadowColor = UIColor.black.cgColor
        viewToShadow.layer.shadowOpacity = 0.2
        viewToShadow.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewToShadow.layer.shadowRadius = 1
        viewToShadow.layer.shouldRasterize = true
        viewToShadow.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    @IBAction func profileDataPresed(_ sender: Any) {
        profilePasswordBtn.backgroundColor = UIColor.lightGray
        profileDataBtn.backgroundColor = UIColor.white
        profilePasswordBtn.setTitleColor(UIColor.white, for: .normal)
        profileDataBtn.setTitleColor(UIColor.lightGray, for: .normal)
        nameStack.isHidden = false
        phoneStack.isHidden = false
        emailStack.isHidden = false
        oldPasswordStack.isHidden = true
        newPasswordStack.isHidden = true
        oldPasswordLb.text = ""
        newPasswordLb.text = ""
    }
    @IBAction func profilePasswordPressed(_ sender: Any) {
        profileDataBtn.backgroundColor = UIColor.lightGray
        profilePasswordBtn.backgroundColor = UIColor.white
        profileDataBtn.setTitleColor(UIColor.white, for: .normal)
        profilePasswordBtn.setTitleColor(UIColor.lightGray, for: .normal)
        nameStack.isHidden = true
        phoneStack.isHidden = true
        emailStack.isHidden = true
        oldPasswordStack.isHidden = false
        newPasswordStack.isHidden = false
    }
    
    @IBAction func editProfileBtn(_ sender: Any) {
        
        if newPasswordLb.text != "" && oldPasswordLb.text != ""{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            profileApi.updatePasswordApi(password: oldPasswordLb.text ?? "", newPassword: newPasswordLb.text ?? "") { (error, message) in
                    let alert = UIAlertController(title: message ,message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok".localized, style: .destructive, handler: { (action: UIAlertAction) in
                        print("Password updated")
                    }))
                    self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                }
        }else{
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            profileApi.updateProfileApi(name: nameLb.text ?? "", email: emailLb.text ?? "", phone: phoneLb.text ?? "", password: "") { (error, message) in
                let alert = UIAlertController(title: message, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("Ok".localized, comment: ""), style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                print("profile updated")
            }
        }
    }
    

}
