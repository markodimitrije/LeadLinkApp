//
//  Constants+AlertInfo.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/11/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension Constants {
    struct AlertInfo {
        static let ok = NSLocalizedString("AlertInfo.ok", comment: "")
        static let cancel = NSLocalizedString("AlertInfo.cancel", comment: "")
        struct ScanningNotSupported {
            static let title = NSLocalizedString("AlertInfo.Scan.ScanningNotSupported.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Scan.ScanningNotSupported.msg", comment: "")
        }
        struct NoSettings {
            static let title = NSLocalizedString("AlertInfo.Scan.NoSettings.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Scan.NoSettings.msg", comment: "")
        }
        struct Permission {
            static let title = NSLocalizedString("AlertInfo.Permission.title", comment: "")
            static let subtitle = NSLocalizedString("AlertInfo.Permission.subtitle", comment: "")
            static let cancel = NSLocalizedString("AlertInfo.Option.cancel", comment: "")
            static let agree = NSLocalizedString("AlertInfo.Option.agree", comment: "")
        }
        struct NoCodeDetected {
            static let title = NSLocalizedString("AlertInfo.Scan.NoCodeDetected.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Scan.NoCodeDetected.msg", comment: "")
        }
        struct logout {
            //AlertInfo.Logout.title, AlertInfo.Logout.btnTitle.logout, AlertInfo.Logout.btnTitle.cancel
            static let title = NSLocalizedString("AlertInfo.Logout.title", comment: "")
            static let logoutBtnTitle = NSLocalizedString("AlertInfo.Logout.btnTitle.logout", comment: "")
            static let cancelBtnTitle = NSLocalizedString("AlertInfo.cancel", comment: "")
        }
        struct questionsFormNotValid {
            static let title = NSLocalizedString("AlertInfo.QuestionsAnswers.FormNotValid.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.QuestionsAnswers.FormNotValid.msg", comment: "")
        }
        struct readingCampaignsError {
            static let title = NSLocalizedString("AlertInfo.Campaigns.CantReadResponse.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Campaigns.CantReadResponse.msg", comment: "")
        }
        struct noCampaignsError {
            static let title = NSLocalizedString("AlertInfo.Campaigns.Empty.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Campaigns.Empty.msg", comment: "")
        }
        struct campaignKeyIsMissingError {
            static let title = NSLocalizedString("AlertInfo.Campaigns.MandatoryKeyIsMissing.title", comment: "")
            static let msg = NSLocalizedString("AlertInfo.Campaigns.MandatoryKeyIsMissing.msg", comment: "")
        }
    }
}
