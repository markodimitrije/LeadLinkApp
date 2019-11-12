//
//  ReportToWebError.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

enum ReportToWebError: Error {
    case noCodesToReport
    case notConfirmedByServer // nije 201
}
