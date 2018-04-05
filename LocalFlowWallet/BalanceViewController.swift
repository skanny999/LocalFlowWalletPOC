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
        
        if let user = user, let balance = user.balance {
            
            ewaBalaceLabel.text = String(balance.ewa)
            iotaBalanceLabel.text = String(balance.iota)
            euroBalanceLabel.text = String(balance.eur)
            
        } else {
            
            ewaBalaceLabel.text = "N/A"
            iotaBalanceLabel.text = "N/A"
            euroBalanceLabel.text = "N/A"
            
        }
        
    }

    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        navigationController?.dismiss(animated: true, completion: nil)
        
    }
    
}
