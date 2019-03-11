//
//  CampaignCell.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 09/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CampaignCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    func update(campaign: Campaign) {
        
        self.titleLbl?.text = campaign.name
        self.subtitleLbl?.text = campaign.description
        //self.titleLbl?.text = "\(campaign.organization.name)"
        
//        self.orgNameLbl?.text = campaign.description // temp test
//        self.eventNameLbl?.text = campaign.description // temp test
        
        self.imgView?.image = (campaign.imgData != nil) ? UIImage.init(data: campaign.imgData!) : UIImage.campaignPlaceholder
        
    }
    
    private let disposeBag = DisposeBag.init()
    
}

//extension Reactive where Base: CampaignCell {
//
//    var eventName: Binder<String> {
//        return Binder.init(self.base, binding: { (cell, value) in
//            cell.eventNameLbl?.text = value
//        })
//    }
//
//    var campaign: Binder<Campaign> {
//        return Binder.init(self.base, binding: { (cell, campaign) in
//            cell.update(campaign: campaign)
//        })
//    }
//
//}
