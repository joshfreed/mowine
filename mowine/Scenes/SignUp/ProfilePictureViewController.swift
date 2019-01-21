//
//  ProfilePictureViewController.swift
//  mowine
//
//  Created by Josh Freed on 1/11/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit

class ProfilePictureViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ProfilePictureViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func takePhoto(_ sender: ButtonPrimary) {
        displayImagePickerController(.camera)
    }

    @IBAction func chooseFromLibrary(_ sender: ButtonPrimary) {
        displayImagePickerController(.photoLibrary)
    }

    func displayImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    func useImage(_ image: UIImage) {
        delegate?.profilePicture(self, picked: image)
    }
}

extension ProfilePictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.useImage(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
