//
//  DataManager.swift
//  musicsearch
//
//  Created by Javid Poornasir on 7/7/17.
//  Copyright © 2017 Javid Poornasir. All rights reserved.
//

import Foundation
import Alamofire

class DataManager {
    
    class func makeRequest(url: String, completionHandler: @escaping (_ jsonData: [String: AnyObject]?, _ error: Error?) -> ()) {
       
        Alamofire.request(url, method: .get, parameters: nil).responseJSON(completionHandler:  {
            response in
        
            do {
                if response.result.isSuccess {
                    let readableJSON = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as! [String: AnyObject]
                    
                    completionHandler(readableJSON, nil)
                    
                } else {
                    print("PRINTING ERROR(1) IN DATAMANAGER CLASS --- \(response.error!)")
                    completionHandler(nil, response.error)
                }
                
            } catch let error {
                print("PRINTING ERROR(2) IN DATAMANAGER CLASS --- \(error)")
                completionHandler(nil, error)

            }
        })
    }
 
    class func makeRequest1(url: String, completionHandler: @escaping (_ jsonData: [String: AnyObject]?, _ error: Error?) -> ()) {
        
        Alamofire.request(url, method: .get).responseString(completionHandler:  {
            response in
            
            if response.result.isSuccess {
                if let jsonData = response.result.value {
                    let index = jsonData.index(jsonData.startIndex, offsetBy: 7)
                    var jsonString = jsonData.substring(from: index)
                    jsonString = jsonString.replacingOccurrences(of: "\'", with: "\"")
                    
                    if let data = jsonString.data(using: .utf8) {
                        do {
                            let readableJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject]
                            
                            completionHandler(readableJSON, nil)
                            
                        } catch let error {
                            print("PRINTING ERROR(3) IN DATAMANAGER CLASS \(error)")
                            completionHandler(nil, error)

                        }
                    }
                }
            }
        })
    }
}




 
