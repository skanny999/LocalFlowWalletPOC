//
//  ViewController.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var usernameTextView: UITextField!
    @IBOutlet var passwordTextView: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLabel.text = nil
        usernameTextView.becomeFirstResponder()
        passwordTextView.delegate = self
        loginButton.layer.cornerRadius = 8
        hideKeyboard()
    }

    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        login()
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        login()
        passwordTextView.resignFirstResponder()
        
        return true
    }

    
    fileprivate func login() {
        
        if let password = passwordTextView.text, let username = usernameTextView.text {
            
            UpdateManager.update(user: username, withPassword: password, completion: { (updated, message) in
                
                if updated {
                    
                    User.currentUser()?.password = password
                    CoreDataProvider.shared.save()
                    
                    self.dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        self.errorLabel.text = message
                    }
                }
            })
        }
        
        errorLabel.text = nil
    }

}

