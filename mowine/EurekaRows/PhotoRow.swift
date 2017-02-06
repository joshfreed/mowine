//
//  PhotoRow.swift
//  mowine
//
//  Created by Josh Freed on 2/2/17.
//  Copyright © 2017 BleepSmazz. All rights reserved.
//

import UIKit
import Eureka

/// Selector Controller used to pick an image
open class ImagePickerController : UIImagePickerController, TypedRowControllerType, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    /// The row that pushed or presented this controller
    public var row: RowOf<UIImage>!
    
    /// A closure to be called when the controller disappears.
    public var onDismissCallback : ((UIViewController) -> ())?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    open func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        (row as? PhotoRow)?.imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        row.value = info[UIImagePickerControllerOriginalImage] as? UIImage
        onDismissCallback?(self)
    }
    
    open func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        onDismissCallback?(self)
    }
}


class PhotoCell: Cell<UIImage>, CellType {
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var cameraButtonView: UIView!
    @IBOutlet weak var photoLibraryButtonView: UIView!
    
    public override func setup() {
        super.setup()
        
        selectionStyle = .none
        
        cameraButtonView.layer.cornerRadius = 5
        cameraButtonView.clipsToBounds = true
        cameraButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openCamera)))
        
        photoLibraryButtonView.layer.cornerRadius = 5
        photoLibraryButtonView.clipsToBounds = true
        photoLibraryButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoLibrary)))
    }
    
    public override func update() {
        super.update()
        photoView.image = (row as? PhotoRow)?.value
    }
    
    func openCamera() {
        (row as? PhotoRow)?.displayImagePickerController(.camera)
    }
    
    func openPhotoLibrary() {
        (row as? PhotoRow)?.displayImagePickerController(.photoLibrary)
    }
}

//final class PhotoRow: Row<PhotoCell>, RowType {
final class PhotoRow: SelectorRow<PhotoCell, ImagePickerController>, RowType {
    public required init(tag: String?) {
        super.init(tag: tag)
        
        cellProvider = CellProvider<PhotoCell>(nibName: "PhotoCell")
        
        presentationMode = .presentModally(
            controllerProvider: ControllerProvider.callback { return ImagePickerController() },
            onDismiss: { [weak self] vc in
                self?.select()
                vc.dismiss(animated: true)
        })
    }
    
    override func customDidSelect() {
        // do nothing on select!
    }
    
    func displayImagePickerController(_ sourceType: UIImagePickerControllerSourceType) {
        if let presentationMode = presentationMode, !isDisabled {
            if let controller = presentationMode.makeController() {
                controller.row = self
                controller.sourceType = sourceType
                onPresentCallback?(cell.formViewController()!, controller)
                presentationMode.present(controller, row: self, presentingController: cell.formViewController()!)
            }
            else{
//                _sourceType = sourceType
//                presentationMode.present(nil, row: self, presentingController: cell.formViewController()!)
            }
        }
    }
}

