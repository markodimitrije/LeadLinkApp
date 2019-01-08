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
        
        campaignsRepository.getCampaignsAndQuestions(userSession: userSession)
            .done { success in
                print("CampaignsAndQuestions are saved in realm = \(success)")
            }.catch { (err) in
                print("CampaignsAndQuestions catch err. DaTA NOT SAVED !")
        }
        
        /*
        campaignsRepository.getCampaignsAndQuestions(userSession: userSession)
            .done { [weak self] (success) in guard let sSelf = self else {return}
                guard success else {return}
                print("getCampaignsFromWeb.okini sve by url....")
                sSelf.campaignsRepository.dataStore.readAllCampaignLogoUrls()
                    .then({ urls -> Promise<[Bool]> in
                        urls.map({ url -> Bool in
                            return
                        })
                        return Promise() { seal in
                            
                        })
                    }).catch({ (err) in
                        
                    })
            }.catch { (err) in
                print("getCampaignsFromWeb.err catched....")
        }
        */

    }

    
    
    
}
