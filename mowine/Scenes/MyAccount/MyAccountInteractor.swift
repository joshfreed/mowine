//
//  MyAccountInteractor.swift
//  mowine
//
//  Created by Josh Freed on 2/27/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MyAccountBusinessLogic {
    func getUser(request: MyAccount.GetUser.Request)
}

protocol MyAccountDataStore {
    //var name: String { get set }
}

class MyAccountInteractor: MyAccountBusinessLogic, MyAccountDataStore {
    var presenter: MyAccountPresentationLogic?
    var worker: MyAccountWorker?

    // MARK: Get User

    func getUser(request: MyAccount.GetUser.Request) {        
        worker?.getCurrentUser() { result in
            switch result {
            case .success(let user):
                let response = MyAccount.GetUser.Response(user: user)
                self.presenter?.presentUser(response: response)
            case .failure(let error):
                print("\(error)")
                self.presenter?.presentErrorGettingUser()
                break
            }
        }
    }
}
