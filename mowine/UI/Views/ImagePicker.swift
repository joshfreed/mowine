//
//  ImagePicker.swift
//  ConstantImprovers
//
//  Created by Josh Freed on 2/6/20.
//  Copyright © 2020 Clay Steadman. All rights reserved.
//

import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    let sourceType: ImagePickerView.SourceType
    var onSelect: (UIImage) -> () = { _ in }
    var onCancel: () -> () = {  }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let uiKitSourceType: UIImagePickerController.SourceType
        switch sourceType {
        case .camera: uiKitSourceType = .camera
        case .photoLibrary: uiKitSourceType = .photoLibrary
        }
        
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = uiKitSourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>) {

    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePickerView

        init(_ view: ImagePickerView) {
            parent = view
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
                return
            }
            parent.onSelect(image)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onCancel()
        }
    }
}

extension ImagePickerView {
    enum SourceType: Identifiable {
        case camera
        case photoLibrary

        var id: String { String(describing: self) }
    }
}
