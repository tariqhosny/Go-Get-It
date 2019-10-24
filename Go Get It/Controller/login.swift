//
//  ViewController.swift
//  Go Get It
//
//  Created by Tariq on 9/29/19.
//  Copyright © 2019 Tariq. All rights reserved.
//

import UIKit

class login: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var loginByFacebook: UIButton!
    @IBOutlet weak var loginByGoogle: UIButton!
    @IBOutlet weak var segmentedControll: UISegmentedControl!
    @IBOutlet weak var nameTf: UITextField!
    @IBOutlet weak var nameStack: UIStackView!
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var phoneTf: UITextField!
    @IBOutlet weak var emailTf: UITextField!
    @IBOutlet weak var passwordTf: UITextField!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var forgetPassword: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.activityIndicator.isHidden = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        self.navigationController?.navigationBar.barTintColor = UIColor.gray
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.backItem?.title = ""
        
        nameTf.delegate = self
        phoneTf.delegate = self
        emailTf.delegate = self
        passwordTf.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        nameTf.isHidden = true
        phoneTf.isHidden = true
        nameStack.isHidden = true
        phoneStack.isHidden = true
        forgetPassword.isHidden = false
        loginByGoogle.isHidden = false
        loginByFacebook.isHidden = false
        signIn.setTitle("SIGN IN".localized, for: .normal)
    }
    
    @IBAction func segmentedPressed(_ sender: UISegmentedControl) {
        switch segmentedControll.selectedSegmentIndex {
        case 0:
            emailTf.text = ""
            passwordTf.text = ""
            nameTf.text = ""
            phoneTf.text = ""
            nameTf.isHidden = true
            phoneTf.isHidden = true
            nameStack.isHidden = true
            phoneStack.isHidden = true
            forgetPassword.isHidden = false
            loginByGoogle.isHidden = false
            loginByFacebook.isHidden = false
            signIn.setTitle("SIGN IN".localized, for: .normal)
        case 1:
            emailTf.text = ""
            passwordTf.text = ""
            nameTf.isHidden = false
            phoneTf.isHidden = false
            nameStack.isHidden = false
            phoneStack.isHidden = false
            forgetPassword.isHidden = true
            loginByGoogle.isHidden = true
            loginByFacebook.isHidden = true
            signIn.setTitle("SIGN UP".localized, for: .normal)
        default:
            print("AnyThing")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTf{
            do {
                let regex = try NSRegularExpression(pattern: ".*[^A-Za-z ].*", options: [])
                if regex.firstMatch(in: string, options: [], range: NSMakeRange(0, string.count)) != nil {
                    return false
                }
            }
            catch {
                print("ERROR")
            }
            return true
        }else{
            return true
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        guard let email = emailTf.text , let password = passwordTf.text else {return}
        if email.isEmpty || password.isEmpty{
            self.displayErrors(errorText: "Empty Fields".localized)
        }else{
            if password.count < 6{
                self.displayErrors(errorText: "The password must be at least 6 characters".localized)
            }else{
                if isValidEmail(emailStr: email){
                    self.activityIndicator.isHidden = false
                    self.activityIndicator.startAnimating()
                    if signIn.currentTitle == "SIGN IN".localized{
                        authApi.loginApi(email: email, password: password) { (error: Error?, success: Bool, valifation) in
                            if success == true{
                                print("Logined")
                            }else{
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                                self.displayErrors(errorText: valifation)
                            }
                        }
                    }else{
                        guard let name = nameTf.text , let phone = phoneTf.text , let email = emailTf.text , let password = passwordTf.text else {return}
                        
                        authApi.registerApi(name: name, phone: phone, email: email, password: password) { (error: Error?, success: Bool, valifation) in
                            if success == true{
                                print("regestered")
                            }else{
                                self.activityIndicator.isHidden = true
                                self.activityIndicator.stopAnimating()
                                self.displayErrors(errorText: valifation)
                            }
                        }
                    }
                }else{
                    displayErrors(errorText: "Invalide Email Format".localized)
                }
            }
        }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func displayErrors (errorText: String){
        let alert = UIAlertController.init(title: errorText, message: "", preferredStyle: .alert)
        let dismissAction = UIAlertAction.init(title: "Dismiss".localized, style: .default, handler: nil)
        alert.addAction(dismissAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

