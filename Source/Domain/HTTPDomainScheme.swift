//
//  DomainScheme.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/8/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public class HTTPDomainScheme {
    
    public let scheme: String
    public let url: URL?
    public let request: URLRequest?
    
    public private (set) lazy var hasSSL: Bool = {
        return scheme.contains("https")
    }()
    
    public private (set) lazy var host: String = {
        return self.url?.host ?? self.scheme
    }()
    
    public private (set) lazy var ipAddress: String = {
        guard let host = self.host.withCString({gethostbyname($0)}),
            host.pointee.h_length > 0 else {
                return ""
        }
        var addr = in_addr()
        memcpy(&addr.s_addr, host.pointee.h_addr_list[0], Int(host.pointee.h_length))
        guard let remoteIPAsC = inet_ntoa(addr) else { return "" }
        return String(cString: remoteIPAsC)
    }()
    
    public var isReachable: Bool {
        let reachablitiy = NetworkReachabilityManager(host: self.scheme)
        return reachablitiy?.isReachable == true
    }
    
    public init(scheme: String) {
        self.scheme = scheme
        self.url = URL(string: scheme)
        self.request = url != nil ? URLRequest(url: self.url!) : nil
    }
    
}
