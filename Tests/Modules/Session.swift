//
//  Session.swift
//  RouterTests
//
//  Created by Mohammad reza Koohkan on 4/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
@testable import HttpKit

class Session {
    
    static let shared: HTTPSession = {
        let config = URLSessionConfiguration.default
        return HTTPSession(configuration: config,
                           delegate: nil,
                           adapter: nil,
                           domains: [],
                           timeout: 3)
    }()
}
