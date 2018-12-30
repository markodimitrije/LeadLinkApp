//
//  ViewController.swift
//  signInApp
//
//  Created by Marko Dimitrijevic on 30/12/2018.
//  Copyright © 2018 Marko Dimitrijevic. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {

    override func viewDidLoad() { super.viewDidLoad()
        
        let dataStore = FileUserSessionDataStore.init()
        
        let credentials = LoginCredentials.init(email: "test.tdasdasdasdae@mailinator.com",
                                                password: "test1234")
        
        let repository = LeadLinkUserSessionRepository.init(dataStore: dataStore, remoteAPI: LeadLinkRemoteAPI.shared)
        
        let responder = FakeSignedInResponder.init()
    
        let signInViewModel = SignInViewModel.init(userSessionRepository: repository, signedInResponder: responder)
        
        //signInViewModel.signIn()
        signInViewModel.fakeSignIn(credentials: credentials)
        
    }


}

struct FakeSignedInResponder: SignedInResponder {
    func signedIn(to userSession: UserSession) {
        print("FakeSignedInResponder.signedIn imam token: \(userSession.remoteSession.token)")
        print("FakeSignedInResponder.signedIn implement me.....")
        print("skini kampanje, save ih na disk, itd....")
    }
    
    
}
