//
//  FileUserSessionDataStore.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import PromiseKit

public class FileUserSessionDataStore: UserSessionDataStore {
    
    // MARK: - Properties
    var docsURL: URL? {
        return FileManager
            .default.urls(for: FileManager.SearchPathDirectory.documentDirectory,
                          in: FileManager.SearchPathDomainMask.allDomainsMask).first
    }
    
    // MARK: - Methods
    public init() {}
    
    public func readUserSession() -> Promise<UserSession> {
        return Promise() { seal in
            guard let docsURL = docsURL else {
                seal.reject(LeadLinkKitError.any)
                return
            }
            guard let jsonData = try? Data(contentsOf: docsURL.appendingPathComponent("user_session.json")) else {
                seal.reject(UserSessionError.notSignedIn)
                return
            }
            let decoder = JSONDecoder()
            let userSession = try! decoder.decode(UserSession.self, from: jsonData)
            
            seal.fulfill(userSession)
        }
    }
    
    public func save(userSession: UserSession) -> Promise<(UserSession)> {
        return Promise() { seal in
            let encoder = JSONEncoder()
            let jsonData = try! encoder.encode(userSession)
            
            guard let docsURL = docsURL else {
                seal.reject(LeadLinkKitError.any)
                return
            }
            
            try? jsonData.write(to: docsURL.appendingPathComponent("user_session.json"))
            seal.fulfill(userSession)
        }
    }
    
    public func delete(userSession: UserSession) -> Promise<(UserSession)> {
        return Promise() { seal in
            guard let docsURL = docsURL else {
                seal.reject(LeadLinkKitError.any)
                return
            }
            do {
                try FileManager.default.removeItem(at: docsURL.appendingPathComponent("user_session.json"))
            } catch {
                seal.reject(LeadLinkKitError.any)
                return
            }
            seal.fulfill(userSession)
        }
    }
}
