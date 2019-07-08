//
//  PrepopulateDelegateDataDecisioner.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 21/06/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

//class PrepopulateDelegateDataDecisioner {
//
//    private var surveyInfo: SurveyInfo
//    private var code: String
//
//    init(surveyInfo: SurveyInfo, codeToCheck code: String) {
//        self.surveyInfo = surveyInfo
//        self.code = code
//    }
//
//    func shouldPrepopulateDelegateData() -> Bool {
//        let hasRealmAnswers = surveyInfo.doesCodeSavedInRealmHasAnyAnswers(codeValue: code)
//        let hasConsent = surveyInfo.hasConsent
//        return !hasRealmAnswers && hasConsent
//    }
//}

class PrepopulateDelegateDataDecisioner {
    
    private var surveyInfo: SurveyInfo
    private var code: String
    
    init(surveyInfo: SurveyInfo, codeToCheck code: String) {
        self.surveyInfo = surveyInfo
        self.code = code
    }
    
    func shouldPrepopulateDelegateData() -> Bool {
        let hasRealmAnswers = surveyInfo.doesCodeSavedInRealmHasAnyAnswers(codeValue: code)
        let hasConsent = surveyInfo.hasConsent
        return !hasRealmAnswers && hasConsent
    }
}
