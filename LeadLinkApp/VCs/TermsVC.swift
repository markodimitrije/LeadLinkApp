//
//  TermsVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 20/05/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class TermsVC: UIViewController, Storyboarded {
    
    @IBOutlet weak var textView: UITextView!
    @IBAction func doeTapped(_ sender: UIBarButtonItem) {
        doneBtnTapped()
    }
    
    var termsTxt = BehaviorRelay<String>.init(value: "")
    
    private func doneBtnTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    
    private func bindUI() {
        bindTermsTxt()
    }
    
    private func bindTermsTxt() {
        termsTxt
            .subscribe(onNext: { [weak self] termsTxt in
                guard let sSelf = self else {return}
                    sSelf.textView.text = termsTxt
            }).disposed(by: bag)
    }
    
    private let bag = DisposeBag()
    
}

class NavForTermsVC: UINavigationController, Storyboarded {
    
}
