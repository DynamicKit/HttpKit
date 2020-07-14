//
//  HTTPRequest.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/9/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public class HTTPRequest: CustomStringConvertible {
    
    public let endpoint: HTTPEndpoint
    public let header: Alamofire.HTTPHeaders?
    public let encoding: HTTPEncodingOptions
    public let validationRange: ClosedRange<Int>?
    public weak var request: DataRequest?
    public unowned let session: HTTPSession
    public private (set) var body: Alamofire.Parameters?
    public private (set) var method: Alamofire.HTTPMethod
    
    
    public init(session: HTTPSession = .shared,
                endpoint: HTTPEndpoint,
                method: Alamofire.HTTPMethod = .get,
                header: Alamofire.HTTPHeaders? = nil,
                body: Alamofire.Parameters? = nil,
                encoding: HTTPEncodingOptions = .json,
                validationRange: ClosedRange<Int>? = nil) {
        
        self.endpoint = endpoint
        self.method = method
        self.session = session
        self.header = header
        self.body = body
        self.encoding = encoding
        self.validationRange = validationRange
        self.createRequest()
    }
    
    
    /// Be careful this method create new instace of DataRequest and deinitialize previous one in method chaining procedure
    @discardableResult
    public func method(_ httpMethod: HTTPMethod) -> HTTPRequest {
        self.method = httpMethod
        return self.createRequest()
    }
    
    /// Be careful this method create new instace of DataRequest and deinitialize previous one in method chaining procedure
    @discardableResult
    func body(_ httpBody: Alamofire.Parameters?) -> HTTPRequest {
        self.body = httpBody
        return self.createRequest()
    }
    
    private var validationRangeDescription: String {
        if let range = self.validationRange {
            return String(describing: range)
        }else{
            return "Alamofire default validation range"
        }
    }
    
    public var description: String {
        return """
        @HTTP Endpoint: \(self.endpoint.resolve.urlString)
        @HTTP Method: \(self.method.rawValue)
        @HTTP Session: \(String(describing: self.session.self))
        @HTTP Header: \(self.header ?? [:])
        @HTTP Body: \(self.body ?? [:])
        @HTTP Encoding: \(String(describing: self.encoding.resolve.self))
        @HTTP ValidationRange: \(self.validationRangeDescription)
        """
    }
    
    private func errorHandler(_ err: AFError) {
        
    }
    
    @discardableResult
    public func createRequest() ->  HTTPRequest {
        self.request = nil
        self.request = session.request(self.endpoint.resolve,
                                       method: self.method,
                                       parameters: self.body,
                                       encoding: self.encoding.resolve,
                                       headers: self.header)
        
        if let range = self.validationRange {
            self.request?.validate(statusCode: range)
        }else{
            self.request?.validate()
        }
        return self
    }
    
    
    public func response<T>(file: String = #file,
                            line: UInt = #line,
                            function: String = #function,
                            _ completion: @escaping (Result<T, Error>) -> Void) {
        let url = self.endpoint.resolve.urlString
        
        guard let req = self.request else {
            print("@HTTP No DataRequest found - first create request using createRequest method")
            completion(.failure(HTTPError.invalidRequest(url)))
            return
        }
        req.responseJSON { [weak self] (res) in
            guard let self = self else {
                completion(.failure(HTTPError.requestObjectDeinitialized))
                return
            }
            var log = HTTPLog(request: self, response: res)
            log.print(file: file, line: line, function: function)
            
            switch res.result {
            case .success(let value):
                if let result = value as? T {
                    completion(.success(result))
                }else{
                    print("@HTTP Error \(url) not retriving \(T.self) but getting: \(value)")
                    completion(.failure(HTTPError.diffrentResponse))
                }
            case .failure(let error):
                self.errorHandler(error)
                completion(.failure(error))
            }
        }
    }
    
    public func response<T: Codable>(decodable: T.Type,
                                     decoder: JSONDecoder = JSONDecoder(),
                                     file: String = #file,
                                     line: UInt = #line,
                                     function: String = #function,
                                     _ completion: @escaping (Result<T, Error>) -> Void) {
        guard let req = self.request else {
            print("@HTTP No DataRequest found - first create request using createRequest method")
            completion(.failure(HTTPError.invalidRequest(self.endpoint.resolve.urlString)))
            return
        }
        req.responseDecodable(of: decodable, decoder: decoder) {
            [weak self] (response: DataResponse<T, AFError>) in
            guard let self = self else {
                completion(.failure(HTTPError.requestObjectDeinitialized))
                return
            }
            var log = HTTPLog(request: self, response: response, resultType: T.self)
            log.print(file: file, line: line, function: function)
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                self.errorHandler(error)
                completion(.failure(error))
            }
        }
    }
}

