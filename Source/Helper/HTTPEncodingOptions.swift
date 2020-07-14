//
//  HTTPEncodingOptions.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 2/9/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation
import Alamofire

public enum HTTPEncodingOptions {
    
    case params
    case json
    
    public var resolve: ParameterEncoding {
        switch self {
        case .json:
            return JSONEncoding.prettyPrinted
        case .params:
            return URLEncoding(destination: .httpBody, arrayEncoding: .noBrackets, boolEncoding: .literal)
        }
    }
    
}
