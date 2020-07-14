//
//  Request.swift
//  RouterTests
//
//  Created by Mohammad reza Koohkan on 2/9/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire
@testable import HttpKit

class Manager {
    
    static let managerPy: HTTPManager = {
        let auth = HTTPAuthorization(type: "JWT", credentials: "adjodaddwqiwq")
        let head: HTTPHeaders = ["shit": "some headers"]
       let manager = HTTPManager(httpAuthorization: auth,
                                 httpHeader: head,
                                 httpDomains: [Domain.github],
                                 httpTimeout: 10)
        return manager
    }()
    
    static let shared = Manager.init()
    
    let dictionaryRequest = {
        return managerPy.request(endpoint: Endpoint.dictionary)
    }()
    
    let collectionRequest = {
        return managerPy.request(endpoint: Endpoint.collection)
    }()
    
    let stringRequest = {
        return managerPy.request(endpoint: Endpoint.string)
    }()
    
    let boolRequest = {
        return managerPy.request(endpoint: Endpoint.bool)
    }()
    
    let intRequest = {
        return managerPy.request(endpoint: Endpoint.int)
    }()
    
    let stringRequest2 = {
        return managerPy.request(endpoint: Endpoint.string2)
    }()
    
    let carRequest = {
        return managerPy.request(endpoint: Endpoint.car)
    }()
    
    let factoriesRequest = {
        return managerPy.request(endpoint: Endpoint.factories)
    }()
    
    let peopleRequest = { (id: Int?) in
        return managerPy.request(endpoint: Endpoint.people(id))
    }
    
    let todosRequest = { (id: Int?) in
        return managerPy.request(endpoint: Endpoint.todos(id))
    }
    
}
