//
//  Structs.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 14/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import Foundation


struct Default {
    
    static var currency: Currency {

        get {
            
            if let rawValue = UserDefaults().string(forKey: "currency"), let currency = Currency(rawValue:rawValue) {
                
                return currency
                
            } else {
                
                return .ewa
            }
        }
        
        set (currency){
            
            UserDefaults().set(currency.rawValue, forKey: "currency")
        }
        
    }
}
