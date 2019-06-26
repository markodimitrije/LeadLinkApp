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
    
    var radioBtnOnImg = RadioImage.init().onImage
    var radioBtnOffImg = RadioImage.init().offImage
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? RadioImage().onImage : RadioImage().offImage
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
    
    convenience init(frame: CGRect, option: RadioBtnOption) {
        self.init(frame: frame)
        update(option: option)
    }
    
    func loadViewFromNib() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RadioBtnView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.addSubview(view)
        
    }
    
    func update(option: RadioBtnOption) {
        self.id = option.id
        self.headlineText = option.text
        self.isOn = option.isOn
    }
    
    func set(logic: Bool) {
        self.isOn = logic
    }
    
}

struct RadioBtnOption {
    var id = 0
    var isOn = false
    var text = ""
}

class RadioImage {
    
    var onImage: UIImage!
    var offImage: UIImage!
    
    private var outerView: UIView!
    private var innerOnView: UIView!
    private var innerOffView: UIView!
    
    init() {
        loadImageView()
    }
    
    private func loadImageView() {
        makeOuterCircle()
        makeInnerViewOn()
        makeInnerViewOff()
        composeImageViewFromOuterAndInnerCircle()
    }
    
    private func makeOuterCircle() {
        let outerRect = CGRect.init(origin: .zero, size: CGSize.init(width: 50.0, height: 50.0))
        self.outerView = UIView.init(frame: outerRect)
        formatOuterCircle()
    }
    
    private func makeInnerViewOn() {
        let innerRect = CGRect.init(origin: .zero, size: CGSize.init(width: 40.0, height: 40.0))
        self.innerOnView = UIView.init(frame: innerRect)
        formatInnerViewOn()
    }
    
    private func makeInnerViewOff() {
        let innerRect = CGRect.init(origin: .zero, size: CGSize.init(width: 40.0, height: 40.0))
        self.innerOffView = UIView.init(frame: innerRect)
        formatInnerViewOff()
    }
    
    private func composeImageViewFromOuterAndInnerCircle() {
        
        innerOnView.center = outerView.center
        innerOffView.center = outerView.center
        guard let finalView = outerView else {fatalError()}
        
        finalView.addSubview(innerOnView)
        self.onImage = UIImage(view: finalView)
        
        finalView.removeAllSubviews()
        finalView.addSubview(innerOffView)
        self.offImage = UIImage(view: finalView)
        
    }
    
    private func formatOuterCircle() {
        outerView.layer.borderWidth = 1.0
        outerView.layer.cornerRadius = self.outerView.bounds.width/2
        outerView.layer.borderColor = UIColor.leadLinkColor.cgColor
    }
    
    private func formatInnerViewOn() {
        innerOnView.layer.cornerRadius = 0.5
        innerOnView.layer.cornerRadius = self.innerOnView.bounds.width/2
        innerOnView.layer.backgroundColor = UIColor.leadLinkColor.cgColor
    }
    private func formatInnerViewOff() {
        innerOffView.layer.cornerRadius = 0.5
        innerOffView.layer.cornerRadius = self.innerOnView.bounds.width/2
        innerOffView.layer.backgroundColor = UIColor.white.cgColor
    }
}
