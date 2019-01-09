//
//  CampaignsViewModel.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 04/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift

import PromiseKit

public class CampaignsViewModel {
    
    // MARK: - Properties
    let campaignsRepository: CampaignsRepository
    //let campaignsReadyResponder: CampaignsReadyResponder
    
    // MARK: - Methods
    public init(campaignsRepository: CampaignsRepository) {
        self.campaignsRepository = campaignsRepository
    }
    
    @objc
    public func getCampaignsFromWeb() { // neko ti trazi da download-ujes i persist...
        
        guard let session = campaignsRepository.userSession, let userSession = session else {
            return
        }
        
        firstly {
            campaignsRepository.getCampaignsAndQuestions(userSession: userSession)
            }.then { success -> Promise<[String]> in
                return self.campaignsRepository.dataStore.readAllCampaignLogoUrls()
            }.thenMap { url -> Promise<Data> in
                return self.campaignsRepository.remoteAPI.getImage(url: url)
            }.done { data in
                print("data upisi u realm = \(data)")
                
        }
        
    }

    
    
    
}
