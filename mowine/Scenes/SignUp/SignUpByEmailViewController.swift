//
//  SignUpByEmailViewController.swift
//  mowine
//
//  Created by Josh Freed on 1/11/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import JFLib
import SwiftyBeaver

protocol SignUpByEmailViewControllerDelegate: class {
    func signUpComplete()
}

protocol SignUpViewControllerDelegate: class {
    func signedUp(_ viewController: SignUpViewController)
}

protocol ProfilePictureViewControllerDelegate: class {
    func profilePicture(_ controller: ProfilePictureViewController, picked: UIImage)
}

class SignUpByEmailViewController: UIViewController {
    weak private(set) var delegate: SignUpByEmailViewControllerDelegate?
    private var mainStoryboard: UIStoryboard!
    private var signInStoryboard: UIStoryboard!
    private var rootViewController: UINavigationController!
    private var profilePictureWorker: ProfilePictureWorker!
    private var session: Session!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    init(delegate: SignUpByEmailViewControllerDelegate) {
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init from coder")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profilePictureWorker = try! JFContainer.shared.container.resolve()
        session = try! JFContainer.shared.container.resolve()

        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        signInStoryboard = UIStoryboard(name: "SignIn", bundle: nil)
        let vc = makeSignUpViewController()
        vc.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelSignUp))
        
        rootViewController = UINavigationController(rootViewController: vc)
        rootViewController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationBar.barTintColor = .mwPrimary
        rootViewController.navigationBar.isTranslucent = false
        rootViewController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        rootViewController.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        rootViewController.navigationItem.backBarButtonItem?.isEnabled = false
        rootViewController.interactivePopGestureRecognizer!.isEnabled = false
        
        addChild(rootViewController)
        view.addSubview(rootViewController.view)
        rootViewController.view.jpfPinToSuperview()
        rootViewController.didMove(toParent: self)
    }

    @objc func cancelSignUp() {
        dismiss(animated: true, completion: nil)
    }

    @objc func skipProfilePicture() {
        signUpComplete()
    }
    
    func makeSignUpViewController() -> UIViewController {
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "SignUpViewController") as! SignUpViewController
        vc.delegate = self
        return vc
    }
    
    func makeProfilePictureViewController() -> UIViewController {
        let vc = signInStoryboard.instantiateViewController(withIdentifier: "ProfilePictureViewController") as! ProfilePictureViewController
        vc.delegate = self
        vc.navigationItem.leftBarButtonItem = nil
        vc.navigationItem.hidesBackButton = true
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: nil, action: #selector(skipProfilePicture))
        return vc
    }

    func makePhotoConfirmationViewController(photo: UIImage) -> ConfirmPhoto2ViewController {
        let vc = mainStoryboard.instantiateViewController(withIdentifier: "ConfirmPhoto2ViewController") as! ConfirmPhoto2ViewController
        vc.delegate = self
        vc.navigationItem.leftBarButtonItem = nil
        vc.navigationItem.hidesBackButton = true
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: nil, action: #selector(skipProfilePicture))
        return vc
    }

    func signUpComplete() {
        delegate?.signUpComplete()
        dismiss(animated: true, completion: nil)
    }
}

extension SignUpByEmailViewController: SignUpViewControllerDelegate {
    func signedUp(_ viewController: SignUpViewController) {
        // Push next view controller in the stackaroni
        let nextVC = makeProfilePictureViewController()
        rootViewController.pushViewController(nextVC, animated: true)
        
        // ORRRRRRRRR
        //signUpViewController.performSegue(withIdentifier: "NextThinger")
    }
}

extension SignUpByEmailViewController: ProfilePictureViewControllerDelegate {
    func profilePicture(_ controller: ProfilePictureViewController, picked: UIImage) {
        let vc = makePhotoConfirmationViewController(photo: picked)
        rootViewController.pushViewController(vc, animated: true)
        vc.photo = picked
    }
}

extension SignUpByEmailViewController: ConfirmPhotoViewControllerDelegate {
    func confirm(_ controller: ConfirmPhoto2ViewController, photo: UIImage) {
        guard let newUserId = session.currentUserId else {
            fatalError("NO USER AFTER SIGN UP SHIT")
        }

        let loadingView = LoadingView(parentView: rootViewController.view)
        loadingView.show()
        
        profilePictureWorker.setProfilePicture(userId: newUserId, image: photo) { result in
            loadingView.hide()
            
            switch result {
            case .success:
                self.signUpComplete()
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
            }
        }
    }
}
