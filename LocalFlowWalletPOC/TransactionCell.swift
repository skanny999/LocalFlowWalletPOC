//
//  transactionCell.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 12/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet var txInPaymentArrow: UIImageView!
    @IBOutlet var txOutPaymentArrow: UIImageView!
    
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var toFromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    func configure(with transaction: Transaction) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .short
        
        amountLabel.text = "\(transaction.amount!) EWA"
        dateLabel.text = formatter.string(from: transaction.createdAt! as Date)
        
        if transaction.outgoing {
            
            txOutPaymentArrow.image = #imageLiteral(resourceName: "arrow")
            txOutPaymentArrow.tintColor = transaction.confirmed ? UIColor.white : UIColor.yellow
            txInPaymentArrow.image = nil
            
            toFromLabel.text = "To \(transaction.toNickname!)"
            
        } else {
            
            txOutPaymentArrow.image = nil
            txInPaymentArrow.image = #imageLiteral(resourceName: "arrow")
            txInPaymentArrow.tintColor = transaction.confirmed ? UIColor.white : UIColor.yellow
            toFromLabel.text = "From \(transaction.fromNickname!)"
        }
        
    }
    
    
    
    

}
