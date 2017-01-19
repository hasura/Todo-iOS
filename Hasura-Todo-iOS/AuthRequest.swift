//
//  LoginRequest.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import ObjectMapper

class AuthRequest: Mappable {
    
    var username: String!
    var password: String!
    
    required init?(map: Map) {
        
    }
    
    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        password <- map["password"]
    }
}
