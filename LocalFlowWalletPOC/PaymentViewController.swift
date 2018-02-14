//
//  PaymentViewController.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 12/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet var recipientTextField: UITextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: Notification.Name(rawValue:"SendResult"), object: nil, queue: nil, using: catchNotification)
        
        sendButton.layer.cornerRadius = 8
        
        navigationController?.navigationBar.topItem?.title = "\(User.currentUsers()?.first?.balance?.ewa ?? "0") EWA"
        
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
