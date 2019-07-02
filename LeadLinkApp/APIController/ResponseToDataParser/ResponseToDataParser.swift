//
//  ResponseToDataParser.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 28/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class ResponseToDataParser {
    
    private var session: URLSession
    private var request: URLRequest
    var oData: Observable<Data>
    
    init(session: URLSession, request: URLRequest) {
        
        self.session = session
        self.request = request
        
        self.oData = session.rx.response(request: self.request).map { (response, data) -> Data in
            if 201 == response.statusCode {
                return try! JSONSerialization.data(withJSONObject:  ["created": 201])
            } else if 200 ..< 300 ~= response.statusCode {
                return data
            } else if response.statusCode == 401 {
                throw ApiError.invalidKey
            } else if 400 ..< 500 ~= response.statusCode {
                throw ApiError.cityNotFound
            } else {
                throw ApiError.serverFailure
            }
        }
        
    }
    
}
