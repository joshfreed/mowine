//
//  RedoButton.swift
//  mowine
//
//  Created by Josh Freed on 2/16/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct RedoButton: View {
    let title: String
    let sourceType: ImagePickerView.SourceType
    @Binding var isPicking: Bool
    @Binding var image: UIImage?
    
    var body: some View {
        Button(action: { isPicking = true }) {
            Text(title)
                .font(.system(size: 21))
                .foregroundColor(Color("Primary Light"))
                .frame(height: 38)
        }.sheet(isPresented: $isPicking) {
            ImagePickerView(sourceType: sourceType) {
                image = $0
                isPicking = false
            } onCancel: {
                isPicking = false
            }
        }
    }
}

struct RedoButton_Previews: PreviewProvider {
    struct ShimView: View {
        @State var isPicking = false
        @State var image: UIImage?
        
        var body: some View {
            RedoButton(title: "Pick Image", sourceType: .photoLibrary, isPicking: $isPicking, image: $image)
        }
    }
    
    static var previews: some View {
        ShimView().previewLayout(.sizeThatFits)
    }
}
