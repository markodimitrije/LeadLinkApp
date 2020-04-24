//
//  CampaignCell.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 09/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import Kingfisher

class CampaignCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    
    func update(campaign: CampaignProtocol) {
        
        self.titleLbl?.text = campaign.name
        self.subtitleLbl?.text = campaign.description
        self.imgView.kf.setImage(with: URL(string: campaign.logo ?? ""),
                                 placeholder: UIImage.campaignPlaceholder)
    }
    
}
