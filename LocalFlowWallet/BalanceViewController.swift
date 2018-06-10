//
//  BalanceViewController.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 04/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class BalanceViewController: UIViewController {
    
    var user: User?

    @IBOutlet var ewaBalaceLabel: UILabel!
    @IBOutlet var iotaBalanceLabel: UILabel!
    @IBOutlet var euroBalanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    fileprivate func configureView() {
        
        ewaBalaceLabel.text = stringFromOptional(user?.balance?.ewa)
        iotaBalanceLabel.text = stringFromOptional(user?.balance?.iota)
        euroBalanceLabel.text = stringFromOptional(user?.balance?.eur)
    }
    
    fileprivate func stringFromOptional<T>(_ value: T?) -> String {
        
        if let value = value as? Double { return String(value) }
        if let value = value as? Int64 { return String(value) }
        return "N/A"
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    

}


