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
    @IBOutlet weak var orgNameLbl: UILabel!
    @IBOutlet weak var eventNameLbl: UILabel!
    
    func update(campaign: Campaign) {
        
        self.eventNameLbl?.text = campaign.name
        self.orgNameLbl?.text = "\(campaign.organization_id) nabavi data"
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
