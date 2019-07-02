//
//  DataErrorFromUrlResponse.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

class DataErrorFromUrlResponse {
    
    var data: Data?
    var error: Error?
    var answerOk: Bool {
        return data != nil && error == nil
    }
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        
        if let error = error {
            self.error = error
        }
        
        guard let httpResponse = response as? HTTPURLResponse, let data = data else {
            self.error = RemoteAPIError.unknown
            return
        }
        
        guard 200..<300 ~= httpResponse.statusCode else {
            self.error = RemoteAPIError.httpError
            return
        }
        
        self.data = data
        self.error = nil
        
    }
    
}
