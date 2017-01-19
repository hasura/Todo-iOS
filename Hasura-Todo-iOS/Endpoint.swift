//
//  Endpoint.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

struct Endpoint {
    private static let DB = "https://data.warble80.hasura-app.io"
    private static let AUTH = "https://auth.warble80.hasura-app.io"
    private static let VERSION = "v1"
    
    static let LOGIN = Endpoint.AUTH + "/login"
    static let REGISTER = Endpoint.AUTH + "/signup"
    static let LOGOUT = Endpoint.AUTH + "/user/logout"
    static let QUERY = Endpoint.DB + "/" + Endpoint.VERSION + "/query"
}
