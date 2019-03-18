//
//  TestClass.swift
//  Proof of conceptTests
//
//  Created by MAC on 18/03/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import XCTest
import SystemConfiguration
class TestClass: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
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
