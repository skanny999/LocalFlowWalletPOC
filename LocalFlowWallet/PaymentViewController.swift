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
        
        processPayment()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.size.height / 6
    }
    
    
    fileprivate func barTitle() -> String {
 
        switch currentCurrency {
            
        case .ewa:
            return User.currentUser()?.balance?.ewa.roundedString() ?? "0"
        case .iota:
            return showIotaBalanceString()
        case .euro:
            return User.currentUser()?.balance?.eur.roundedString() ?? "0"
        }
    }
    
    fileprivate func showIotaBalanceString() -> String {
        
        let iotaAmount = User.currentUser()?.balance?.iota ?? 0
        return Double(iotaAmount).roundedAsIntString()
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
        
        NetworkProvider.fetchContacts(completion: { [weak self](contacts) in
            
            self?.contacts = contacts
            
            self?.recipientTextField.configure(for: contacts)
        })
    }

    
    fileprivate func processPayment() {
        
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
        
        NetworkProvider.sendPayment(for: amount, currency: currentCurrency, to: String(recipient), withMessage: messageTextField.text) { [weak self] (success: Bool, message: String?) in
            
            if success {
                
                self?.resetFields()
            }
            
            self?.updateLabel(with: message ?? "")
        }
    }
     


}