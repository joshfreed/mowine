//
//  SignUpViewController.swift
//  mowine
//
//  Created by Josh Freed on 3/21/18.
//  Copyright (c) 2018 Josh Freed. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import JFLib

class SignUpViewController: UIViewController {
    weak var delegate: SignUpViewControllerDelegate?
    var worker: SignUpWorker!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: JPFFancyTextField!
    @IBOutlet weak var lastNameTextField: JPFFancyTextField!
    @IBOutlet weak var emailAddressTextField: JPFFancyTextField!
    @IBOutlet weak var passwordTextField: JPFFancyTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpButton: ButtonPrimary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        worker = SignUpWorker(
            emailAuthService: JFContainer.shared.emailAuthService,
            userRepository: JFContainer.shared.userRepository,
            session: JFContainer.shared.session
        )
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)        
        
        hideErrorLabel()
        
        firstNameTextField.delegate = self
        firstNameTextField.textField.autocapitalizationType = .words
        firstNameTextField.textField.returnKeyType = .next
        lastNameTextField.delegate = self
        lastNameTextField.textField.autocapitalizationType = .words
        lastNameTextField.textField.returnKeyType = .next
        emailAddressTextField.delegate = self
        emailAddressTextField.textField.textContentType = UITextContentType.emailAddress
        emailAddressTextField.textField.returnKeyType = .next
        passwordTextField.delegate = self
        passwordTextField.textField.isSecureTextEntry = true
        passwordTextField.textField.returnKeyType = .go
        
        firstNameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let kbSize = keyboardSize.size
            let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0);
            scrollView.contentInset = contentInsets
            scrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: Helpers
    
    func hideErrorLabel() {
        errorMessageLabel.isHidden = true
        errorMessageLabel.text = nil
    }
    
    func showErrorLabel(_ error: String) {
        errorMessageLabel.text = error
        errorMessageLabel.isHidden = false
    }

    // MARK: Sign Up
    
    @IBAction func tappedSignUp(_ sender: ButtonPrimary) {
        signUp()
    }
    
    func signUp() {
        hideErrorLabel()
        firstNameTextField.resignFirstResponder()
        lastNameTextField.resignFirstResponder()
        emailAddressTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        if firstNameTextField.text == nil || firstNameTextField.text!.isEmpty {
            firstNameTextField.displayInvalid(message: "First name is required.")
        }
        
        if emailAddressTextField.text == nil || emailAddressTextField.text!.isEmpty {
            emailAddressTextField.displayInvalid(message: "Email address is required.")
        }
        
        if passwordTextField.text == nil || passwordTextField.text!.isEmpty {
            passwordTextField.displayInvalid()
        }
        
        guard
            let firstName = firstNameTextField.text, !firstName.isEmpty,
            let emailAddress = emailAddressTextField.text, !emailAddress.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
        else {
            return
        }

        let lastName = lastNameTextField.text
        
        guard password.count >= 8 else {
            passwordTextField.displayInvalid(message: "Password must be at least 8 characters long")
            return
        }
        
        firstNameTextField.displayValid()
        lastNameTextField.displayValid()
        emailAddressTextField.displayValid()
        passwordTextField.displayValid()
        
        signUpButton.displayLoading()
        
        worker.signUp(emailAddress: emailAddress, password: password, fullName: "") { result in
            switch result {
            case .success: self.displaySignUpSuccess()
            case .failure(let error): self.displaySignUpError(error)
            }
        }
    }
    
    func displaySignUpSuccess() {
        delegate?.signedUp(self)
    }
    
    func displaySignUpError(_ error: Error) {
        signUpButton.displayNotLoading()
        
        if let message = getErrorMessage(error) {
            showErrorLabel(message)
        } else {
            showErrorLabel("Whoops! An error occurred while trying to sign you up.")
        }
    }
    
    private func getErrorMessage(_ error: Error) -> String? {
        switch error {
        case EmailAuthenticationErrors.invalidPassword(let message): return message
        case EmailAuthenticationErrors.emailAddressAlreadyInUse:
            return "That email address is already associated with an account. Try signing in or resetting your password."
        default: return nil
        }
    }
}

extension SignUpViewController: JPFFancyTextFieldDelegate {
    func textFieldShouldReturn(_ textField: JPFFancyTextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            emailAddressTextField.becomeFirstResponder()
        } else if textField == emailAddressTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            signUp()
        }
        return true
    }
}

