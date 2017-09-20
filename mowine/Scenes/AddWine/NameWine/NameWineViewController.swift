//
//  NameWineViewController.swift
//  mowine
//
//  Created by Josh Freed on 8/11/17.
//  Copyright (c) 2017 BleepSmazz. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Cosmos

protocol NameWineDisplayLogic: class {
    func displayPhotoPreview(viewModel: NameWine.GetPhotoPreview.ViewModel)
}

class NameWineViewController: UIViewController, NameWineDisplayLogic {
    var interactor: NameWineBusinessLogic?
    var router: (NSObjectProtocol & NameWineRoutingLogic & NameWineDataPassing)?

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
        let interactor = NameWineInteractor()
        let presenter = NameWinePresenter()
        let router = NameWineRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
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

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        nameTextField.becomeFirstResponder()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)

        nameTextField.delegate = self
        
        doneButton.isHidden = true
        doneButton.alpha = 0
        
        getPhotoPreview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(notification: Notification) {
        if let keyboardEndFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.layoutIfNeeded()
            
            let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.35
            
            let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
            bottomContraint.constant = convertedKeyboardEndFrame.size.height + 16

            UIView.animate(withDuration: animationDuration, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func keyboardWillHide(notification: Notification) {
        view.layoutIfNeeded()
        
        let animationDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.35
        
        bottomContraint.constant = 32
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.layoutIfNeeded()
        })
    }

    // MARK: Get photo preview

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var doneButton: ButtonPrimary!
    
    func getPhotoPreview() {
        let request = NameWine.GetPhotoPreview.Request()
        interactor?.getPhotoPreview(request: request)
    }

    func displayPhotoPreview(viewModel: NameWine.GetPhotoPreview.ViewModel) {
        if let photo = viewModel.photo {
            photoImageView.image = photo
            photoImageView.layer.cornerRadius = photoImageView.frame.size.width / 2
            photoImageView.clipsToBounds = true
            photoImageView.contentMode = .scaleAspectFill
        } else {
            photoImageView.image = #imageLiteral(resourceName: "bottle-of-wine")
            photoImageView.clipsToBounds = false
            photoImageView.contentMode = .scaleAspectFit
            photoImageView.tintColor = UIColor.lightGray
        }        
    }
    
    // MARK: Helper funcs
    
    func showDoneButton() {
        doneButton.isHidden = false
        
        UIView.animate(withDuration: 0.1) {
            self.doneButton.alpha = 1.0
        }
    }
    
    func hideDoneButton() {
        UIView.animate(withDuration: 0.1, animations: {
            self.doneButton.alpha = 0
        }, completion: { _ in
            self.doneButton.isHidden = true
        })
    }
}

extension NameWineViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let newString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string), !newString.isEmpty {
            showDoneButton()
        } else {
            hideDoneButton()
        }
        
        return true
    }
}