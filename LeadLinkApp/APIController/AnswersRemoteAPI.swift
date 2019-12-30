//
//  AnswersRemoteAPI.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class AnswersRemoteAPI {
    
    struct Domain {
        static let baseUrl = URL(string: "https://service.e-materials.com/api")!
        static let baseLeadLinkURL = URL(string: "https://service.e-materials.com/api/leadlink/")!
    }
    
    static var shared = AnswersRemoteAPI()
    
    //private let headerFieldsCreator = AnswersHeaderFieldsCreator()
    private var headerFieldsCreator: AnswersHeaderFieldsCreator!
    
    //MARK: - API Calls
    func notifyWeb(withReports reports: [AnswersReport]) -> Observable<([AnswersReport], Bool)> {
        
        headerFieldsCreator = AnswersHeaderFieldsCreator()
        
        return postRequest(base: Domain.baseLeadLinkURL, pathComponent: "answers", reports: reports)
        
    }
    
    private func postRequest(base: URL = Domain.baseUrl, pathComponent: String, reports: [AnswersReport]) -> Observable<([AnswersReport], Bool)> {
        
        let url = base.appendingPathComponent(pathComponent)
        var request = URLRequest(url: url)
        
        let urlComponents = NSURLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        request.url = urlComponents.url!
        request.httpMethod = "POST"
        
        request.allHTTPHeaderFields = headerFieldsCreator.allHeaderFields
        
        let payload = reports.map {$0.getPayload()}
        //print("AnswersRemoteAPI.postRequest.payload = \(payload)")
        
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
