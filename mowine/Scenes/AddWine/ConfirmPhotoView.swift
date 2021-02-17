//
//  ConfirmPhotoView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct ConfirmPhotoView: View {
    @ObservedObject var model: NewWineModel
    @State var isTakingPhoto = false
    @State var isPickingImage = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text("How's that look?")
                    .font(.system(size: 37))
                    .fontWeight(.black)
                
                WineImageView(image: model.image)
                    .frame(minWidth: geometry.size.width * 0.25, maxWidth: geometry.size.width * 0.6)

                NavigationLink(destination: FinalizeWineView(model: model)) {
                    PrimaryButtonLabel(title: "Nailed It", height: 80, fontSize: 37)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Not so hot? Try again:")
                        .font(.system(size: 21))
                        .frame(height: 38)
                    
                    RedoButton(title: "Take Photo", sourceType: .camera, isPicking: $isTakingPhoto, image: $model.image)
                    RedoButton(title: "Choose from Library", sourceType: .photoLibrary, isPicking: $isPickingImage, image: $model.image)
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            }
            .padding(16)
        }
    }
}

fileprivate func makeModel() -> NewWineModel {
    let model = NewWineModel()
    model.image = UIImage(named: "Wine1")
    return model
}

struct ConfirmPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmPhotoView(model: makeModel())
    }
}
