//
//  HTTPManager.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/9/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

// TODO: CacheHandler: HTTPCache

public class HTTPManager {
    
    public var httpSession: HTTPSession!
    public let httpAuthorization: HTTPAuthorization?
    public let httpHeader: HTTPHeaders?
    public let httpDomains: [HTTPDomain]
    public let httpTimeout: TimeInterval
    
    private var header: HTTPHeaders? = nil
    
    public init(httpSession: HTTPSession? = nil,
                httpAuthorization: HTTPAuthorization? = nil,
                httpHeader: HTTPHeaders? = nil,
                httpDomains: [HTTPDomain],
                httpTimeout: TimeInterval = 60,
                concurrency: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        
        self.httpAuthorization = httpAuthorization
        self.httpHeader = httpHeader
        self.httpDomains = httpDomains
        self.httpTimeout = httpTimeout
        self.httpSession = httpSession != nil
            ? httpSession!
            : .init(domains: self.httpDomains, timeout: self.httpTimeout, concurrency: concurrency)
        
        if let _httpHeader = self.httpHeader {
            self.header = _httpHeader
        }
        if let _httpAuthorization = self.httpAuthorization {
            self.header?.add(_httpAuthorization.header)
        }
    }
    
    public func request(endpoint: HTTPEndpoint,
                        method: HTTPMethod = .get,
                        body: Parameters? = nil,
                        encoding: HTTPEncodingOptions = .json,
                        validationRange: ClosedRange<Int>? = nil) -> HTTPRequest {
        
        return HTTPRequest(session: self.httpSession,
                           endpoint: endpoint,
                           method: method,
                           header: self.header,
                           body: body,
                           encoding: encoding,
                           validationRange: validationRange)
    }
    
}
