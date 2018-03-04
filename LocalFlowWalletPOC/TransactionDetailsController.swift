//
//  TransactionDetailsController.swift
//  LocalFlowWalletPOC
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
    
    @IBOutlet var viewTransactionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.setBackgroundImage()
        viewTransactionButton.layer.cornerRadius = 8
        configureDetails()
        
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isIotaTransaction() ? 4 : 3
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return isIotaTransaction() ? tableView.frame.size.height / 6 : tableView.frame.size.height / 5
 
    }
    
    
    func configureDetails() {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .full
        
        if let amount = transaction?.amount, let currency = transaction?.currency?.uppercased() {
            
            amountLabel.text = "\(amount) \(currency)"
        }
        
        
        if let outgoing = transaction?.outgoing {
            
            if outgoing {
                
                if let receiver = transaction?.toNickname {
                    
                    userLabel.text = "To \(receiver)"
                    
                } else {
                    
                    if let sender = transaction?.fromNickname {
                        
                        userLabel.text = "From \(sender)"
                    }
                }
            }
        }
        
        if let created = transaction?.createdAt {
            
            transactionDateLabel.text = "Sent on \(formatter.string(from: created as Date))"
            
        }
        
        if let confirmed = transaction?.confirmed, confirmed {
            
            if let confirmationDate = transaction?.updatedAt {
                
                confirmationLabel.text = "Confirmed on \(formatter.string(from: confirmationDate as Date))"
                
            }
            
        } else {
            
            confirmationLabel.text = "Awaiting confirmation"
            
        }
        
        if isIotaTransaction() {
            
            iotaTxIdLabel.text = "Iota tx Id: \(transaction!.iotaId!)"
            
        }
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
        
        guard let _ = transaction?.iotaId, let _ = transaction?.iotaTxHref else { return false }
        
        return true
    }

}
