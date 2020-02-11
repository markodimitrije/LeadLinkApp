//
//  AlertInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

struct AlertInfo {
    var title: String?
    var text: String?
    var btnText: [String]
    static func getInfo(type: AlertInfoType) -> AlertInfo {
        switch type {
        case .noCamera:
            return AlertInfo.init(title: Constants.AlertInfo.ScanningNotSupported.title,
                                  text: Constants.AlertInfo.ScanningNotSupported.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case .dataPermission:
            return AlertInfo.init(title: Constants.AlertInfo.Permission.title,
                                  text: Constants.AlertInfo.Permission.subtitle,
                                  btnText: [Constants.AlertInfo.Permission.agree, Constants.AlertInfo.Permission.cancel])
        case .noCodeDetected:
            return AlertInfo.init(title: Constants.AlertInfo.NoCodeDetected.title,
                                  text: Constants.AlertInfo.NoCodeDetected.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case .logout:
            return AlertInfo.init(title: Constants.AlertInfo.logout.title,
                                  text: "",
                                  btnText: [Constants.AlertInfo.ok,
                                            Constants.AlertInfo.cancel])
        case .questionsFormNotValid:
            return AlertInfo.init(title: Constants.AlertInfo.questionsFormNotValid.title,
                                  text: Constants.AlertInfo.questionsFormNotValid.msg,
                                  btnText: [Constants.AlertInfo.ok])
     
        case .readingCampaignsError:
            return AlertInfo.init(title: Constants.AlertInfo.readingCampaignsError.title,
                              text: Constants.AlertInfo.readingCampaignsError.msg,
                              btnText: [Constants.AlertInfo.ok])
        
        case .noCampaigns:
            return AlertInfo.init(title: Constants.AlertInfo.noCampaignsError.title,
                                  text: Constants.AlertInfo.noCampaignsError.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case .campaignKeyIsMissing:
            return AlertInfo.init(title: Constants.AlertInfo.campaignKeyIsMissingError.title,
                                  text: Constants.AlertInfo.campaignKeyIsMissingError.msg,
                                  btnText: [Constants.AlertInfo.ok])
        case .cameraPermission:
            return AlertInfo.init(title: Constants.AlertInfo.CameraPermission.title,
                                  text: Constants.AlertInfo.CameraPermission.subtitle,
                                  btnText: [Constants.AlertInfo.ok])
        }
    }
}
