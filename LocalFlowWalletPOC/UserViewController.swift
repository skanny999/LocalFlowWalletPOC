//
//  UserViewController.swift
//  LocalFlowWalletPOC
//
//  Created by Riccardo Scanavacca on 10/02/2018.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import CoreData

class UserViewController: UITableViewController {
    
    let fetchedResultsController = CoreDataProvider.shared.transactionsFetchResultController()
    
    var user: User?
    var timer: Timer?
    var selectedTransaction: Transaction?
    
    @IBOutlet var ewaAmountLabel: UILabel!
    @IBOutlet var euroAmountLabel: UILabel!
    @IBOutlet var iotaAmountLabel: UILabel!
 
    @IBOutlet var balanceStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 20.0, target: self, selector: #selector(UserViewController.checkForNewTransactions), userInfo: nil, repeats: true)

        configureFetchedResultsController()
        checkForNewTransactions()
        addGestureToBalanceView()
        tableView.setBackgroundImage()
    }
    
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        logout()
    }

    fileprivate func logout() {
        
        UpdateManager.logout()
        
        self.performSegue(withIdentifier: "LOGIN_SEGUE", sender: nil)
    }
    
    fileprivate func addGestureToBalanceView() {
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserViewController.showFullBalance))
        
        balanceStackView.addGestureRecognizer(tap)
    }
    
    @objc func showFullBalance() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let navigationController = storyboard.instantiateViewController(withIdentifier: "NAVIGATION") as! UINavigationController
        
        let balanceViewController = navigationController.viewControllers.first as! BalanceViewController
        
        balanceViewController.user = user
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    
    @objc func checkForNewTransactions() {
        
        UpdateManager.updateNewTransactions { [weak self] (transactionAdded) in
            
            if transactionAdded {
                
                self?.showNewTransactionAlert()
            }
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        performFetch()
        loadUser()
    }
    
    
    fileprivate func loadUser() {
        
        if User.currentUsers()?.count == 0 {
            
            self.performSegue(withIdentifier: "LOGIN_SEGUE", sender: nil)
            
        } else {
            
            user = User.currentUser()
            configureLabels()
        }
    }
    
    
    func configureLabels() {
        
        if let user = user {
            
            navigationController?.navigationBar.topItem?.title = user.nickname?.capitalized
            ewaAmountLabel.text = "\(user.balance?.ewa.roundedString() ?? "0.0") EWA"
            euroAmountLabel.text = "\(user.balance?.eur.roundedString() ?? "0.0") Euros"
            iotaAmountLabel.text = "\(user.balance?.iota ?? 0) Iota"
        }
    }
    
    
    func configureFetchedResultsController() {
        
        fetchedResultsController.delegate = self
    }
    
    
    func performFetch() {
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
}


// MARK: - Table view Data Source

extension UserViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let resultCount = fetchedResultsController.fetchedObjects?.count {
            
            return resultCount
        }
        else {
            
            return 0
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TransactionCell
        
        let transaction = fetchedResultsController.object(at: indexPath)
        
        cell.configure(with: transaction)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transaction = fetchedResultsController.object(at: indexPath)
        self.performSegue(withIdentifier: "DETAILS_SEGUE", sender: transaction)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DETAILS_SEGUE" {

            let destination = segue.destination as! TransactionDetailsController
                
            destination.transaction = sender as? Transaction
        }
    }

}




//MARK: - Fetched results controller delegate

extension UserViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath! as IndexPath], with: UITableViewRowAnimation.automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath! as IndexPath], with: UITableViewRowAnimation.automatic)
        case .update:
            tableView.reloadData()
        case .move:
            tableView.deleteRows(at: [indexPath! as IndexPath], with: UITableViewRowAnimation.automatic)
            tableView.insertRows(at: [indexPath! as IndexPath], with: UITableViewRowAnimation.automatic)
        }
        
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
    }
    
}
