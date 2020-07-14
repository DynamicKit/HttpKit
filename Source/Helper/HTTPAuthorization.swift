//
//  HTTPAuthorization.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/12/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public struct HTTPAuthorization {
    
    public let type: String
    public let username: String?
    public let password: String?
    public let credentials: String

    public var key: String {
        return "Authorization"
    }
    
    public var value: String {
        return self.type + " " + self.credentials
    }
    
    public var dictionary: [String: Any] {
        return [self.key: self.value]
    }
    
    public var header: HTTPHeader {
        return .init(name: self.key, value: self.value)
    }
    
    
    public lazy var urlCredentials: URLCredential? = {
        return (self.username != nil && self.password != nil)
            ? URLCredential(user: self.username!, password: self.password!, persistence: .synchronizable)
            : nil
    }()
    
    
    public init(type: String = "Basic", username: String, password: String) {
        self.type = type
        self.username = username
        self.password = password
        self.credentials = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() ?? ""
    }
    
    public init(type: String, credentials: String) {
        self.type = type
        self.username = nil
        self.password = nil
        self.credentials = credentials
    }
    
}
