//
//  HTTPSession.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/11/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public protocol HTTPSessionDelegate {
    //    func requestDidComplete(_ session: URLSession,
    //                            task: URLSessionTask,
    //                            error: Error?)
}

public class HTTPSession: Alamofire.Session {
    
    public static let shared: HTTPSession = HTTPSession()
    
    public var httpSessionDelegate: HTTPSessionDelegate?
    public let httpSessionConfiguration: URLSessionConfiguration
    public let httpSession: URLSession
    public private (set) var httpAdapter: HTTPAdapter?
    public let httpDomains: [HTTPDomain]
    
    private let sessionDelegate: Alamofire.SessionDelegate
    private let evaluators: [String: ServerTrustEvaluating]
    private let trustManager: ServerTrustManager
    private let certificateEvaluator = PinnedCertificatesTrustEvaluator(acceptSelfSignedCertificates: true)
    
    private let rootQueID = "org.alamofire.session.rootQueue"
    private let delegateQueueID = "org.alamofire.session.sessionDelegateQueue"

    
    public init(configuration: URLSessionConfiguration = URLSessionConfiguration.af.default,
                delegate requestDelegate: HTTPSessionDelegate? = nil,
                sessionDelegate: Alamofire.SessionDelegate = .init(),
                adapter: HTTPAdapter? = .init(),
                domains: [HTTPDomain] = [],
                timeout: TimeInterval = 60,
                concurrency: Int = OperationQueue.defaultMaxConcurrentOperationCount) {
        
        configuration.timeoutIntervalForRequest = timeout
        configuration.timeoutIntervalForResource = timeout

        let rootQue = DispatchQueue(label: self.rootQueID)
        let delegateQueue = OperationQueue(maxConcurrentOperationCount: concurrency, underlyingQueue: rootQue, name: self.delegateQueueID)
        let trust = PinnedCertificatesTrustEvaluator(acceptSelfSignedCertificates: true)
        let afSession = URLSession(configuration: configuration, delegate: sessionDelegate, delegateQueue: delegateQueue)
        let tupleEvaluators = domains.flatMap { [$0.resolve.scheme: trust] }
        
        self.httpSession = afSession
        self.httpSessionConfiguration = configuration
        self.httpSessionDelegate = requestDelegate
        self.sessionDelegate = sessionDelegate
        self.httpAdapter = adapter
        self.httpDomains = domains
        self.evaluators = Dictionary(tupleEvaluators, uniquingKeysWith: { (first, last) in last })
        self.trustManager = ServerTrustManager(allHostsMustBeEvaluated: false, evaluators: self.evaluators)
        
        super.init(session: self.httpSession,
                   delegate: self.sessionDelegate,
                   rootQueue: rootQue,
                   startRequestsImmediately: true,
                   interceptor: self.httpAdapter,
                   serverTrustManager: self.trustManager,
                   cachedResponseHandler: nil)
    }
    
    
}



