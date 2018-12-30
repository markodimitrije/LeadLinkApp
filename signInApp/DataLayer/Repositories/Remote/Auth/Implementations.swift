//
//  Implementations.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public struct LeadLinkRemoteAPI: AuthRemoteAPI {
    
    static let shared = LeadLinkRemoteAPI()
    
    // MARK:- Properties
    
    var apiKey = "0pCnX8hgOPYOsO42mRRBCPLBrXsDWInS" // ovo je const ali moguce da ce vratiti API i da treba da save negde kod sebe a posle prosledis ovde..
    
    // MARK: - Methods
    
    public init() {}
    
    //public func logIn(email: String, password: String) -> Promise<UserSession> {
    public func logIn(credentials: LoginCredentials) -> Promise<UserSession> {
    //let bodyData = try JSONEncoder().encode(account)
        return Promise<UserSession> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/login")!)
            request.httpMethod = "POST"
            
            let headers = [ // Build Auth Header
                "Api-Key": apiKey,
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"//,
                //"Postman-Token": "adff07f1-101b-47c6-a3cd-978ed6bb7f29"
            ]
            
            let postData = NSMutableData(data: "email=\(credentials.email)".data(using: String.Encoding.utf8)!)
            postData.append("&password=\(credentials.password)".data(using: String.Encoding.utf8)!)
            //postData.append("&undefined=undefined".data(using: String.Encoding.utf8)!)
            
            request.httpBody = postData as Data
            request.allHTTPHeaderFields = headers
            
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(RemoteAPIError.httpError)
                    return
                }
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        let payload = try decoder.decode(SignInResponsePayload.self, from: data)
                        let remoteSession = RemoteUserSession(token: payload.data.token)
                        print("ovde imam remoteSession.token = \(remoteSession.token)")
                        seal.fulfill(UserSession(remoteSession: remoteSession))
                    } catch {
                        seal.reject(error)
                    }
                } else {
                    seal.reject(RemoteAPIError.unknown)
                }
                }.resume()
        }
    }
    
}

struct SignInResponsePayload: Codable {
    var data: SignInToken
}

struct SignInToken: Codable {
    var token: String
}


public struct LoginCredentials: Codable {
    var email: String
    var password: String
}
