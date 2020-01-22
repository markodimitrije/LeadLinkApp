//
//  DelegatesRemoteAPI.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 05/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

public struct DelegatesRemoteAPI {
    
    static var shared = DelegatesRemoteAPI()
    
    // MARK:- Properties
    
    //private let headerFieldsCreator = CampaignDelegateHeaderFieldsCreator()
    private var headerFieldsCreator: CampaignDelegateHeaderFieldsCreator!
    private var responseToDataParser: ResponseToDataParser!
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
    }
    
    // MARK: - Methods
    
    public init() {}
    
    public mutating func getDelegate(withCode code: String) -> Observable<Delegate?> {
        
        headerFieldsCreator = CampaignDelegateHeaderFieldsCreator()
        
        let confId = confApiKeyState?.conferenceId ?? 0 // fatal
        let delegatesPath = "conferences/" + "\(confId)" + "/delegates" // hard-coded
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
    
    mutating func buildRequest(base: URL = Domain.baseUrl, method: String = "GET", pathComponent: String, params: Any = []) -> Observable<Data> {

        let url = base.appendingPathComponent(pathComponent)
        
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
        request.allHTTPHeaderFields = headerFieldsCreator.allHeaderFields
        
        let session = URLSession.shared
        responseToDataParser = ResponseToDataParser(session: session, request: request)
        
        return responseToDataParser.oData
    }
    
}
