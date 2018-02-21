//
//  PaymentViewController.swift
//  LocalFlowWalletPOC
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
    
    
    
    
    @IBAction func currencyButtonPressed(_ sender: Any) {
        
        toggleCurrency()
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        verifyFields()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.size.height / 5
    }
    
    fileprivate func barTitle() -> String {

        switch currentCurrency {
        case .ewa:
            return User.currentUser()?.balance?.ewa ?? "0"
        case .iota:
            return User.currentUser()?.balance?.iota ?? "0"
        case .euro:
            return User.currentUser()?.balance?.eur ?? "0"
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
            
            messageLabel.text = "Address missing"
            return
        }
        
        guard let amount = amountTextField.text?.doubleValue,
            amount > 0 else {
            
            messageLabel.text = "Enter a valid amount"
            return
        }
        
        sendPayment(for: amount, to: String(recipient))
    }
    
    
    fileprivate func resetFields() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.recipientTextField.text = nil
            self?.amountTextField.text = nil
            self?.messageTextField.text = nil
        }
    }
    
    

    
    func sendPayment(for amount: Double, to recipient: String) {
        
        if let data = transactionJson(for: amount) {
            
            NetworkProvider.post(data, to: recipient, completion: { [unowned self] (postWasSuccesful, message) in

                if postWasSuccesful {
                    
                    self.resetFields()
                }
                
                DispatchQueue.main.async {[weak self] in
                    
                    self?.messageLabel.text = message
                    self?.tableView.scrollToRow(at: IndexPath(row: 4, section: 0), at: .bottom, animated: true)
                }
            })
        }
    }
    
    
    func transactionJson(for amount: Double) -> Data? {
        
        guard let user = User.currentUsers()?.first, let nickname = user.nickname else { fatalError("No User") }

        let transactionDict = ["amount" : amount, "currency" : currentCurrency.rawValue.lowercased()] as [String : Any]
        
        let dict = ["password" : nickname, "tx" : transactionDict] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            return jsonData
            
        } catch {
            
            print(error.localizedDescription)
        }

        return nil
    }
}
