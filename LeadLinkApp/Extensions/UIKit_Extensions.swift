//
//  UIKit_Extensions.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 09/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let campaignPlaceholder = UIImage.init(named: "navusLogo.png")
    
    static func imageFromData(data: Data?) -> UIImage? {
        guard let data = data else {return nil}
        return UIImage.init(data: data)
    }
}
