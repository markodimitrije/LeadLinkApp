//
//  Implementations.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit

public struct LeadLinkCampaignsRemoteAPI: CampaignsRemoteAPI {
    
    static let shared = LeadLinkCampaignsRemoteAPI()
    
    // MARK:- Properties
    
    var apiKey = "0pCnX8hgOPYOsO42mRRBCPLBrXsDWInS" // ovo je const ali moguce da ce vratiti API i da treba da save negde kod sebe a posle prosledis ovde..
    
    // MARK: - Methods
    
    public init() {}
    
    public func getCampaigns(userSession: UserSession) -> Promise<[Campaign]> {
        
        let authToken = userSession.remoteSession.token
        
        return Promise<[Campaign]> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/leadlink/campaigns")!)
            request.httpMethod = "GET"
            
            let headers = [ // Build Auth Header
                "Api-Key": apiKey,
                "Authorization": "Bearer \(authToken)",
                //"Content-Type": "application/x-www-form-urlencoded",
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
                guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                    seal.reject(RemoteAPIError.unknown)
                    return
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    seal.reject(RemoteAPIError.httpError)
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let payload = try decoder.decode(Campaigns.self, from: data)
                    
                    print("getCampaigns. PROSAO SAM DECODE: ALL GOOD....")
                    
                    seal.fulfill(payload.data)
                } catch {
                    seal.reject(error)
                }
                }.resume()
        }
    }
    
}
