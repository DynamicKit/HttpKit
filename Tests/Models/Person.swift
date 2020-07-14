//
//  RequestLayer.swift
//  RouterTests
//
//  Created by Mohammad reza Koohkan on 4/6/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
@testable import HttpKit

class Human: Codable {
    
    static var manager: HTTPManager {
        return Manager.managerPy
    }
 
}

final class Person: Human, HTTPREST {
        
    var id: Int!
    var name: String!
    var phone: String!

    var objectID: Int {
        return self.id
    }
    
    static var endpoint: (Int?) -> HTTPEndpoint = { (objectID: Int?) in
        return Endpoint.people(objectID)
    }
    
    static var methods: CRUDMethods {
        return (create: .post, read: .get, update: .patch, delete: .delete)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, phone
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.phone = try container.decode(String.self, forKey: .phone)
        try super.init(from: try container.superDecoder())
    }
    
}
