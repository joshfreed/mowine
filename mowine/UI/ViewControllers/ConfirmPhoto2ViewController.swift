//
//  ConfirmPhoto2ViewController.swift
//  mowine
//
//  Created by Josh Freed on 1/13/19.
//  Copyright © 2019 Josh Freed. All rights reserved.
//

import UIKit

protocol ConfirmPhotoViewControllerDelegate: AnyObject {
    func confirm(_ controller: ConfirmPhoto2ViewController, photo: UIImage)
}

class ConfirmPhoto2ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var photo: UIImage!

    weak var delegate: ConfirmPhotoViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = photo
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
    }

    @IBAction func useThisPhoto(_ sender: Any) {
        delegate?.confirm(self, photo: photo)
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        displayImagePickerController(.camera)
    }
    
    @IBAction func chooseFromLibrary(_ sender: Any) {
        displayImagePickerController(.photoLibrary)
    }

    func displayImagePickerController(_ sourceType: UIImagePickerController.SourceType) {
        let controller = UIImagePickerController()
        controller.sourceType = sourceType
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension ConfirmPhoto2ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.photo = image
            self.imageView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
}
