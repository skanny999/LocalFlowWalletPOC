//
//  TransactionWebViewController.swift
//  LocalFlowWallet
//
//  Created by Riccardo Scanavacca on 04/03/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import WebKit

class TransactionWebViewController: UIViewController {
    
    var transactionUrlString: String?
    
    @IBOutlet weak var webview: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureWebView()
    }

    
    fileprivate func configureWebView() {
        
        if let transactionUrlString = transactionUrlString,
            let transactionUrl = URL(string:transactionUrlString) {
           
            webview.load(URLRequest(url: transactionUrl))
        }
    }
    
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
