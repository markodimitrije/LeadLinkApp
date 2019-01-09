//
//  CampaignCell.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 09/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

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
