//
//  EmailReauthViewController.swift
//  mowine
//
//  Created by Josh Freed on 11/6/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import JFLib
import SwiftyBeaver

protocol EmailReauthViewControllerDelegate: class {
    func reauthenticationSucceeded()
}

class EmailReauthViewController: UIViewController {
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var passwordTextField: JPFFancyTextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var signInButton: ButtonPrimary!
    
    weak var delegate: EmailReauthViewControllerDelegate?

    private var session: Session!
    private var email: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        errorLabel.isHidden = true

        session = JFContainer.shared.session
//        session = FakeSession()

        guard let auth = session.getCurrentAuth(), let email = auth.email else {
            showError("You don't appear to be logged in.")
            emailAddressLabel.isHidden = true
            passwordTextField.isHidden = true
            signInButton.isHidden = true
            return
        }

        self.email = email
        emailAddressLabel.text = email
    }
    
    @IBAction func reauthenticate(_ sender: Any) {
        signInButton.displayLoading()

        errorLabel.isHidden = true

        let password = passwordTextField.text ?? ""

        session.reauthenticate(withEmail: email, password: password) { result in
            DispatchQueue.main.async {
                self.signInButton.displayNotLoading()

                switch result {
                case .success: self.delegate?.reauthenticationSucceeded()
                case .failure(let error): self.showError(error)
                }
            }            
        }
    }

    func showError(_ error: Error) {
        SwiftyBeaver.error("\(error)")
        errorLabel.isHidden = false
        errorLabel.text = "\(error.localizedDescription)"
    }

    func showError(_ message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
    }
}
