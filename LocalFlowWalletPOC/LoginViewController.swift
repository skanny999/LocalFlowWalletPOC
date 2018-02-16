//
//  ViewController.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var passwordTextView: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLabel.text = nil
        passwordTextView.becomeFirstResponder()
        passwordTextView.delegate = self
        loginButton.layer.cornerRadius = 8
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
        
        if let password = passwordTextView.text {
            
            UpdateManager.update(user: password, completion: { (updated, message) in
                
                if updated {
                    
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

