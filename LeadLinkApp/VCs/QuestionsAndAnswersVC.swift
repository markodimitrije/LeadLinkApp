//
//  Q&AVC.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 19/03/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class QuestionsAndAnswersVC: UIViewController, Storyboarded {
    var viewModel: QuestionsViewmodel!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        self.alert(alertInfo: AlertInfo.getInfo(type: .dataPermission))
            .subscribe(onNext: { index in
                switch index {
                case 0: print("all good...")
                case 1: self.navigationController?.popViewController(animated: true)
                default: break
                }
            })
            .disposed(by: disposeBag)
    }
    
}
