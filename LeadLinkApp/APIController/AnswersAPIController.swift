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
    private let apiKey = "8HHK3z1iWy3BT4Jw5EjOmw2NK14pOPEb" // Api-Key
    private let authorization = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3NlcnZpY2UuZS1tYXRlcmlhbHMuY29tL2FwaS9sb2dpbiIsImlhdCI6MTU0Njk1MjEzMSwiZXhwIjoxODU3OTkyMTMxLCJuYmYiOjE1NDY5NTIxMzEsImp0aSI6InNZNUo1bjVDajBDVE1GaHkiLCJzdWIiOjI2NTI5LCJwcnYiOiJjM2NjMjZhNDU3ODZlMTJlMjU2ZGIxZDIxMDE3M2ZjYjI3NDE1NDZkIiwicm9sZXMiOnsicG9ydGFsIjp7IjEiOlsic3BlYWtlciJdLCI3IjpbInNwZWFrZXIiXSwiMTciOlsic3BlYWtlciJdLCIyMCI6WyJzcGVha2VyIl19LCJvcmdhbml6YXRpb24iOnsiMTMyIjpbImFkbWluIl19LCJjb25mZXJlbmNlIjp7Ijc0ODAiOlsib3JnYW5pemVyIiwibGVhZF9saW5rX21hbmFnZXIiXSwiNzQ3OSI6WyJsZWFkX2xpbmtfbWFuYWdlciJdfX0sImZpcnN0X25hbWUiOiJ0ZXN0IiwibGFzdF9uYW1lIjoidGVzIiwidG9rZW4iOiI1YTllN2VjY2E0MTFlIiwibGltaXRlZCI6MH0.kkAJ4jQcDTXYZWnzKWmiTmQapSLEKf1Na0_m-k_LL7U" // Authorization
    
    init() {
        Logging.URLRequests = { request in // iz RxCocoa
            return true
        }
    }
    
    //MARK: - Api Calls
    func notifyWeb(withCodeReport report: AnswersReport) -> Observable<(AnswersReport, Bool)> {
        
        return postRequest(base: Domain.baseLeadLinkURL, pathComponent: "answers", report: report)
        
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
    
    
    private func postRequest(base: URL = Domain.baseUrl, pathComponent: String, report: AnswersReport) -> Observable<(AnswersReport, Bool)> {
        
        let url = base.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        request.url = urlComponents.url!
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = ["Api-Key": apiKey,
                                       "Authorization": authorization]
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
//        guard let data = try? JSONSerialization.data(withJSONObject: report.payload, options: .prettyPrinted) else {
//            fatalError()
//        }
        let dict = [["question_id": "29", // hard-coded, jer citam moju kampanju iz jsonBundle !
                    "content": "381642624322"]]

        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) else {
            fatalError()
        }
        
        request.httpBody = data
        
        let session = URLSession.shared
        
        return session.rx.response(request: request).map() { response, data in
            let success = (200...299).contains(response.statusCode)
            return (report, success)
        }
    }
    
    func reportMultipleCodes(reports: [AnswersReport]?) -> Observable<Bool> {

        fatalError()
        
        // treba mi ovo - bulk, nema jos na backend-u
//        guard let reports = reports else {return Observable.empty()}
//
//        let params = CodeReport.getPayload(reports)
//
//        return buildRequest(base: Domain.baseTrackerURL,
//                            method: "POST",
//                            pathComponent: "attendances",
//                            params: params)
//            .map() { data in
//                guard let object = try? JSONSerialization.jsonObject(with: data),
//                    let json = object as? [String: Any],
//                    let created = json["created"] as? Int, created == 201 else {
//                        //                        print("reportCodes vraca FALSE!!")
//                        return false
//                }
//                //                print("reportCodes vraca TRUE!!")
//                return true
//        }
        
    }
    
}
