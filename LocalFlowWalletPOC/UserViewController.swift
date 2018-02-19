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
    
    var fetchedResultsController: NSFetchedResultsController<Transaction>!
    
    var user: User?
    
    @IBOutlet var ewaAmountLabel: UILabel!
    @IBOutlet var euroAmountLabel: UILabel!
    @IBOutlet var iotaAmountLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFetchedResultsController()
        tableView.setBackgroundImage()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadUser()
    }
    
    fileprivate func loadUser() {
        
        user = User.currentUsers()?.first
        
        if User.currentUsers()?.count == 0 {
            
            self.performSegue(withIdentifier: "LOGIN_SEGUE", sender: nil)
        }
        
        performFetch()
        configureLabels()
    }
    

    
    
    func configureLabels() {
        
        if let user = user {
            
            navigationController?.navigationBar.topItem?.title = user.nickname?.capitalized
            ewaAmountLabel.text = "\(user.balance?.ewa ?? "0") EWA"
            euroAmountLabel.text = "\(user.balance?.eur ?? "0") Euros"
            iotaAmountLabel.text = "\(user.balance?.iota ?? "0") Iota"
        }
    }
    
    fileprivate func configureBackground() {
        
        let backgroundImageView = UIImageView(image: #imageLiteral(resourceName: "Background"))
        backgroundImageView.frame = tableView.frame
        tableView.backgroundView = backgroundImageView
    }
    
    
    func configureFetchedResultsController() {
        
        fetchedResultsController = CoreDataProvider.shared.transactionsFetchResultController()
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
