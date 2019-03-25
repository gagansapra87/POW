//
//  Constant.swift
//  Proof of concept
//
//  Created by MAC on 17/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit

let API_URL = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
let APP_NAME = "Proof of Concept"
let INTERNET_CONNECTION = "Please check your internet."
let MSG_ERROR = "Something went wrong."
let REFRESH = "Refresh Data ..."

//MARK: AlertConrollerMethod

func alertViewWithCompletion(alertMsg:String , vc: UIViewController,completion: @escaping () -> Void) {
    
    let alertConroller = UIAlertController.init(title: APP_NAME, message: alertMsg, preferredStyle: .alert)
    let action = UIAlertAction.init(title: "OK", style: .`default`) { (action) in
        completion()
    }
    alertConroller.addAction(action)
    vc.present(alertConroller, animated: true, completion: nil)
}

//MARK: IsConnectedToNetwork

public func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    if flags.isEmpty {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
