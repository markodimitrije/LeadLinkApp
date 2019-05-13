//
//  QuestionsScrollView.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 24/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
//import RxSwift
//import RxCocoa

class QuestionsScrollView: UIScrollView {
    var confirmBtn: UIButton?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightGray
        self.frame = frame
        self.contentSize = frame.size
    }
    
    func add(confirmBtn: UIButton) {
        self.confirmBtn = confirmBtn
        self.addSubview(confirmBtn)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
