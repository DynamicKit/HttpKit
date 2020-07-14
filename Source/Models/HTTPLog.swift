//
//  HTTPLog.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 4/7/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public struct HTTPLog: CustomStringConvertible {
    
    let host: String
    let ip: String
    let isSecure: Bool
    let url: String
    let statusCode: Int
    let method: HTTPMethod
    let headers: HTTPHeaders?
    let body: Alamofire.Parameters?
    let error: Error?
    let value: Any?
    
    private (set) var file: String? = nil
    private (set) var line: String? = nil
    private (set) var function: String? = nil
    private (set) var date: Date? = nil

    public init<T>(request: HTTPRequest,
                response: DataResponse<T, AFError>,
                resultType: T.Type) {
        
        let endpointScheme = request.endpoint.resolve
        let domainScheme = endpointScheme.domain.resolve
        
        self.host = domainScheme.host
        self.ip = domainScheme.ipAddress
        self.isSecure = domainScheme.hasSSL
        self.url = endpointScheme.urlString
        self.statusCode = response.response?.statusCode ?? 0
        self.method = request.method
        self.headers = request.header
        self.body = request.body
        self.error = response.error
        self.value = response.value
    }
    
    public init(request: HTTPRequest,
                response: AFDataResponse<Any>) {
        
        let endpointScheme = request.endpoint.resolve
        let domainScheme = endpointScheme.domain.resolve
        
        self.host = domainScheme.host
        self.ip = domainScheme.ipAddress
        self.isSecure = domainScheme.hasSSL
        self.url = endpointScheme.urlString
        self.statusCode = response.response?.statusCode ?? 0
        self.method = request.method
        self.headers = request.header
        self.body = request.body
        self.error = response.error
        self.value = response.value
    }
    
    public var description: String {
        return self.aggregate([
            self.urlDescription,
            self.secureDescription,
            self.headerDescription,
            self.bodyDescription,
            self.resultDescription
        ])
    }
    
    /// SSL https://google.com/
    private var secureDescription: String {
        return (self.isSecure ? "SSL" : "Unsecure") + " " + self.host + " " + self.ip
    }
    
    /// GET 200 https://google.com/api/v1/data
    private var urlDescription: String {
        return self.method.rawValue + " " + String(self.statusCode) + " " + self.url
    }
    
    /// HEADER ["Authorization": "JWT 12jaskdi1sdp0oe]"]
    private var headerDescription: String {
        if let header = self.headers {
            return "HEADER" + " " + "\(header)"
        }else{
            return "HEADER" + " " + "empty header (nil) "
        }
    }
    
    /// BODY ["id": 21] || BODY ?query=http&version=1-0-0
    private var bodyDescription: String {
        if let body = self.body {
            return "BODY" + " " + "\(body)"
        }else{
            return "BODY" + " " + "empty body (nil) "
        }
    }
    
    /// ERROR invalid url || SUCCESS User(name: some, age: 20) or requested value as result
    private var resultDescription: String {
        if let error = self.error {
            return "ERROR" + " " + "\(error)"
        }else if let value = self.value {
            return "SUCCESS" + " " + "\(value)"
        }else{
            return "REQUEST CANCELED"
        }
    }
    
    
    
    private func aggregate(_ infos: [String]) -> String {
        let informations = infos.dropFirst().reduce(infos[0]) {  $0 + "\n" + $1 }
        return informations + "\n"
    }
    
    public mutating func print(file filePath: String = #file,
                      line: UInt = #line,
                      function: String = #function) {
        let file = (filePath.StaticString(separatedBy: "/").last ?? "")
        self.file = file
        self.line = "\(line)"
        self.function = function
        self.date = Date()
        let start = "\n@HTTPLog: \(self.date!) \(file):\(line):\(function) \n"
//        self.write()
        Swift.print(start + self.description)
    }
    
    public func write() {
        let storage = UserDefaults.standard
        var collection: [[String: Any]] = storage.array(forKey: "http.log.storage") as? [[String: Any]] ?? []
        let dictionary: [String: Any] = [
            "date": self.date!,
            "file": self.file!,
            "line": self.line!,
            "function": self.function!,
            "method": self.method.rawValue,
            "statusCode": String(self.statusCode),
            "url": self.url,
            "isSecure": self.isSecure,
            "host": self.host,
            "header": self.headers ?? [:],
            "body": self.body ?? [:],
            "isSuccess": self.error == nil,
            "result": self.value ?? "nil"
        ]
        collection.append(dictionary)
        storage.setValue(collection, forKey: "http.log.storage")
    }
    
}

