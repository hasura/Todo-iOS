//
//  HasuraApi.swift
//  Hasura-Todo-iOS
//
//  Created by Jaison on 17/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class HasuraApi {
    
    static func makeAlamofireObjectCall<T: Mappable>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completionHandler: @escaping (DataResponse<T>) -> Void)
    {
        var headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        
        if Hasura.sharedInstance.authToken != nil {
            headers["Authorization"] = "Bearer " + Hasura.sharedInstance.authToken!
        }
        
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseObject(completionHandler: completionHandler)
        debugPrint(request)
    }
    
    static func makeAlamofireArrayCall<T: Mappable>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        completionHandler: @escaping (DataResponse<[T]>) -> Void)
    {
        var headers: HTTPHeaders = [
            "Content-type": "application/json"
        ]
        
        if Hasura.sharedInstance.authToken != nil {
            headers["Authorization"] = "Bearer " + Hasura.sharedInstance.authToken!
        }
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseArray(completionHandler: completionHandler)
        debugPrint(request)
    }
    
    static func login(username: String, password: String, completionHandler: @escaping (DataResponse<AuthResponse>) -> Void) {
        let params = AuthRequest(username: username, password: password).toJSON()
        makeAlamofireObjectCall(Endpoint.LOGIN,method: .post, parameters: params, completionHandler: completionHandler)                
    }
    
    static func register(username: String, password: String, completionHandler: @escaping (DataResponse<AuthResponse>) -> Void) {
        let params = AuthRequest(username: username, password: password).toJSON()
        makeAlamofireObjectCall(Endpoint.REGISTER,method: .post, parameters: params, completionHandler: completionHandler)
    }
    
    static func logout(completionHandler: @escaping (DataResponse<MessageResponse>) -> Void) {
        makeAlamofireObjectCall(Endpoint.LOGOUT, method: .get, completionHandler: completionHandler)
    }
    
    static func getTodos(completionHandler: @escaping (DataResponse<[TodoRecord]>) -> Void) {
        let params: [String: Any] = [
            "type" : "select",
            "args" : [
                "table"     : "todo",
                "columns"   : ["id","title","completed"],
                "where"     : [
                    "user_id" : Hasura.sharedInstance.hasuraId!
                ]
            ]
        ]
        
        makeAlamofireArrayCall(Endpoint.QUERY, method: .post, parameters: params, completionHandler: completionHandler)
    }
    
    static func addATodo(todoTitle: String,completionHandler: @escaping (DataResponse<TodoReturningResponse>) -> Void) {
        let params: [String: Any] = [
            "type" : "insert",
            "args" : [
                "table"     : "todo",
                "objects"   : [
                    [
                        "user_id"  : Hasura.sharedInstance.hasuraId!,
                        "title"    : todoTitle,
                        "completed": false
                    ]
                ],
                "returning" : ["id","title","completed"]
            ]
        ]
        
        makeAlamofireObjectCall(Endpoint.QUERY,method: .post, parameters: params, completionHandler: completionHandler)
    }
    
    static func deleteATodo(todoId: Int, completionHandler: @escaping (DataResponse<TodoReturningResponse>) -> Void) {
        let params: [String: Any] = [
            "type" : "delete",
            "args" : [
                "table"     : "todo",
                "where"     : [
                    "user_id" : Hasura.sharedInstance.hasuraId!,
                    "id"      : todoId
                ]
            ]
        ]
        
        makeAlamofireObjectCall(Endpoint.QUERY, method: .post, parameters: params,completionHandler: completionHandler)
    }
    
    static func updateATodo(todo: TodoRecord, completionHandler: @escaping (DataResponse<TodoReturningResponse>) -> Void) {
        let params: [String: Any] = [
            "type" : "update",
            "args" : [
                "table"     : "todo",
                "$set"      : [
                    "title"    : todo.title,
                    "completed": todo.completed
                ],
                "where"     : [
                    "user_id" : Hasura.sharedInstance.hasuraId!,
                    "id"      : todo.id
                ],
                "returning" : ["id","title","completed"]
            ]
        ]
        
        makeAlamofireObjectCall(Endpoint.QUERY, method: .post, parameters: params,completionHandler: completionHandler)
    }
    
    
}
