//
//  DataBaseEmiters.swift
//  tryLeadLinkModularComponent
//
//  Created by Marko Dimitrijevic on 26/04/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import Realm

struct Output { // treba ti side effects
    var savedAnswer: Observable<MyAnswer> // tap koji mapiras u id (btn.tag)
}
