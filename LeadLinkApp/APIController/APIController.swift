//
//  APIService.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 10/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import CoreLocation
import MapKit
import Reachability

class ApiController {
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let baseLeadLinkURL = URL(string: "https://service.e-materials.com/api/leadlink/")!
    }
    
    /// The shared instance
    static var shared = ApiController()
    
    private let headerFieldsCreator = CampaignsWithQuestionsHeaderFieldsCreator()
    
    init() {
        Logging.URLRequests = { request in // iz RxCocoa
            return true
        }
    }
    
    //MARK: - Api Calls
    func getQuestions(campaignId: Int) -> Observable<[Question]> {
        
        return buildRequest(base: Domain.baseLeadLinkURL,
                            pathComponent: "campaigns/\(campaignId)/questions",
                            params: [])
            .map() { json in
                let decoder = JSONDecoder()
                guard let questions = try? decoder.decode(Questions.self, from: json) else {
                    throw ApiError.invalidJson
                }
                return questions.data
        }
    }
    
    
    // MARK:- Private
    
    private func buildRequest(base: URL = Domain.baseUrl, method: String = "GET", pathComponent: String, params: Any) -> Observable<Data> {
        
        let url = base.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" || method == "PUT" {
            guard let params = params as? [(String, String)] else {
                return Observable.empty()
            }
            let queryItems = params.map { URLQueryItem(name: $0.0, value: $0.1) }
            urlComponents.queryItems = queryItems
            
        } else {
            guard let params = params as? [String: Any] else {
                return Observable.empty()
            }
            let jsonData = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            request.httpBody = jsonData
        }
        
        request.url = urlComponents.url!
        request.httpMethod = method
        
        request.allHTTPHeaderFields = headerFieldsCreator.allHeaderFields
        
        let session = URLSession.shared
        
        return session.rx.response(request: request).map() { response, data in
            
            if 201 == response.statusCode {
                return try! JSONSerialization.data(withJSONObject:  ["created": 201])
            } else if 200 ..< 300 ~= response.statusCode {
                print("buildRequest.imam data... all good, data = \(data)")
                return data
            } else if response.statusCode == 401 {
                print("buildRequest.ApiError.invalidKey")
                throw ApiError.invalidKey
            } else if 400 ..< 500 ~= response.statusCode {
                print("buildRequest.ApiError.cityNotFound")
                throw ApiError.cityNotFound
            } else {
                print("buildRequest.ApiError.serverFailure")
                throw ApiError.serverFailure
            }
        }
    }

}
