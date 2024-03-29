//
//  PaymentViewController.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 12/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import SearchTextField

class PaymentViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var recipientTextField: SearchTextField!
    @IBOutlet var amountTextField: UITextField!
    @IBOutlet var messageTextField: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var currencyButton: UIBarButtonItem!

    
    var contacts: [String]?
    
    var currencies: [Currency] = [.ewa, .euro, .iota]
    var currentCurrency: Currency = Default.currency
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendButton.layer.cornerRadius = 8
        recipientTextField.delegate = self
        updateContacts()
        tableView.setBackgroundImage()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateLabel(with: "")
    }
    
    
    
    
    @IBAction func currencyButtonPressed(_ sender: Any) {
        
        toggleCurrency()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        verifyFields()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.size.height / 6
    }
    
    fileprivate func barTitle() -> String {
 
        switch currentCurrency {
            
        case .ewa:
            return User.currentUser()?.balance?.ewa.roundedString() ?? "0"
        case .iota:
            if let iotaAmount = User.currentUser()?.balance?.iota {
                
                return Double(iotaAmount).roundedAsIntString()
                
            } else {
                
                return "0"
            }
        case .euro:
            return User.currentUser()?.balance?.eur.roundedString() ?? "0"
        }
    }
    
    
    fileprivate func toggleCurrency() {
    
        let index = currencies.index(of: currentCurrency)
        
        let currency = (index == currencies.count - 1) ? currencies.first! : currencies[index! + 1]
        
        currentCurrency = currency
        Default.currency = currency
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        
        navigationController?.navigationBar.topItem?.title = barTitle()
        currencyButton.title = currentCurrency.rawValue
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if contacts == nil {
            
            updateContacts()
        }
        return true
    }
    
    
    fileprivate func updateContacts() {
        
        NetworkProvider.fetchContacts(completion: { [unowned self](contacts) in
            
            self.contacts = contacts
            
            self.recipientTextField.configure(for: contacts)
        })
    }


    
    fileprivate func verifyFields() {
        
        guard let recipient = recipientTextField.text?.dropFirst(),
            !recipient.isEmpty else {
            
            show(messageLabel: "Address missing or incorrect")
            return
        }
        
        guard let amount = amountTextField.text?.doubleValue,
            amount > 0 else {
            
            show(messageLabel: "Enter a valid amount")
            return
        }
        
        sendPayment(for: amount, to: String(recipient), withMessage: messageTextField.text)
    }
    
    
    fileprivate func resetFields() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.recipientTextField.text = nil
            self?.amountTextField.text = nil
            self?.messageTextField.text = nil
        }
    }

    
    func sendPayment(for amount: Double, to recipient: String, withMessage message: String?) {
        
        if let data = transactionJson(for: amount, withMessage: message) {
            
            NetworkProvider.post(data, to: recipient, completion: { [weak self] (postWasSuccesful, message) in

                if postWasSuccesful {
                    
                    self?.resetFields()
                }
                
                self?.updateLabel(with: message)

                self?.view.endEditing(true)
            })
        }
    }
    
    
    fileprivate func updateLabel(with message:String) {
        
        DispatchQueue.main.async {[weak self] in
            
            self?.show(messageLabel: message)
        }
    }
    
    
    func show(messageLabel message: String) {
        
        messageLabel.text = message
        
        if !message.isEmpty {
            
            tableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .bottom, animated: true)
        }
    }
    
    
    func transactionJson(for amount: Double, withMessage message: String?) -> Data? {
        
        guard let user = User.currentUser(),
            let nickname = user.nickname?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let password = user.password?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                fatalError("No User")
        }
        
        let transactionDict = ["currency" : currentCurrency.rawValue.lowercased(), "amount" : amount, "message" : message ?? ""] as [String : Any]
        
        let dict = ["username" : nickname,  "password" : password, "tx" : transactionDict] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            return jsonData
            
        } catch {
            
            print(error.localizedDescription)
        }

        return nil
    }
}
