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
    
    private let apiKey = "LLNOQ8IBXTbKnSSGZ6YZOIFA1Qk4lS01"
    private let authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3NlcnZpY2UuZS1tYXRlcmlhbHMuY29tL2FwaS9sb2dpbiIsImlhdCI6MTU0NDQ0Mjg3MSwiZXhwIjoxODU1NDgyODcxLCJuYmYiOjE1NDQ0NDI4NzEsImp0aSI6IkVlYkJxYkkwUVpzaHdBR0QiLCJzdWIiOjI2NTI5LCJwcnYiOiJjM2NjMjZhNDU3ODZlMTJlMjU2ZGIxZDIxMDE3M2ZjYjI3NDE1NDZkIiwicm9sZXMiOnsicG9ydGFsIjp7IjEiOlsic3BlYWtlciJdLCI3IjpbInNwZWFrZXIiXSwiMTciOlsic3BlYWtlciJdLCIyMCI6WyJzcGVha2VyIl19LCJvcmdhbml6YXRpb24iOnsiMTMyIjpbImFkbWluIl19LCJjb25mZXJlbmNlIjp7Ijc0ODAiOlsib3JnYW5pemVyIiwibGVhZF9saW5rX21hbmFnZXIiXX19LCJmaXJzdF9uYW1lIjoidGVzdCIsImxhc3RfbmFtZSI6InRlcyIsInRva2VuIjoiNWE5ZTdlY2NhNDExZSIsImxpbWl0ZWQiOjB9.srG1Qn0mBwze9udK6Tb1e1s5mooshFSz2jS9DmkvBMQ" // Authorization
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let baseTrackerURL = URL(string: "http://tracker.e-materials.com/")!
    }
    
    // MARK: - Methods
    
    public init() {}
    
    public func getDelegate(withCode code: String) -> Observable<Delegate?> {
        let delegatesPath = "conferences/" + "\(7520)" + "/delegates" // hard-coded
        let escapedString = delegatesPath.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return buildRequest(pathComponent: escapedString, //params: [])//,
            params: [("code","000024")])
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
        let auth = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3NlcnZpY2UuZS1tYXRlcmlhbHMuY29tL2FwaS9sb2dpbiIsImlhdCI6MTU1OTcyODc0MCwiZXhwIjoxODcwNzY4NzQwLCJuYmYiOjE1NTk3Mjg3NDAsImp0aSI6Imt1c3RvTHB5eTNaOWF5ZDUiLCJzdWIiOjIwNzc0LCJwcnYiOiJjM2NjMjZhNDU3ODZlMTJlMjU2ZGIxZDIxMDE3M2ZjYjI3NDE1NDZkIiwicm9sZXMiOnsiZGlhbG9nIjp7IjUwNSI6WyJleHBlcnQiLCJmb2xsb3dlciJdfSwiY29uZmVyZW5jZSI6eyI3NTIwIjpbImxlYWRfbGlua19tYW5hZ2VyIl19LCJvcmdhbml6YXRpb24iOnsiMiI6WyJhZG1pbiJdfX0sImZpcnN0X25hbWUiOiJNaWxhbm8iLCJsYXN0X25hbWUiOiJQb3BvdmljaSIsInRva2VuIjoiNTkzYWE2Y2YzOTVhNSIsImxpbWl0ZWQiOjB9.kPKl0689wZTtLvxaoWxXc_ZY4NXwPExlK-N9R4uVk4A" // hard-coded refactor !
        
        request.allHTTPHeaderFields = ["Api-Key": apiKey,
                                       "device-id": deviceUdid,
                                       "Content-Type": "application/json",
                                       "Authorization": auth]
        
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
                print("buildRequest.ApiError.cityNotFound")
                throw ApiError.cityNotFound
            } else {
                print("buildRequest.ApiError.serverFailure")
                throw ApiError.serverFailure
            }
        }
    }
    
}
