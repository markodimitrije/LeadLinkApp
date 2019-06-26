//
//  GlobalVars.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

let factory = AppDependencyContainer.init()

var tableRowHeightCalculator = QuestionsAnswersTableRowHeightCalculator()

var reportsDumper: ReportsDumper! // prazni codes (saved in Realm), koji su failed da se prijave pojedinacno na web

let confApiKeyState = ConferenceApiKeyState()
