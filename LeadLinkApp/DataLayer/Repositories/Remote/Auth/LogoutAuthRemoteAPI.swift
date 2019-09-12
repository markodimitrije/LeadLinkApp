//
//  LogoutAuthRemoteAPI.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public struct LogoutAuthRemoteAPI: LogoutRemoteAPIProtocol {
    
    static let shared = LogoutAuthRemoteAPI()
    
    private var authorization: String {
        return confApiKeyState!.authentication ?? "error"
    }
    
    public func logOut(userSession: UserSession) -> Promise<UserSession> {
        
        let authToken = userSession.remoteSession.token
        
        return Promise<UserSession> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/logout")!)
            request.httpMethod = "POST"
            
            let headers = [ // Build Auth Header
                "Authorization": authorization,
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ]
            
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
                
                print("logout = SUCCESS!")
                seal.fulfill(userSession)
                
                }.resume()
        }
    }
}

