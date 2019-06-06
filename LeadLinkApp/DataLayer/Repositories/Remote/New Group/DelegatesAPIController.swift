//
//  DelegatesAPIController.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 05/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

public struct DelegatesRemoteAPI {
    
    static let shared = DelegatesRemoteAPI()
    
    // MARK:- Properties
    
    private var apiKey: String {
        return confApiKeyState.apiKey ?? "error"
    }
    private var authorization: String {
        return confApiKeyState.authentication ?? "error"
    }
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
    }
    
    // MARK: - Methods
    
    public init() {}
    
    public func getDelegate(withCode code: String) -> Observable<Delegate?> {
        let delegatesPath = "conferences/" + "\(7428)" + "/delegates" // hard-coded
        let escapedString = delegatesPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return buildRequest(pathComponent: escapedString, //params: [])//,
            params: [("code", code)])
            .map() { json in
                let decoder = JSONDecoder()
                guard let delegates = try? decoder.decode(DelegatesStructure.self, from: json) else {
                    throw ApiError.invalidJson
                }
                return delegates.data.first
        }
    }
    
    func buildRequest(base: URL = Domain.baseUrl, method: String = "GET", pathComponent: String, params: Any = []) -> Observable<Data> {

        let url = base.appendingPathComponent(pathComponent)
        //        let url = URL.init(string: "https://b276c755-37f6-44d2-85af-6f3e654511ad.mock.pstmn.io/")!.appendingPathComponent(pathComponent)
        
        var request = URLRequest(url: url)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        if method == "GET" || method == "PUT" {
            guard let params = params as? [(String, String)] else { // hard-coded off !!!
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
        
        let deviceUdid = UIDevice.current.identifierForVendor?.uuidString ?? ""
        
        request.allHTTPHeaderFields = ["Api-Key": apiKey,
                                       "device-id": deviceUdid,
                                       "Content-Type": "application/json",
                                       "Authorization": authorization]
        
        let session = URLSession.shared
        
        return session.rx.response(request: request).map() { response, data in
            
            //            print("response.statusCode = \(response.statusCode)")
            
            if 201 == response.statusCode {
                return try! JSONSerialization.data(withJSONObject:  ["created": 201])
            } else if 200 ..< 300 ~= response.statusCode {
                print("buildRequest.imam data... all good, data = \(data)")
                return data
            } else if response.statusCode == 401 {
                print("buildRequest.ApiError.invalidKey")
                throw ApiError.invalidKey
            } else if 400 ..< 500 ~= response.statusCode {
                print("buildRequest.ApiError.400..500")
                throw ApiError.cityNotFound
            } else {
                print("buildRequest.ApiError.serverFailure")
                throw ApiError.serverFailure
            }
        }
    }
    
}
