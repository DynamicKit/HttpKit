//
//  Endpoint.swift
//  RouterTests
//
//  Created by Mohammad reza Koohkan on 2/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
@testable import HttpKit


enum Endpoint: HTTPEndpoint {
        
    case dictionary
    case collection
    case string
    case bool
    case int
    case string2
    case car
    case factories
    case people(Int? = nil)
    case todos(Int? = nil)
    
    var value: String {
        switch self {
        case .dictionary:
            return "Router/cloud/dictionary.json"
        case .collection:
            return "Router/cloud/collection.txt"
        case .string:
            return "Router/cloud/string"
        case .bool:
            return "Router/cloud/bool"
        case .int:
            return "Router/cloud/int"
        case .string2:
            return "string.hoxpz"
        case .car:
            return "Router/cloud/car.json"
        case .factories:
            return "Router/cloud/factories.json"
        case .people(let id):
            return self.add(to: "people/", id)
        case .todos(let id):
            return self.add(to: "todos/", id)
        }
    }
    
    var resolve: HTTPEndpointScheme {
        switch self {
        case .string2:
            return .init(domain: Domain.mohamadrezacodes, endpoint: self.value)
        case .people(_):
            return .init(domain: Domain.swapi, endpoint: self.value)
        case .todos(_):
            return .init(domain: Domain.jsonPlaceholder, endpoint: self.value)
        default:
            return .init(domain: Domain.github, endpoint: self.value)
            
        }
    }
    
    
}
