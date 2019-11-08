//
//  LoginAuthRemoteAPI.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public struct LoginAuthRemoteAPI: LoginRemoteAPIProtocol {
    
    static let shared = LoginAuthRemoteAPI()
    
    // MARK:- Properties
    
    private var authorization: String {
        return confApiKeyState!.authentication ?? "error"
    }
    
    public func logIn(credentials: LoginCredentials) -> Promise<UserSession> {
        
        return Promise<UserSession> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/login")!)
            request.httpMethod = "POST"
            
            let headers = [ // Build Auth Header
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
                "cache-control": "no-cache"
            ]
            
            let postData = NSMutableData(data: "email=\(credentials.email)".data(using: String.Encoding.utf8)!)
            postData.append("&password=\(credentials.password)".data(using: String.Encoding.utf8)!)
            
            request.timeoutInterval = 0.001 // hard-coded temp on
            
            request.httpBody = postData as Data
            request.allHTTPHeaderFields = headers
            
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    seal.reject(error)
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                guard 401 != httpResponse.statusCode else {
                    let decoder = JSONDecoder.init()
                    let payload = try? decoder.decode(UnauthorizedPayload.self, from: data)
                    seal.reject(RemoteAPIError.unauthorized([payload?.message ?? "Unauthorized."]))
                    return
                }
                guard 422 != httpResponse.statusCode else { //
                    let decoder = JSONDecoder.init()
                    let payload = try? decoder.decode(UnprocessableEntityPayload.self, from: data)
                    let parsedErrors = (payload != nil) ? ((payload!.errors.email ?? [ ]) + (payload!.errors.password ?? [ ])) : ["Invalid input data"]
                    let message = payload?.message ?? "Invalid input data!"
                    seal.reject(RemoteAPIError.unprocessableEntity(message, parsedErrors))
                    return
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(RemoteAPIError.httpError)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let payload = try decoder.decode(SignInResponsePayload.self, from: data)
                    let remoteSession = RemoteUserSession(credentials: credentials, token: payload.data.token)
                    //                    print("ovde imam remoteSession.token = \(remoteSession.token)")
                    seal.fulfill(UserSession(remoteSession: remoteSession))
                } catch {
                    seal.reject(error)
                }
            }.resume()
        }
    }
}
