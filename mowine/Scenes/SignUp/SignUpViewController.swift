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

protocol SignUpDisplayLogic: class {
    func displaySignUpResult(viewModel: SignUp.SignUp.ViewModel)
}

class SignUpViewController: UIViewController, SignUpDisplayLogic {
    var interactor: SignUpBusinessLogic?
    var router: (NSObjectProtocol & SignUpRoutingLogic & SignUpDataPassing)?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var firstNameTextField: JPFFancyTextField!
    @IBOutlet weak var lastNameTextField: JPFFancyTextField!
    @IBOutlet weak var emailAddressTextField: JPFFancyTextField!
    @IBOutlet weak var passwordTextField: JPFFancyTextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var signUpButton: ButtonPrimary!
    
    
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = SignUpInteractor()
        let presenter = SignUpPresenter()
        let router = SignUpRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.worker = SignUpWorker(
            emailAuthService: Container.shared.emailAuthService,
            userRepository: Container.shared.userRepository
        )
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    @IBAction func tappedSignInButton(_ sender: UIButton) {
        performSegue(withIdentifier: "SignIn", sender: nil)
    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)        
        
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
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let kbSize = keyboardSize.size
            let contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
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
        
        let request = SignUp.SignUp.Request(firstName: firstName, lastName: lastName, emailAddress: emailAddress, password: password)
        interactor?.signUp(request: request)
    }
    
    func displaySignUpResult(viewModel: SignUp.SignUp.ViewModel) {
        signUpButton.displayNotLoading()
        
        if viewModel.error == nil {
            router?.routeToSignedIn()
        } else {
            if let message = viewModel.message {
                showErrorLabel(message)
            } else {
                showErrorLabel("Whoops! An error occurred while trying to sign you up.")
            }
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

