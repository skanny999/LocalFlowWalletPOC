//
//  Extensions.swift
//  LocalFlowWalletPOC
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
    

