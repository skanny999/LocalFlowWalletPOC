//
//  TFServicesProvider.swift
//  TokenFolio
//
//  Created by Riccardo Scanavacca on 24/06/2017.
//  Copyright © 2017 Riccardo Scanavacca. All rights reserved.
//

import UIKit
import CoreData

class NetworkProvider {
    
    static func fetchJSON(forUser name: String) {
        
        let urlString = String(format:"https://localflow-pay-poc.herokuapp.com/api/v1/users/\(name)?password=\(name)")
        
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                let jsonDict = json as! [String : Any]
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 200 {
                        
                        let updateManager = UpdateManager()
                        
                        updateManager.processUserJSON(json: jsonDict)
                        
                    } else {
                    
                        if let message = jsonDict["message"] {
                            let notificationCenter = NotificationCenter.default
                            notificationCenter.post(name: NSNotification.Name(rawValue:"LoginResult"), object: nil, userInfo: ["message" : message])
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    
    static func post(_ json: Data, to user: String) {
        
        let urlString = "https://localflow-pay-poc.herokuapp.com/api/v1/users/\(user)/pay"
        
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = json
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                let jsonDict = json as! [String : Any]
                
                if let response = response as? HTTPURLResponse {
                    
                    if response.statusCode == 201 {
                        
                        if let message = jsonDict["message"] as? String, let txOut = jsonDict["tx"] as? [String : Any]{
                            
                            let updateManager = UpdateManager()
                            updateManager.processTxOut(from: txOut)
                            sendResult(message: message)
                        }
                        
                    } else {
                        
                        if let message = jsonDict["message"] as? String {
                            
                            sendResult(message: message)
                            
                        } else {
                            
                            sendResult(message: "Something went wrong!!")
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
   static func sendResult(message: String) {
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: NSNotification.Name(rawValue:"SendResult"), object: nil, userInfo: ["message" : message])
    }
    
}







