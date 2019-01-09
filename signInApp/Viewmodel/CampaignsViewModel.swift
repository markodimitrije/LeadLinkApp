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
            
            }.then { success -> Promise<[LogoInfo]> in
                
                return self.campaignsRepository.dataStore.readAllCampaignLogoUrls()
                
            }
            .thenMap { logoInfo -> Promise<LogoInfo> in//Promise<Data?> in//Promise<LogoInfo> in

                let dataPromise = self.campaignsRepository.remoteAPI.getImage(url: logoInfo.url ?? "")

                return dataPromise.map { (data) -> LogoInfo in

                    return LogoInfo.init(id: logoInfo.id, url: logoInfo.url, imgData: data)
                }
                
        }.done { (infos) in     //       print("imam logo infos")
            let _ = infos.map {
                print("data ovaj \(String(describing: $0.imgData)) u realm, za campaign id = \($0.id)....")
            }
        }.catch { (err) in
            print("err = \(err)")
        }
        
    }

    
    
    
}
