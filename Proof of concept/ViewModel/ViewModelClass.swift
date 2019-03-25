//
//  ViewModelClass.swift
//  Proof of concept
//
//  Created by MAC on 17/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class viewModel {
    private var model = Data()
}

extension viewModel {
    
    func internetAvailable () -> Bool {
        
        if isConnectedToNetwork() {
            return true
        } else {
            return false
        }
    }
    
    func getAllDataAPI(vc: UIViewController, completion: @escaping ([Data]) -> Void) {
        
        if  internetAvailable() == false {
            alertViewWithCompletion(alertMsg: INTERNET_CONNECTION, vc: vc, completion: {})
            return
        }
        else {
            
            URLSession.shared.dataTask(with: URL(string: API_URL)!) { (data, res, err) in
                
                if let d = data {
                    
                    if let value = String(data: d, encoding: String.Encoding.ascii) {
                        
                        if let jsonData = value.data(using: String.Encoding.utf8) {
                           
                            do {
                                let data = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                let json = JSON.init(data)
                             
                                DispatchQueue.main.async {
                                    vc.title = json["title"].string ?? ""
                                }
                                
                                if let arr = json["rows"].array  {
                                    
                                    var arr_data = [Data]()

                                    for item in arr {
                                        
                                        self.model.title = item["title"].string ?? "N/A"
                                        self.model.description = item["description"].string ?? "N/A"
                                        self.model.imageHref = item["imageHref"].string ?? ""
                                        
                                        arr_data.append(self.model)
                                    }
                                    completion(arr_data)
                                }
                                
                            } catch {
                                NSLog("ERROR \(error.localizedDescription)")
                            }
                        }
                    }
                    
                } else {
                    alertViewWithCompletion(alertMsg: MSG_ERROR, vc: vc, completion: {})
                    print("Request failed with error: \(err!)")
                }
                }.resume()
        }
    }
}

