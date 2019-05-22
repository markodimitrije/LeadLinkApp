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
    
    public func getQuestions(campaignId id: Int) -> Promise<[Question]> {
        
        let oQuestions = ApiController.shared.getQuestions(campaignId: id)
        
        return Promise<[Question]> { seal in
            
            oQuestions
                .subscribe(onNext: { questions in
                    seal.fulfill(questions)
                }, onError: { err in
                    seal.reject(err)
                })
                .disposed(by: bag)

        }
        
    }
    
    
    
    public func getCampaignsAndQuestions(userSession: UserSession) -> Promise<CampaignResults> {

//        let authToken = userSession.remoteSession.token // hard-coded ON
//
//        return Promise<CampaignResults> { seal in
//            // Build Request
//            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/leadlink/campaigns?include=questions,organization")!)
//            request.httpMethod = "GET"
//
//            let headers = [ // Build Auth Header
//                "Api-Key": apiKey,
//                "Authorization": "Bearer \(authToken)",
//                "cache-control": "no-cache"
//            ]
//
//            request.allHTTPHeaderFields = headers
//
//            // Send Data Task
//            let session = URLSession.shared
//            session.dataTask(with: request) { (_, _, _) in
//
//                guard let json = MainBundleJsonParser.readJSONFromFile(fileName: "mockWithTerms") as? [String: Any],
//                    let data = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) else {
//                        fatalError()
//                }
//
//                do {
//                    let decoder = JSONDecoder()
//                    let payload = try decoder.decode(Campaigns.self, from: data)
//
//                    let jsonString = String.init(data: data, encoding: String.Encoding.utf8) // versioning
//
//                    let campaigns = payload.data
//                    let questions = campaigns.map {$0.questions}
//
//                    let results = (0...max(0, campaigns.count-1)).map { (campaigns[$0], questions[$0]) }
//
//                    let campaignResults = CampaignResults.init(campaignsWithQuestions: results, jsonString: jsonString ?? "")
//
//                    seal.fulfill(campaignResults)
//                } catch {
//                    seal.reject(error)
//                }
//                }.resume()
//        }
        
        let authToken = userSession.remoteSession.token // hard-coded off

        return Promise<CampaignResults> { seal in
            // Build Request
            var request = URLRequest(url: URL(string: "https://service.e-materials.com/api/leadlink/campaigns?include=questions,organization")!)
            request.httpMethod = "GET"

            let headers = [ // Build Auth Header
                "Api-Key": apiKey,
                "Authorization": "Bearer \(authToken)",
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

//                    print("getCampaignsAndQuestions. PROSAO SAM DECODE: ALL GOOD....")

                    let jsonString = String.init(data: data, encoding: String.Encoding.utf8) // versioning

                    let campaigns = payload.data
                    let questions = campaigns.map {$0.questions}

                    let results = (0...max(0, campaigns.count-1)).map { (campaigns[$0], questions[$0]) }

                    let campaignResults = CampaignResults.init(campaignsWithQuestions: results, jsonString: jsonString ?? "")

                    seal.fulfill(campaignResults)
                } catch {
                    seal.reject(error)
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
                
//                print("getImage. imam logo, nisam proverio ispravnost data....")
                seal.fulfill(data)
                
            }.resume()
            
        })
        
    }
    
}

public struct CampaignResults {
    var campaignsWithQuestions = [(Campaign, [Question])]()
    var jsonString: String = ""
}
