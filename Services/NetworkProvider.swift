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
    
    
    static func fetchJSON(forUser name: String, withPassword password: String, completion:@escaping ((Bool, String?) -> Void)) {
        
        let fetchUrl = url(for: name, andPassword: password)
        
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

    
    
    static func post(_ json: Data, to user: String, completion:@escaping (PostCompletion)) {
        
        let request = urlRequest(to: user, with: json)
        
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
    
    
    static func contactsUrl() -> URL {
        
        if let userName = User.currentUser()?.nickname, let password = User.currentUser()?.password {
            
            return URL(string: "https://localflow-pay-poc.herokuapp.com/api/v1/users?username=\(userName)&password=\(password)")!
            
        } else {
            
            fatalError("No user!")
        }
    }
    
    
    static func url(for name: String, andPassword password: String) -> URL {
        
        var urlString: String
        
        if let name = name.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let password = password.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
            
            urlString = "https://localflow-pay-poc.herokuapp.com/api/v1/users/\(name)?username=\(name)&password=\(password)"

        } else {
            
            urlString = "https://localflow-pay-poc.herokuapp.com/api/v1/users/\(name)?username=\(name)&password=\(password)"
        }
        
        return URL(string:urlString)!
    }
    
    
    static func urlRequest(to user: String, with json: Data) -> URLRequest {
        
        var urlString: String
        
        if let user = user.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {

            urlString = "https://localflow-pay-poc.herokuapp.com/api/v1/users/\(user)/pay"

        } else {
        
            urlString = "https://localflow-pay-poc.herokuapp.com/api/v1/users/\(user)/pay"
        }
    
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = ["Accept" : "application/json", "Content-Type" : "application/json"]
        request.httpMethod = "POST"
        request.httpBody = json
        
        return request
    }
}







