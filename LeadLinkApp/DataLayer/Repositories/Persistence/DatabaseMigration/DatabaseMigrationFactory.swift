//
//  DatabaseMigrationFactory.swift
//  LeadLinkApp
//
//  Created by Marko Dimitrijevic on 22/07/2019.
//  Copyright © 2019 Marko Dimitrijevic. All rights reserved.
//

import Foundation

class DatabaseMigrationFactory {
    func makeMigrator() -> DataBaseMigrating {
        return RealmSchemaMigrator(newVersion: 1)
    }
}
