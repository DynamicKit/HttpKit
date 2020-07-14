//
//  HTTPManagerTests.swift
//  HTTPManagerTests
//
//  Created by Mohammad reza Koohkan on 2/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import XCTest
import Alamofire
@testable import HttpKit

extension String {
    var bool: Bool { self == "1" || self == "true" || self == "True" || self == "yes" }
}

class HTTPManagerTests: XCTestCase {
    
    var sut: Manager!
    let bool = true
    let int = 12300
    let string = "Hello world!"
    let string2 = "Hello world"
    let dictionary = ["test": 100]
    let collection: [Double] = [13.213,123.1,63.1,3.14]
    
    override func setUp() {
        super.setUp()
        self.sut = .shared
    }
    
    override func tearDown() {
        super.tearDown()
        self.sut = nil
    }
    
    func testDict() {
        let expectations = expectation(description: "Expect to get \(self.dictionary)")
        let request = self.sut!.dictionaryRequest
        request.response { (result: Result<[String: Any], Error>) in
            switch result {
            case .success(let json):
                guard json["test"] as? Int == self.dictionary["test"]
                    else {
                        XCTFail("Fail \(json)")
                        return
                }
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail json is nil, error: \(error)")
            }
            
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testCollection() {
        let expectations = expectation(description: "Expect to get \(self.collection.last ?? -1)")
        let request = self.sut!.collectionRequest
        request.response { (result: Result<[Double], Error>) in
            switch result {
            case .success(let collection):
                guard collection.last == self.collection.last
                    else {
                        XCTFail("Fail \(collection)")
                        return
                }
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail collection is nil, error: \(error)")
            }
            
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testString() {
        let expectations = expectation(description: "Expect to get \(self.string)")
        let request = self.sut!.stringRequest
        request.response { (result: Result<String?, Error>) in
            switch result {
            case .success(let value):
                guard value == self.string
                    else {
                        XCTFail("Fail \(self.string)")
                        return
                }
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail collection is nil, error: \(error)")
            }
            
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testString2() {
        let expectations = expectation(description: "Expect to get \(self.string)")
        let request = self.sut!.stringRequest2
        request.response { (result: Result<String?, Error>) in
            switch result {
            case .success(let value):
                guard value == self.string2
                    else {
                        XCTFail("Fail \(self.string2)")
                        return
                }
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail collection is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testBool() {
        let expectations = expectation(description: "Expect to get \(self.bool)")
        let request = self.sut!.boolRequest
        request.response { (result: Result<Bool?, Error>) in
            switch result {
            case .success(let value):
                guard value == self.bool else {
                    XCTFail("Fail \(self.string)")
                    return
                }
                expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail collection is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testCar() {
        let expectations = expectation(description: "Expect to get a car")
        let request = self.sut!.carRequest
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
    
    func testFactory() {
        let expectations = expectation(description: "Expect to get a list of factories")
        let request = self.sut!.factoriesRequest
        request.response(decodable: [Factory].self) { (result) in
            switch result {
            case .success(let factories):
                factories.isEmpty ? XCTFail() : expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail factories is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testPeople() {
        let expectations = expectation(description: "Expect to get a people")
        let request = self.sut!.peopleRequest(1)
        request.response(decodable: People.self) { (result) in
            switch result {
            case .success(let people):
                people.films.isEmpty ? XCTFail() : expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail people is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
    
    func testTodo() {
        let expectations = expectation(description: "Expect to get a list of todos")
        let request = self.sut!.todosRequest(nil)
        request.response(decodable: [Todo].self) { (result) in
            switch result {
            case .success(let todos):
                todos.isEmpty ? XCTFail() : expectations.fulfill()
            case .failure(let error):
                XCTFail("Fail todos is nil, error: \(error)")
            }
        }
        wait(for: [expectations], timeout: 30)
    }
}
