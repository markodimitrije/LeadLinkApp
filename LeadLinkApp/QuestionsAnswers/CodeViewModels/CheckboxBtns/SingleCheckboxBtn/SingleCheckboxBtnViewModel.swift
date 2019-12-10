//
//  SingleCheckboxBtnViewModel.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 10/12/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

class SingleCheckboxBtnViewModel: GetViewProtocol {
   
    private var myView: UIView!
    
    private var _isOn: Bool = false
    private var button: UIButton!
    
    private var checkboxBtnOnImg = CheckboxBtnImage().onImage
    private var checkboxBtnOffImg = CheckboxBtnImage().offImage
    
    private var delegate: BtnTapListening?
    
    var isOn: Bool {
        get {
            return _isOn
        }
        set {
            _isOn = newValue
            let img = _isOn ? checkboxBtnOnImg : checkboxBtnOffImg
            button.setBackgroundImage(img, for: .normal)
        }
    }
    
    init(viewFactory: SingleCheckboxBtnViewFactory, isOn: Bool) {
        self.myView = viewFactory.getView()
        let buttons = self.myView.subviews.filter {$0 is UIButton} as! [UIButton]
        let imgButton = buttons.first(where: {$0.backgroundImage(for: .normal) != nil})
        self.button = imgButton
        self.isOn = isOn
        self.myView.tag = self.button.tag
    }
    
    func getView() -> UIView {
        return myView
    }
    
}


