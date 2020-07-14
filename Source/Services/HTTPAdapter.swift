//
//  HTTPAdapter.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/9/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public class HTTPAdapter: RequestInterceptor {
    
    public init() {

    }
    
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        completion(.success(urlRequest))
    }
    
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        switch error.asAFError {
        case .requestRetryFailed(retryError: _, originalError: _),
             .serverTrustEvaluationFailed(reason: _),
             .invalidURL(url: _),
             .sessionDeinitialized,
             .responseSerializationFailed(reason: _),
             .responseValidationFailed(reason: _):
            
            completion(.doNotRetry)
        default:
            completion(.retry)
        }
        
    }
}
