//
//  PaymentViewController.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 12/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import SearchTextField

class PaymentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var recipientTextField: SearchTextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    
    var contacts: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"SendResult"), object: nil, queue: nil, using: catchNotification)
        
        sendButton.layer.cornerRadius = 8
        
        navigationController?.navigationBar.topItem?.title = "\(User.currentUsers()?.first?.balance?.ewa ?? "0") EWA"
        recipientTextField.delegate = self
        updateContacts()

    }
    
    fileprivate func configureSearchTextField() {
        
        if let contacts = contacts {
            
            recipientTextField.filterStrings(contacts)
            recipientTextField.maxNumberOfResults = 5
            recipientTextField.theme.font = UIFont.systemFont(ofSize: 15)
            recipientTextField.theme.cellHeight = 40
            recipientTextField.highlightAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
            recipientTextField.theme.separatorColor = UIColor (red: 85.0/255.0, green: 180.0/255.0, blue: 250.0/255.0, alpha: 0.8)
            recipientTextField.theme.borderColor = UIColor (red: 85.0/255.0, green: 180.0/255.0, blue: 250.0/255.0, alpha: 1)
        }

    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if contacts == nil {
            
            updateContacts()
        }
        
        return true
    }
    
    fileprivate func updateContacts() {
        
        NetworkProvider.fetchContacts(completion: { (contacts) in
            
            self.contacts = contacts
            
            self.configureSearchTextField()

        })
    }

    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        verifyFields()
        
    }
     
    
    func verifyFields() {
        
        guard let recipient = recipientTextField.text,
            !recipient.isEmpty else {
            
            messageLabel.text = "Address missing"
            return
        }
        
        guard let amount = amountTextField.text?.doubleValue,
            amount > 0 else {
            
            messageLabel.text = "Enter a valid amount"
            return
        }
        
        sendPayment(for: amount, to: recipient)
    }

    
    func sendPayment(for amount: Double, to recipient: String) {
        
        if let data = createTransactionJson(for: amount) {
            
            NetworkProvider.post(data, to: recipient)
        }
    }
    
    
    func createTransactionJson(for amount: Double) -> Data? {
        
        guard let user = User.currentUsers()?.first else { fatalError("No User") }
        
        guard let nickname = user.nickname else { fatalError("No User") }

        let transactionDict = ["amount" : amount, "currency" : "ewa"] as [String : Any]
        
        let dict = ["password" : nickname, "tx" : transactionDict] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            return jsonData
            
        } catch {
            
            print(error.localizedDescription)
        }

        return nil
    }
    
    
    func catchNotification(notification: Notification) -> Void {
        
        DispatchQueue.main.async {
            
            if let message = notification.userInfo?["message"] as? String {
                
                self.messageLabel.text = message
                
            }
        }
    }
    


}
