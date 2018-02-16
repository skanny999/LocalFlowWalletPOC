//
//  Extensions.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 13/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation
import UIKit


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
    
//     func withoutFirstChar() -> String? {
//
//        var string = self
//
//        let char = string.dropFirst()
//
//
//        
//
//        return String(char)
//
//    }
    
}




extension UIColor {
    
    
    
    
    
}
