//
//  ViewModelClass.swift
//  Proof of concept
//
//  Created by MAC on 17/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation

import UIKit

class viewModel {
    
    private var model = Data()
    var arr_data = [Data]()
}

extension viewModel {
    
    func internetAvailable () -> Bool {
        
        if isConnectedToNetwork() {
            return true
        } else {
            return false
        }
    }
    
    func alertViewWithCompletion(alertMsg:String , vc: UIViewController,completion: @escaping () -> Void) {
        
        let alertConroller = UIAlertController.init(title: APP_NAME, message: alertMsg, preferredStyle: .alert)
        let action = UIAlertAction.init(title: "OK", style: .`default`) { (action) in
            completion()
        }
        alertConroller.addAction(action)
        vc.present(alertConroller, animated: true, completion: nil)
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
                                let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
                                DispatchQueue.main.async {
                                vc.title = json["title"] as? String ?? ""
                                }
                                if let arr = json["rows"] as? [[String : Any]]  {
                                    
                                    for item in arr {
                                        
                                        self.model.title = item["title"] as? String ?? "N/A"
                                        self.model.description = item["description"] as? String ?? "N/A"
                                        self.model.imageHref = item["imageHref"] as? String ?? "N/A"
                                        
                                        self.arr_data.append(self.model)
                                        
                                        completion(self.arr_data)
                                    }
                                }
                                
                            } catch {
                                NSLog("ERROR \(error.localizedDescription)")
                            }
                        }
                    }
                    
                } else {
                    self.alertViewWithCompletion(alertMsg: MSG_ERROR, vc: vc, completion: {})
                    print("Request failed with error: \(err)")
                }
                }.resume()
        }
    }
}

