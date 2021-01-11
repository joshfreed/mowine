//
//  MyAccountViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import SwiftUI

protocol MyAccountViewControllerDelegate: class {
    func didSignOut()
}

class MyAccountViewController: UIViewController {
    weak var delegate: MyAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let session = ObservableSession(session: JFContainer.shared.session)
        
        let emailLogInViewModel = EmailLogInViewModel(emailAuth: try! JFContainer.shared.container.resolve())
        let signUpWorker = SignUpWorker(
            emailAuthService: try! JFContainer.shared.container.resolve(),
            userRepository: try! JFContainer.shared.container.resolve(),
            session: try! JFContainer.shared.container.resolve()
        )
        let emailSignUpViewModel = EmailSignUpViewModel(worker: signUpWorker)
        let socialAuthViewModel = SocialAuthViewModel(firstTimeWorker: JFContainer.shared.firstTimeWorker())
        
        let rootView = MyAccountViewContainer()
            .environmentObject(session)
            .environmentObject(makeMyAccountViewModel())
            .environmentObject(emailLogInViewModel)
            .environmentObject(emailSignUpViewModel)
            .environmentObject(socialAuthViewModel)
        
        return UIHostingController(coder: coder, rootView: rootView)
    }

    private func makeMyAccountViewModel() -> MyAccountViewModel {
        let session: Session = try! JFContainer.shared.container.resolve()
        let getMyAccountQuery = GetMyAccountQueryHandler(userRepository: JFContainer.shared.userRepository, session: session)
        let profilePictureWorker: ProfilePictureWorkerProtocol = try! JFContainer.shared.container.resolve()
        let signOutCommand = SignOutCommand(session: session)
        return MyAccountViewModel(
            getMyAccountQuery: getMyAccountQuery,
            profilePictureWorker: profilePictureWorker,
            signOutCommand: signOutCommand
        )
    }
}
