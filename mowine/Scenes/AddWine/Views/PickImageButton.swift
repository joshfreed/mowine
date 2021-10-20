//
//  PickImageButton.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct PickImageButton: View {
    let title: String
    let sourceType: ImagePickerView.SourceType
    @Binding var isPicking: Bool
    @Binding var image: UIImage?
    @Binding var showNextScreen: Bool
    
    var body: some View {
        PrimaryButton(action: { isPicking = true }, title: title, isLoading: .constant(false), height: 80, fontSize: 28)
            .sheet(isPresented: $isPicking) {
                ImagePickerView(sourceType: sourceType) {
                    image = $0
                    showNextScreen = true
                    isPicking = false
                } onCancel: {
                    isPicking = false
                }
            }
    }
}

struct PickImageButton_Previews: PreviewProvider {
    struct ShimView: View {
        @State var isPicking = false
        @State var image: UIImage?
        @State var showNextScreen = false
        
        var body: some View {
            PickImageButton(title: "Pick an Image", sourceType: .photoLibrary, isPicking: $isPicking, image: $image, showNextScreen: $showNextScreen)
        }
    }
    
    static var previews: some View {
        ShimView().previewLayout(.sizeThatFits)
    }
}
