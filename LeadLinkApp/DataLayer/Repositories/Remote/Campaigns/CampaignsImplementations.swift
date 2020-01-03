//
//  Implementations.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public struct CampaignsWithQuestionsRemoteAPI: CampaignsRemoteAPI {
    
    static let shared = CampaignsWithQuestionsRemoteAPI()
    
    // MARK: - Methods
    
    public init() {}
    
    public func getCampaignsWithQuestions(userSession: UserSession) -> Promise<CampaignResults> {
        
        return Promise<CampaignResults> { seal in
            
            let urlRequestBase = URLRequest.campaignsWithQuestions
//            let urlRequestBase = URLRequest.campaignsWithQuestionsMock // hard-coded
            let headersCreator = CampaignsWithQuestionsHeaderFieldsCreator()
            let request = MyUrlRequestWithHeadersGetNoCache(
                    request: urlRequestBase,
                    headerParams: headersCreator.allHeaderFields)
            // Send Data Task
            let session = URLSession.shared
            session.dataTask(with: request.me) { (data, response, error) in
                
                let dataErrorFromUrlResponse = DataErrorFromUrlResponse(data: data, response: response, error: error)
                
                if !dataErrorFromUrlResponse.answerOk {
                    //seal.reject(dataErrorFromUrlResponse.error!)
                    return
                } else {
                
                    let decoder = JSONDecoder()
                    var payload: Campaigns!
                    
                    do {
                        payload = try decoder.decode(Campaigns.self, from: data!)
                    } catch {
                        seal.reject(CampaignError.mandatoryKeyIsMissing)
                        return
                    }
                    
                    let jsonString = String.init(data: data!, encoding: String.Encoding.utf8) // versioning
                    
                    let campaigns = payload.data
                    let questions = campaigns.map {$0.questions}
                    
                    if campaigns.isEmpty {
                        seal.reject(CampaignError.noCampaignsFound)
                        return
                    }
                    
                    let results = (0...max(0, campaigns.count-1)).map { (campaigns[$0], questions[$0]) }
                    
                    let campaignResults = CampaignResults.init(campaignsWithQuestions: results, jsonString: jsonString ?? "")
                    
                    seal.fulfill(campaignResults)
                }
                
            }.resume()
        }
    }
    
}
