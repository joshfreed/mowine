//
//  MyAccountViewController2ViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import UIKit
import SwiftUI

class MyAccountViewController2: UIViewController {
    weak var delegate: MyAccountViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let getMyAccountQuery = GetMyAccountQuery(userRepository: JFContainer.shared.userRepository, session: JFContainer.shared.session)
        let profilePictureWorker: ProfilePictureWorkerProtocol = try! JFContainer.shared.container.resolve()
        let signOutCommand = SignOutCommand(session: JFContainer.shared.session)
        let viewModel = MyAccountViewModel(
            getMyAccountQuery: getMyAccountQuery,
            profilePictureWorker: profilePictureWorker,
            signOutCommand: signOutCommand
        )
        let rootView = MyAccountView(viewModel: viewModel)
        return UIHostingController(coder: coder, rootView: rootView)
    }
}
