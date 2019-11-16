//
//  DownloadImage.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 04/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public struct DownloadImageRemoteAPI: DownloadImageAPI {
    
    static let shared = DownloadImageRemoteAPI()
    
    // MARK: - Methods
    
    public init() {}
    
    public func getImage(url: String) -> Promise<Data?> {
        
        return Promise<Data?>.init(resolver: { seal in
            
            guard let url = URL(string: url) else {
                //seal.reject(CampaignError.unknown);
                seal.fulfill(nil)
                return
            }
            
            var request = URLRequest(url: url); request.httpMethod = "GET"
            
            let session = URLSession.shared
            
            session.dataTask(with: request) { (data, response, error) in
                
                let dataErrorFromUrlResponse = DataErrorFromUrlResponse(data: data, response: response, error: error)
                
                if dataErrorFromUrlResponse.answerOk {
                    seal.fulfill(dataErrorFromUrlResponse.data!)
                } else {
                    seal.reject(dataErrorFromUrlResponse.error!)
                }
                
                }.resume()
            
        })
        
    }
    
}
