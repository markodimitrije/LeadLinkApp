//
//  AswersAPICotroller.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON
import CoreLocation
import MapKit
import Reachability

class AnswersApiController {
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let baseLeadLinkURL = URL(string: "https://service.e-materials.com/api/leadlink/")!
    }
    
    /// The shared instance
    static var shared = AnswersApiController()
    
    //campaigns/9/questions
    
    /// The api key to communicate with LeadLink
    private var apiKey: String {
        return confApiKeyState.apiKey ?? "error"
    }
    private var authorization: String {
        return confApiKeyState.authentication ?? "error"
    }
    
    init() {
        Logging.URLRequests = { request in // iz RxCocoa
            return true
        }
    }
    
    //MARK: - API Calls
    func notifyWeb(withReports reports: [AnswersReport]) -> Observable<([AnswersReport], Bool)> {
        
        return postRequest(base: Domain.baseLeadLinkURL, pathComponent: "answers", reports: reports)
        
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
        
        request.allHTTPHeaderFields = ["Api-Key": apiKey,
                                       "Authorization": authorization]
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    
    private func postRequest(base: URL = Domain.baseUrl, pathComponent: String, reports: [AnswersReport]) -> Observable<([AnswersReport], Bool)> {
        
        let url = base.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        request.url = urlComponents.url!
        request.httpMethod = "POST"
        
        print("Api-Key", apiKey)
        print("Authorization", authorization)
        
        request.allHTTPHeaderFields = ["Api-Key": apiKey,
                                       "Authorization": authorization,
                                       "Content-Type": "application/json"]
        
        let payload = reports.map {$0.payload}
        print("AnswersAPIController.postRequest.payload = \(payload)")
        
        guard let data = try? JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted) else {
            fatalError()
        }
        
        request.httpBody = data
        
        let session = URLSession.shared
        
        return session.rx.response(request: request).map() { response, data in

            let success = (200...299).contains(response.statusCode)
            return (reports, success)
        }
        
    }
    
}
