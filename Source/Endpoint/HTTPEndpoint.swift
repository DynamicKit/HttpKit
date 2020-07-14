//
//  HTTPEndpoint.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/10/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation

public protocol HTTPEndpoint {
    var resolve: HTTPEndpointScheme { get }
    var value: String { get }
    func add(to url: String, _ parameter: Any?) -> String
}

public extension HTTPEndpoint {
    func add(to url: String, _ parameter: Any?) -> String {
        return "\(url)\(parameter == nil ? "" : "\(parameter!)/")"
    }
}
