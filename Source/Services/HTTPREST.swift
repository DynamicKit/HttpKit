//
//  HTTPREST.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 4/6/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public protocol HTTPREST {
    
    typealias ResponseCapture = (Result<Self, Error>) -> Void
    typealias CollectionResponseCapture = (Result<[Self], Error>) -> Void
    typealias CRUDMethods = (create: HTTPMethod, read: HTTPMethod, update: HTTPMethod, delete: HTTPMethod)

    static var endpoint: (Int?) -> HTTPEndpoint { get set }
    static var manager: HTTPManager { get }
    
    var objectID: Int { get }
    static var methods: CRUDMethods { get }
}


public extension HTTPREST where Self: Codable {
    
    static var methods: CRUDMethods {
        return (create: .post, read: .get, update: .patch, delete: .delete)
    }
    
    func encode() -> [String: Any]? {
        do {
            let data = try JSONEncoder().encode(self)
            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            return json as? [String: Any]
        } catch {
            print("@HTTP Error \(error)")
            return nil
        }
    }
    
    static func read(method: HTTPMethod = Self.methods.read, _ completion: @escaping CollectionResponseCapture) {
        Self.manager
            .request(endpoint: Self.endpoint(nil))
            .method(method)
            .response(decodable: [Self].self, completion)
    }
    
    func read(method: HTTPMethod = Self.methods.read, _ completion: @escaping ResponseCapture) {
        Self.manager
            .request(endpoint: Self.endpoint(self.objectID))
            .method(method)
            .response(decodable: Self.self, completion)
    }
    

    func create(method: HTTPMethod = Self.methods.create, _ completion: @escaping ResponseCapture) {
        Self.manager
            .request(endpoint: Self.endpoint(nil))
            .method(method)
            .body(self.encode())
            .response(decodable: Self.self, completion)
    }
    
    func update(method: HTTPMethod = Self.methods.update, _ completion: @escaping ResponseCapture) {
        Self.manager
            .request(endpoint: Self.endpoint(self.objectID))
            .method(method)
            .body(self.encode())
            .response(decodable: Self.self, completion)
    }
    
    func delete(method: HTTPMethod = Self.methods.delete, _ completion: @escaping ResponseCapture) {
        Self.manager
            .request(endpoint: Self.endpoint(self.objectID))
            .method(method)
            .body(self.encode())
            .response(decodable: Self.self, completion)
    }
}

