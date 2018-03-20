//
//  transactionCell.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 12/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    @IBOutlet var txArrowImageView: UIImageView!
    @IBOutlet var txConfirmationImageView: UIImageView!
    
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var toFromLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var confirmedLabel: UILabel!
    
    func configure(with transaction: Transaction) {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateStyle = .short
            
        if let currency = transaction.currency?.uppercased() {
                
            let formattedAmount = currency == "IOTA" ? "\(Int(transaction.amount))" : "\(transaction.amount.roundToDecimal(2))"
            amountLabel.text = "\(formattedAmount) \(currency)"
        }

        confirmedLabel.text = transaction.confirmed ? "Confirmed" : "Granted"

        
        if let creationDate = transaction.createdAt {
            
            dateLabel.text = formatter.string(from: creationDate as Date)
        }
        
        
        txArrowImageView.arrowImage(isOutgoing: transaction.outgoing)
        txConfirmationImageView.confirmationImage(isConfirmed: transaction.confirmed)
        toFromLabel.text = transaction.outgoing ? "To \(transaction.toNickname!)" : "From \(transaction.fromNickname!)"
        
    }
    
    
    
    

}
