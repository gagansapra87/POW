//
//  TestClass.swift
//  Proof of conceptTests
//
//  Created by MAC on 18/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import XCTest

class TestClass: XCTestCase {
    
    func testApiDataForStatusCode() {
        
        let urlString = URL(string: API_URL)
        let promise = expectation(description: "Success status code = 200")
        if !isConnectedToNetwork() {
           XCTFail("Failed: Internet is not connected")
            return
        }
        let dataTask = URLSession.shared.dataTask(with: urlString!) { data, response, error in
            
            if let error = error {
                //test failed
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    //test failed
                    XCTFail("got status code: \(statusCode)")
                }
            }
        }
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
}
