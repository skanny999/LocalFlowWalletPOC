//
//  PaymentViewControllerExtensions.swift
//  LocalFlowWallet
//
//  Created by Riccardo on 10/06/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation

extension PaymentViewController {
    
    
    func resetFields() {
        
        DispatchQueue.main.async { [weak self] in
            
            self?.recipientTextField.text = nil
            self?.amountTextField.text = nil
            self?.messageTextField.text = nil
        }
    }
    
    func updateLabel(with message:String) {
        
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
    
    
    
    
    
}
