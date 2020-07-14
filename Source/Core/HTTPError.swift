//
//  HTTPError.swift
//  Router
//
//  Created by Mohammad reza Koohkan on 4/7/1399 AP.
//  Copyright © 1399 AP Mohamadreza Koohkan. All rights reserved.
//

import Foundation

public enum HTTPError: Error {
    
    case invalidRequest(String?)
    case diffrentResponse
    case requestObjectDeinitialized
}
