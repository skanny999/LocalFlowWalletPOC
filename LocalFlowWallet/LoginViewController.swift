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
        configureView()
    }
    
    
    fileprivate func configureView() {
        
        errorLabel.text = nil
        usernameTextView.becomeFirstResponder()
        passwordTextView.delegate = self
        loginButton.layer.cornerRadius = 8
        loginButton.isEnabled = false
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
        
        guard let password = passwordTextView.text, password.count > 0 else {
            updateErrorLabel(with: "Please enter a valid password")
            return
        }
        
        guard let username = usernameTextView.text, username.count > 0 else {
            updateErrorLabel(with: "Please enter a valid username")
            return
        }

        processAutentication(with: username, and: password)

        errorLabel.text = nil
    }
    
    
    fileprivate func processAutentication(with username: String, and password: String) {
        
        UpdateManager.update(user: username, withPassword: password, completion: { [weak self] (updated, message) in
            
            updated ? self?.updateUserPassword(with: password) : self?.updateErrorLabel(with:message)
        })
    }
    
    fileprivate func updateUserPassword(with password:String) {
        
        User.currentUser()?.password = password
        CoreDataProvider.shared.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    fileprivate func updateErrorLabel(with message: String?) {
        
        DispatchQueue.main.async {
            
            self.errorLabel.text = message
        }
    }

}

