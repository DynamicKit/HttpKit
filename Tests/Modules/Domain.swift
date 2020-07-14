//
//  Domain.swift
//  RouterTests
//
//  Created by Mohammad reza Koohkan on 2/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
@testable import HttpKit

enum Domain: HTTPDomain {
    
    static let current = Domain.github
    
    case github
    case mohamadrezacodes
    case swapi
    case jsonPlaceholder
    case custom(String)
    
    var resolve: HTTPDomainScheme {
        switch self {
        case .github:
            return .init(scheme: "https://raw.githubusercontent.com/mohamadrezakoohkan/Router/master/")
        case .mohamadrezacodes:
            return .init(scheme: "https://mohamadreza.codes/api/")
        case .swapi:
            return .init(scheme: "https://swapi.py4e.com/api/")
        case .jsonPlaceholder:
            return .init(scheme: "https://jsonplaceholder.typicode.com/")
        case .custom(let domain):
            return .init(scheme: domain)
        }
    }
    
    
}
