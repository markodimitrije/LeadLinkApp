//
//  UIImage+Extensions.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 12/11/2019.
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

extension UIImage {
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in:UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: image!.cgImage!)
    }
}
