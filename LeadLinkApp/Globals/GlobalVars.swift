//
//  GlobalVars.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 10/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

let kScanditBarcodeScannerAppKey: String? = nil
//"ASHdMpiBDE75BbkR4xSxe94Ezm55L9o9KH8QCJpnArp5YMw09nsx3WBp35/nLtAQzmSC0CJNnYphbuRJWnevrfoxs6hqIw0HNQBnWE5oezqEQ09DYlBPKwkgQgn+Ep4DiwLrV8oXC53SOeo9IuLiG1TWKlVVkgPeLkIdj36yzjk++ZXCyU2NpMieDq1bqtjufDwK1OxtorxerOyeE4ow4xI1h35YvQ7MlUaVrJPgjzqOXfFxbzokcCfPECvTequ5bblhOyAKn6bZrB0GLoAriPGJMXV0gauof1vMu7HSyLYvdqUfu+x7guuB6aO3Wv2nbYypK+EjuqHYfujLpKR+FNK6870HBdqYCetDVi88a4wEeO6oskUr+kudb6rgN/miXylATAWKWzZ7DlHmAAF6m4YSMjgRQYtWYoDblGqdOkmZlJwe3SwTKqhYan6F0Wvm3wafNcrQmFEjkFp2jD5aMC2Pz+LLicSXu+xavUega5BOXMLCpC9RBXx7Hxn3sD11IYUG3CCjD5Zcix10YDAzS8tscEdYru9CM6CdJNRMIKteR+nSOSRSPBG8fje0Tm+XT048+OPyZf6USMD1J+AzmBp6sixOS6u/n4+3gSL3FFhs3J6rRSoDBy5OMwSH6A5HT27vwSR5s4YX9yAl4dJde1RR5IxEIeAterd4PIpWJIJNMgQo65P3JYC1oVMtAImV25cE39JXeZvl+tY9bw4q9TLMMqZxjbg/4v4Ic4MwsQysFTjHN05NVw/gGhe4pOiif7/pJGOch4uNKUEWc0TcYUPXjcDaV2mv8oZXu65ciejO2txH"

let factory = AppDependencyContainer.init()

var surveyInfo: SurveyInfo?

var tableRowHeightCalculator = QuestionsAnswersTableRowHeightCalculator()

var reportsDumper: ReportsDumper! // prazni codes (saved in Realm), koji su failed da se prijave pojedinacno na web

let confApiKeyState = ConferenceApiKeyState()
