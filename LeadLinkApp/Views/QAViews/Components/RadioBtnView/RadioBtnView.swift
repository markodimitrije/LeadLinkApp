//
//  RadioBtnsView.swift
//  LeadLink
//
//  Created by Marko Dimitrijevic on 21/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class RadioBtnView: UIView, RowsStackedEqually { // RowsStackedEqually hocu da su redovi uvek jednakih height..
    
    @IBOutlet weak var headlineLbl: UILabel!
    
    @IBOutlet weak var radioImageBtn: UIButton!
    @IBOutlet weak var radioBtn: UIButton!
    
    @IBAction func radioBtnTapped(_ sender: UIButton) {
        //delegate?.radioBtnTapped(index: sender.tag)
    }
    
    var headlineText: String? {
        get {
            return headlineLbl.text
        }
        set {
            headlineLbl.text = newValue
        }
    }
    
    private var id = 0
    private var _isOn: Bool = false
    
    private var radioBtnOnImg = RadioBtnImage.init().onImage
    private var radioBtnOffImg = RadioBtnImage.init().offImage
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? radioBtnOnImg : radioBtnOffImg
            radioImageBtn.setBackgroundImage(img, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RadioBtnView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
        isOn = false // draw radioBtns with empty (only outer circle)
        
    }
    
}

struct RadioBtnOption {
    var id = 0
    var isOn = false
    var text = ""
}
