//
//  MyUrlRequest.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 27/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class MyUrlRequestWithHeaders {
    var me: URLRequest
    init(request: URLRequest, headerParams: [String: String]) {
        self.me = request
        me.allHTTPHeaderFields = headerParams
    }
}

class MyUrlRequestWithHeadersGet: MyUrlRequestWithHeaders {
    override init(request: URLRequest, headerParams: [String : String]) {
        super.init(request: request, headerParams: headerParams)
        self.me.httpMethod = "GET"
        self.me.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }
}

class MyUrlRequestWithHeadersPost: MyUrlRequestWithHeaders {
    override init(request: URLRequest, headerParams: [String : String]) {
        super.init(request: request, headerParams: headerParams)
        self.me.httpMethod = "POST"
    }
}

class MyUrlRequestWithHeadersPut: MyUrlRequestWithHeaders {
    override init(request: URLRequest, headerParams: [String : String]) {
        super.init(request: request, headerParams: headerParams)
        self.me.httpMethod = "PUT"
    }
}

class MyUrlRequestWithHeadersGetNoCache: MyUrlRequestWithHeadersGet {
    override init(request: URLRequest, headerParams: [String : String]) {
        super.init(request: request, headerParams: headerParams)
        self.me.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    }
}
