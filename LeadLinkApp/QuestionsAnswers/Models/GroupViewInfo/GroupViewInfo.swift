//
//  GroupViewInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 31/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct GroupViewInfo {
    var title: String
    init(title: String) {
        self.title = title
    }
}
extension GroupViewInfo: GroupViewInfoProtocol {
    func getTitle() -> String {
        return self.title
    }
}
