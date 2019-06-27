//
//  Implementations.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import PromiseKit
import RxSwift

public struct LeadLinkCampaignsRemoteAPI: CampaignsRemoteAPI {
    
    static let shared = LeadLinkCampaignsRemoteAPI()
    private let bag = DisposeBag()
    
    // MARK:- Properties
    
    private var apiKey: String {
        return confApiKeyState.apiKey ?? "error"
    }
    private var authorization: String {
        return confApiKeyState.authentication ?? "error"
    }
    
    private var headerParams: [String: String] {
        return ["Api-Key": apiKey,
                "Authorization": authorization,
                "cache-control": "no-cache"]
    }
    
    // MARK: - Methods
    
    public init() {}
    
    public func getCampaignsWithQuestions(userSession: UserSession) -> Promise<CampaignResults> {
        
        return Promise<CampaignResults> { seal in
            
            let urlRequestBase = URLRequest.campaignsWithQuestions
            let request = MyUrlRequestWithHeadersGet(request: urlRequestBase,
                                                     headerParams: self.headerParams)
//                "https://ee0a4cff-6754-453d-a736-412c0085a44b.mock.pstmn.io/api/leadlink/campaigns/9/questions")!)
            
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request.me) { (data, response, error) in
                
                let dataErrorFromUrlResponse = DataErrorFromUrlResponse(data: data, response: response, error: error)
                
                if !dataErrorFromUrlResponse.answerOk {
                    seal.reject(dataErrorFromUrlResponse.error!)
                } else {
                    do {
                        let decoder = JSONDecoder()
                        let payload = try decoder.decode(Campaigns.self, from: data!)
                        
                        let jsonString = String.init(data: data!, encoding: String.Encoding.utf8) // versioning
                        
                        let campaigns = payload.data
                        let questions = campaigns.map {$0.questions}
                        
                        let results = (0...max(0, campaigns.count-1)).map { (campaigns[$0], questions[$0]) }
                        
                        let campaignResults = CampaignResults.init(campaignsWithQuestions: results, jsonString: jsonString ?? "")
                        
                        seal.fulfill(campaignResults)
                    } catch {
                        seal.reject(error)
                    }
                }
                
            }.resume()
        }
    }
    
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

public struct CampaignResults {
    var campaignsWithQuestions = [(Campaign, [Question])]()
    var jsonString: String = ""
}
