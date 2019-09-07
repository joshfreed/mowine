//
//  ForgotPasswordViewController.swift
//  mowine
//
//  Created by Josh Freed on 9/7/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import JFLib
import FirebaseAuth
import SwiftyBeaver

class ForgotPasswordViewController: UIViewController {
    @IBOutlet weak var submitButton: ButtonPrimary!
    @IBOutlet weak var emailAddressTextField: JPFFancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailAddressTextField.textField.textContentType = UITextContentType.emailAddress
        emailAddressTextField.textField.returnKeyType = .send
        emailAddressTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        emailAddressTextField.resignFirstResponder()
    }
    
    @IBAction func tappedSendInstructions(_ sender: Any) {
        submit()
    }
    
    func submit() {
        guard let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty else {
            emailAddressTextField.displayInvalid()
            return
        }
        
        emailAddressTextField.displayValid()
        
        submitButton.displayLoading()
        
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { error in
            if let error = error {
                SwiftyBeaver.error("\(error)")
                self.submitButton.displayNotLoading()
                let ac = UIAlertController(title: "Error Sending Email", message: "There was a problem sending the password reset email. Please check your email address and try again.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(ac, animated: true, completion: nil)
            } else {
                let ac = UIAlertController(title: "Email Sent", message: "You should receive a password reset email momentarily. Please check your inbox.", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { _ in
                    self.performSegue(withIdentifier: "goBack", sender: nil)
                }))
                self.present(ac, animated: true, completion: nil)
            }
        }
    }
}
