//
//  EditProfileViewController.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import JFLib

class EditProfileViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var profilePictureView: ProfilePictureView!
    @IBOutlet weak var firstNameTextField: JPFFancyTextField!
    @IBOutlet weak var lastNameTextField: JPFFancyTextField!
    @IBOutlet weak var emailAddressTextField: JPFFancyTextField!
    
    var editProfileService: EditProfileService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileService = try! JFContainer.shared.container.resolve()
        
        saveButton.isEnabled = false
        
        editProfileService.fetchProfile { result in
            switch result {
            case .success(let viewModel): self.displayProfile(viewModel)
            case .failure(let error): self.displayErrorLoadingProfile(error)
            }
        }
    }
    
    func displayProfile(_ viewModel: ProfileViewModel) {
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        emailAddressTextField.text = viewModel.emailAddress
    }
    
    func displayErrorLoadingProfile(_ error: Error) {
        showAlert(error: error)
    }
    
    @IBAction func tappedSave(_ sender: Any) {
        
    }
}
