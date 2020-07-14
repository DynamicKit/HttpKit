//
//  EndpointScheme.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public class HTTPEndpointScheme: URLConvertible {
    
    public let domain: HTTPDomain
    public let endpoint: String
    public let urlString: String
    public let url: URL?
    
    public init(domain: HTTPDomain, endpoint: String) {
        self.domain = domain
        self.endpoint = endpoint
        self.urlString = domain.resolve.scheme + endpoint
        self.url = URL(string: self.urlString)
    }
    
    public func asURL() throws -> URL {
        if let _url = self.url {
            return _url
        }else{
            throw AFError.invalidURL(url: self.domain.resolve.scheme + endpoint)
        }
    }
    
}
