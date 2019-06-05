//
//  URL+Extensions.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 20/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct Resource<T> {
    let url: URL
}

extension URLRequest {
    static func load<T: Decodable> (resource: Resource<T>) -> Observable<T> {
        return Observable.from([resource.url])
            .flatMap({ url -> Observable<Data> in
                
                let request = URLRequest.init(url: url)
                return URLSession.shared.rx.data(request: request)
                
            }).map({ data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }).asObservable()
    }
}

//extension URL {
//    static func getResourceUrl<T: Decodable>(forType type: T.Type) -> URL? {
//        switch type {
//        case is Question.Type:
//            return URL.init(string: "https://9d07a6b1-15b1-40e1-aa73-729460aa72c8.mock.pstmn.io/questions")
//        case is Campaign.Type:
//            return URL.init(string: "https://ee0a4cff-6754-453d-a736-412c0085a44b.mock.pstmn.io/campaigns")
//        default:
//            return nil
//        }
//    }
//}
