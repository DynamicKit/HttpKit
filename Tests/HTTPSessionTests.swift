//
//  HTTPSessionTests.swift
//  HTTPSessionTests
//
//  Created by Mohammad reza Koohkan on 4/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import XCTest
@testable import HttpKit

class HTTPSessionTests: XCTestCase {
    
    var sut: HTTPSession!
    
    override func tearDown() {
        super.tearDown()
        self.sut = nil
    }
    
    override func setUp() {
        super.setUp()
        self.sut = .shared
    }
    
    func testHttpRequest() {
        let expectations = expectation(description: "Expect to get a car from HTTPRequest")
        let request = HTTPRequest(session: self.sut, endpoint: Endpoint.car)
        request.response(decodable: Car.self) { (result) in
            switch result {
            case .success(let car):
                car.model == nil ? XCTFail() : expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail car is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testDataRequest() {
        let expectations = expectation(description: "Expect to get a car from HTTPRequest")
        let request = self.sut.request(Endpoint.car.resolve)
        request.responseDecodable(of: Car.self) { (response) in
            switch response.result {
            case .success(let car):
                car.model == nil ? XCTFail() : expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail car is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
}
