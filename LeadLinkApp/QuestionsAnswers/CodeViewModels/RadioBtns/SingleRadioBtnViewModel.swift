//
//  SingleRadioBtnViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 11/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SingleRadioBtnViewModel: GetViewProtocol {
   
    var myView: UIView!
    
    private var _isOn: Bool = false
    private var button: UIButton!
    
    private var radioBtnOnImg = RadioBtnImage.init().onImage
    private var radioBtnOffImg = RadioBtnImage.init().offImage
    
    private var delegate: BtnTapListening?
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? radioBtnOnImg : radioBtnOffImg
            button.setBackgroundImage(img, for: .normal)
        }
    }
    
    init(viewFactory: SingleRadioBtnViewFactory, isOn: Bool) {
        self.myView = viewFactory.getView()
        let buttons = self.myView.subviews.filter {$0 is UIButton} as! [UIButton]
        let imgButton = buttons.first(where: {$0.backgroundImage(for: .normal) != nil})
        self.button = imgButton
        self.isOn = isOn
    }
    
    func getView() -> UIView {
        return myView
    }
    
}

