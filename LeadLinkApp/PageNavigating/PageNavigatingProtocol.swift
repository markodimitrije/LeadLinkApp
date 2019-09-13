//
//  PageNavigatingProtocol.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/09/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

protocol PageNavigatingProtocol {
    func getNavigationDestination(dict: [String: Any]) -> UIViewController?
}
