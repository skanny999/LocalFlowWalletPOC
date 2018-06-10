//
//  TFServicesProvider.swift
//  TokenFolio
//
//  Created by Riccardo Scanavacca on 24/06/2017.
//  Copyright © 2017 Riccardo Scanavacca. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import SwiftyJSON

class NetworkProvider {
    
    //MARK:- Network Calls
    
    static func fetchContacts(completion: @escaping ([String]) -> Void) {
        
        Alamofire.request(contactsUrl()).responseJSON { (responseData) in

            if let value = responseData.result.value {
                
                let swiftyJsonVar = JSON(value)
                
                if let contacts = swiftyJsonVar.arrayObject {
                    
                    completion(contacts as! [String])
                }
            }
        }
    }
    
    
    static func fetchTransactions(forUser name: String, withPassword password: String, completion: @escaping(NetworkCompletion)) {
        
        let fetchUrl = transactionsUrl(for: name, andPassword: password)
        
        Alamofire.request(fetchUrl).responseJSON { (response) in
            
            if response.result.isFailure {
                
                completion(false, "Something wrong with the connection")
                return
            }
            
            guard let value = response.result.value, let json = JSON(value).dictionaryObject else {
                
                completion(false, "Something wrong with the connection")
                return
            }
            
            if response.response?.statusCode == 200 {
                
                let updateManager = UpdateManager()
                
                updateManager.processUserJSON(json: json, completion: { (processed) in
                    
                    completion(processed, nil)
                })
                
            } else {
                
                completion(false, json["message"] as? String)
            }
        }
    }
    
    static func postTransaction(_ json: Data, to recipient: String, completion: @escaping(NetworkCompletion)) {
        
        let request = postTransactionUrlRequest(to: recipient, with: json)
        
        Alamofire.request(request).responseJSON { (response) in
            
            guard let value = response.result.value, response.result.isSuccess else {
                
                completion(false, "Something wrong with the connection")
                return
            }
            
            let json = JSON(value)
            let message = json["message"].stringValue
            
            if response.response?.statusCode == 201, let transactionDict = json["tx"].dictionaryObject {
                
                let updateManager = UpdateManager()
                updateManager.processTxOut(from: transactionDict)
                
                completion(true, message)
                
            } else {
                
                completion(false, message)
            }
        }
    }
    
    static func sendPayment(for amount: Double, currency: Currency, to recipient: String, withMessage message: String?,  completion: @escaping(NetworkCompletion)) {
        
        if let data = transactionJson(for: amount,currency: currency, withMessage: message) {
            
            self.postTransaction(data, to: recipient, completion: { (postWasSuccesful, message) in
                
                completion(postWasSuccesful, message)
            })
        }
    }

    
    //MARK:- URL Factory
    
    static func contactsUrl() -> URL {
        
        if let userName = User.currentUser()?.nickname,
            let password = User.currentUser()?.password,
            let url = URL(string: "https://localflow-pay-poc.herokuapp.com/api/v1/users?username=\(userName)&password=\(password)") {
            
            return url
            
        } else {
            
            fatalError("No user!")
        }
    }
    
    
    static func transactionsUrl(for name: String, andPassword password: String) -> URL {
        
        if let password = password.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string:"https://localflow-pay-poc.herokuapp.com/api/v1/users/\(unwrapped(name))?username=\(unwrapped(name))&password=\(password)") {
            
            return url
        }
        
        fatalError("Cannot web encode user password")
    }
    
    
    static func postTransactionUrl(for recipient: String) -> URL {
        
        guard let url = URL(string: "https://localflow-pay-poc.herokuapp.com/api/v1/users/\(recipient)/pay") else {
            
            fatalError("Cannot create url for payment recipient")
        }
        return url
    }
    
    static func transactionJson(for amount: Double, currency: Currency, withMessage message: String?) -> Data? {
        
        guard let user = User.currentUser(),
            let nickname = user.nickname?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let password = user.password?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
                fatalError("No User")
        }
        
        let transactionDict = ["currency" : currency.rawValue.lowercased(), "amount" : amount, "message" : message ?? ""] as [String : Any]
        
        let dict = ["username" : nickname,  "password" : password, "tx" : transactionDict] as [String : Any]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            
            return jsonData
            
        } catch {
            
            print(error.localizedDescription)
        }
        
        return nil
    }
    

    // MARK:- URL Transaction Factory
    
    static func postTransactionUrlRequest(to recipient: String, with json: Data) -> URLRequest {

        var request = URLRequest(url: postTransactionUrl(for: recipient))
        request.allHTTPHeaderFields = ["Accept" : "application/json", "Content-Type" : "application/json"]
        request.httpMethod = "POST"
        request.httpBody = json
        return request
    }
    
    fileprivate static func unwrapped(_ name: String?) -> String {
        
        guard let name = name?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else {
            
            fatalError("Cannot web encode user name")
        }
        return name
    }
}







