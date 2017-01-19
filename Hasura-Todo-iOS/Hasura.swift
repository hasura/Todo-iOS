//
//  Hasura.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation

class Hasura {
    
    static let sharedInstance = Hasura()
    
    var authToken: String?
    var hasuraId: Int?
    var hasuraRoles: [String]?
    
    let defaults = UserDefaults.standard
    
    struct SessionKeys {
        static let AUTHTOKEN = "AuthTokenKey"
        static let HASURAID = "HasuraIdKey"
        static let HASURAROLES = "HasuraRoles"
    }
    
    func initialise() {
        self.authToken = defaults.string(forKey: SessionKeys.AUTHTOKEN)
        self.hasuraId = defaults.integer(forKey: SessionKeys.HASURAID)
        self.hasuraRoles = defaults.array(forKey: SessionKeys.HASURAROLES) as! [String]?
    }
    
    func setSession(authToken: String, hasuraId: Int, hasuraRoles: [String]) {
        self.authToken = authToken
        self.hasuraId = hasuraId
        self.hasuraRoles = hasuraRoles
        persistSession()
    }
    
    func setSession(authResponse: AuthResponse) {
        self.authToken = authResponse.authToken
        self.hasuraRoles = authResponse.roles
        self.hasuraId = authResponse.id
        persistSession()
    }
    
    func clearSession() {
        self.authToken = nil
        self.hasuraId = nil
        self.hasuraRoles = nil
        persistSession()
    }
    
    private func persistSession() {
        defaults.set(authToken, forKey: SessionKeys.AUTHTOKEN)
        defaults.set(hasuraId, forKey: SessionKeys.HASURAID)
        defaults.set(hasuraRoles, forKey: SessionKeys.HASURAROLES)
    }
    
}
