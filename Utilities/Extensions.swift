//
//  Extensions.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 13/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import UIKit
import SearchTextField

typealias PostCompletion = (Bool, String) -> Void


extension String {
    
    struct NumFormatter {
        
        static let instance = NumberFormatter()
    }
    
    var doubleValue: Double? {
        
        return NumFormatter.instance.number(from: self)?.doubleValue
        
    }
    
    var integerValue: Int? {
        
        return NumFormatter.instance.number(from: self)?.intValue
    }
}

extension Double {
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
    
    func roundedString() -> String {
        
        return String(roundToDecimal(2))
    }
    
    func roundedAsIntString() -> String {
        
        return String(roundToDecimal(0))
    }
}

extension UITableView {
    
    func setBackgroundImage() {
        
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "Background"))
        backgroundImageView.frame = self.frame
        self.backgroundView = backgroundImageView
    }
}


extension SearchTextField {
    
    func configure(for contacts: [String]?) {
        
        if let contacts = contacts {
            
            self.filterStrings(contacts)
            self.maxNumberOfResults = 5
            self.theme.font = UIFont.systemFont(ofSize: 15)
            self.theme.cellHeight = 40
            self.highlightAttributes = [NSAttributedStringKey.font:UIFont.boldSystemFont(ofSize: 15)]
            self.theme.separatorColor = UIColor (red: 85.0/255.0, green: 180.0/255.0, blue: 250.0/255.0, alpha: 0.8)
            self.theme.borderColor = UIColor (red: 85.0/255.0, green: 180.0/255.0, blue: 250.0/255.0, alpha: 1)
        }
    }
}


extension LoginViewController {
    
    func hideKeyboard() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        
        view.endEditing(true)
    }
}


extension UserViewController {
    
    func showNewTransactionAlert() {
        
        let alert = UIAlertController(title: "Transaction", message: "New transaction received", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension UIImageView {
    
    func arrowImage(isOutgoing:Bool) {
        
        self.image = isOutgoing ? #imageLiteral(resourceName: "arrow_out") : #imageLiteral(resourceName: "arrow_in")
        self.tintColor = .white
    }
    
    func confirmationImage(isConfirmed: Bool) {
        
        let green = UIColor(hue: 167/360, saturation: 100/100, brightness: 95/100, alpha: 1.0)
        
        self.image = isConfirmed ? #imageLiteral(resourceName: "double-tick") : #imageLiteral(resourceName: "checkmark")
        self.tintColor = isConfirmed ? green : .yellow
    }
}


extension NSDate {
    
    func dateString() -> String {
        
        let dateFormatter = DateFormatter()
        let timeFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "en_GB")
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        timeFormatter.dateFormat = "HH:mm:ss zzz"
        
        let dateString = dateFormatter.string(from: self as Date)
        let timeString = timeFormatter.string(from: self as Date)
        
        return "\(dateString) at \(timeString)"
    }
    
}
    

