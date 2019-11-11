//
//  File.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 02/01/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    // MARK: - Methods
    public func present(errorMessage: ErrorMessage) {
        let errorAlertController = UIAlertController(title: errorMessage.title,
                                                     message: errorMessage.message,
                                                     preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        errorAlertController.addAction(okAction)
        present(errorAlertController, animated: true, completion: nil)
    }

}
