//
//  ViewController.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var passwordTextView: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        errorLabel.text = nil
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"LoginResult"), object: nil, queue: nil, using: catchNotification)
        loginButton.layer.cornerRadius = 8
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        UpdateManager.update(user: passwordTextView.text!)
        errorLabel.text = nil
    }
    
    func catchNotification(notification:Notification) -> Void {
        
        DispatchQueue.main.async {
            
            if let message = notification.userInfo?["message"] as? String {
                
                self.errorLabel.text = message
                
            } else {
                
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    
    
    
    
    


}

