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
    
    func update(campaign: CampaignProtocol) {
        
        self.titleLbl?.text = campaign.name
        self.subtitleLbl?.text = campaign.description
        
//        self.orgNameLbl?.text = campaign.description // temp test
//        self.eventNameLbl?.text = campaign.description // temp test
        
        self.imgView?.image = (campaign.imgData != nil) ? UIImage.init(data: campaign.imgData!) : UIImage.campaignPlaceholder
        
    }
    
    private let disposeBag = DisposeBag()
    
}
