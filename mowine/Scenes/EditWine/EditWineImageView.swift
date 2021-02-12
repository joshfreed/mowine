//
//  EditWineImageView.swift
//  mowine
//
//  Created by Josh Freed on 2/6/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditWineImageView: View {
    @Binding
    var image: Data?
    
    var changeImage: (ImagePickerView.SourceType) -> Void = { _ in }
    
    @State
    private var isShowingActionSheet: Bool = false
    
    private let size: CGFloat = 150
    
    var body: some View {
        HStack {
            WineImageView(data: image)
                .frame(width: size, height: size)
            Spacer()
            VStack(spacing: 8) {
                ImagePickerSourceButton(title: "Camera", image: "Camera") { changeImage(.camera) }
                ImagePickerSourceButton(title: "Photo Library", image: "Photo Library") { changeImage(.photoLibrary) }
            }.frame(width: 108)
        }
    }
}

struct ImagePickerSourceButton: View {
    let title: String
    let image: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 48, height: 49)
            
            Text(title)
                .font(.system(size: 12))
            
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(16)
        .background(Color("Image Picker Button"))
        .cornerRadius(5)
        .foregroundColor(Color("Image Picker Title"))
        .onTapGesture {
            action()
        }
    }
}

struct EditWineImageView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var imageData: Data? = UIImage(named: "Wine1 Thumb")?.pngData()
        
        var body: some View {
            EditWineImageView(image: $imageData)
        }
    }
    
    static var previews: some View {
        ShimView()
    }
}
