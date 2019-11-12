//
//  FileManager+Extensions.swift
//  tryToAppendDataToFile
//
//  Created by Marko Dimitrijevic on 12/09/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import Foundation

extension FileManager {
    static var docDirUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
}
