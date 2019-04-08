//
//  SignInByEmailViewController.swift
//  mowine
//
//  Created by Josh Freed on 4/8/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit

protocol SignInByEmailViewControllerDelegate: class {
    func signInComplete()
}

class SignInByEmailViewController: UIViewController {
    weak private(set) var delegate: SignInByEmailViewControllerDelegate?
    private var signInStoryboard: UIStoryboard!
    private var rootViewController: UINavigationController!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(delegate: SignInByEmailViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init from coder")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let vc = makeSignInViewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelSignUp))
        
        rootViewController = UINavigationController(rootViewController: vc)
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationBar.barTintColor = .mwPrimary
        rootViewController.navigationBar.isTranslucent = false
        rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        rootViewController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        addChild(rootViewController)
        view.addSubview(rootViewController.view)
        rootViewController.view.jpfPinToSuperview()
        rootViewController.didMove(toParent: self)
    }
    
    @objc func cancelSignUp() {
        dismiss(animated: true, completion: nil)
    }
    
    private func makeSignInViewController() -> SignInViewController {
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        vc.delegate = self
        return vc
    }
}

extension SignInByEmailViewController: SignInViewControllerDelegate {
    func signedIn(_ viewController: SignInViewController) {
        delegate?.signInComplete()
        dismiss(animated: true, completion: nil)
    }
}
