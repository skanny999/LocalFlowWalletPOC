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
        
            
        if let currency = transaction.currency?.uppercased() {
                
            let formattedAmount = currency == "IOTA" ? "\(Int(transaction.amount))" : "\(transaction.amount.roundToDecimal(2))"
            amountLabel.text = "\(formattedAmount) \(currency)"
        }

        
        if let creationDate = transaction.createdAt {
            
            dateLabel.text = formatter.string(from: creationDate as Date)
        }
        
        let green = UIColor(hue: 167/360, saturation: 100/100, brightness: 95/100, alpha: 1.0)
        
        if transaction.outgoing {
            
            txOutPaymentArrow.image = #imageLiteral(resourceName: "arrow")
            txOutPaymentArrow.tintColor = transaction.confirmed ? green : UIColor.yellow
            txInPaymentArrow.image = nil
            
            toFromLabel.text = "To \(transaction.toNickname!)"
            
        } else {
            
            txOutPaymentArrow.image = nil
            txInPaymentArrow.image = #imageLiteral(resourceName: "arrow")
            txInPaymentArrow.tintColor = transaction.confirmed ? green : UIColor.yellow
            toFromLabel.text = "From \(transaction.fromNickname!)"
        }
        
    }
    
    
    
    

}
