//
//  EditProfileViewController.swift
//  mowine
//
//  Created by Josh Freed on 6/16/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit
import JFLib
import SwiftyBeaver

class EditProfileViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var profilePictureView: ProfilePictureView!
    @IBOutlet weak var firstNameTextField: JPFFancyTextField!
    @IBOutlet weak var lastNameTextField: JPFFancyTextField!
    @IBOutlet weak var emailAddressTextField: JPFFancyTextField!
    @IBOutlet weak var profilePictureOverlay: UIImageView!
    
    var editProfileService: EditProfileService!
    var loadingView: LoadingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editProfileService = try! JFContainer.shared.container.resolve()
        
        disableSaveButton()
        
        profilePictureView.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailAddressTextField.delegate = self
        
        loadingView = LoadingView(parentView: navigationController!.view)
        
        editProfileService.fetchProfile { result in
            switch result {
            case .success(let viewModel): self.displayProfile(viewModel)
            case .failure(let error): self.displayErrorLoadingProfile(error)
            }
        }
        
        editProfileService.getProfilePicture { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.displayProfilePicture(data: data)
                }
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
    
    // MARK: Save
    
    @IBAction func tappedSave(_ sender: Any) {
        SwiftyBeaver.info("Saving profile...")
        
        loadingView.show("Saving...")
        
        editProfileService.saveProfile(email: emailAddressTextField.text!, firstName: firstNameTextField.text!, lastName: lastNameTextField.text) { result in
            SwiftyBeaver.info("Save profile complete")
            
            self.loadingView.hide()
            
            switch result {
            case .success: self.performSegue(withIdentifier: "exit", sender: self)
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                self.showAlert(error: error)
            }
        }
    }
    
    func enableSaveButton() {
        saveButton.isEnabled = true
    }
    
    func disableSaveButton() {
        saveButton.isEnabled = false
    }
    
    // MARK: Profile Picture
    
    func displayProfilePicture(data: Data?) {
        profilePictureView.setData(data)
    }
    
    func displayEditProfilePictureSourceSelect() {
        let alertController = UIAlertController(title: "Change Profile Picture", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.displayImagePickerController(.camera)
        }))
        alertController.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { action in
            self.displayImagePickerController(.photoLibrary)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func displayImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
    
    func selectProfilePicture(_ image: UIImage) {
        editProfileService.updateProfilePicture(image)
        profilePictureView.setImage(image)
        enableSaveButton()
        profilePictureOverlay.isHidden = true
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.selectProfilePicture(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: ProfilePictureViewDelegate {
    func tappedProfilePicture(_ view: ProfilePictureView) {
        displayEditProfilePictureSourceSelect()
    }
}

extension EditProfileViewController: JPFFancyTextFieldDelegate {
    func textFieldDidChange(_ textField: JPFFancyTextField) {
        if textField == emailAddressTextField {
            
        } else if textField == firstNameTextField {
            
        } else if textField == lastNameTextField {
            
        }
        enableSaveButton()
    }
}
