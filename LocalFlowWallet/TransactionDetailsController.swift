//
//  TransactionDetailsController.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 03/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class TransactionDetailsController: UITableViewController {

    var transaction: Transaction?
    
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var userLabel: UILabel!
    @IBOutlet var transactionDateLabel: UILabel!
    @IBOutlet var confirmationLabel: UILabel!
    @IBOutlet var iotaTxIdLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    
    @IBOutlet var viewTransactionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setBackgroundImage()
        self.navigationController?.navigationBar.tintColor = UIColor(hue: 0.5333, saturation: 0.62, brightness: 0.62, alpha: 1.0)
        viewTransactionButton.layer.cornerRadius = 8
        configureDetails()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 4
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return tableView.frame.size.height / 6
    }
    
    
    func configureDetails() {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "yyyy MMM HH:mm EEEE"
        
        if let amount = transaction?.amount, let currency = transaction?.currency?.uppercased() {
            
            let formattedAmount = currency == "IOTA" ? "\(Int(amount))" : "\(amount)"
            amountLabel.text = "\(formattedAmount) \(currency)"
        }
        
        
        if let outgoing = transaction?.outgoing {
            
            if outgoing {
                
                if let receiver = transaction?.toNickname {
                    
                    userLabel.text = "Sent to \(receiver)"
                }
                
            } else {
                
                if let sender = transaction?.fromNickname {
                    
                    userLabel.text = "Received from \(sender)"
                }
            }
        }
        
        if let message = transaction?.message, !message.isEmpty {
            
            messageLabel.text = "Message:\n\n\(message)"
        }
        
        if let created = transaction?.createdAt {
            
            transactionDateLabel.text = created.dateString()
        }
        
        
        if let confirmed = transaction?.confirmed {

            confirmationLabel.text = confirmed ? "Transaction Confirmed" : "Awaiting confirmation"
        }
        
        
        viewTransactionButton.isEnabled = isIotaTransaction()
        iotaTxIdLabel.text = isIotaTransaction() ? "Iota tx Id: \(transaction!.iotaId!)" : ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "TRANSACTION_SEGUE" {
            
            let destination = segue.destination as! TransactionWebViewController
            
            if let txLink = transaction?.iotaTxHref {
                
                destination.transactionUrlString = txLink
            }
        }
    }
    
    
    
    func isIotaTransaction() -> Bool {
        
        guard let transId = transaction?.iotaId, let transLink = transaction?.iotaTxHref else { return false }
        
        print(transId, transLink)
        
        return true
    }
}
