//
//  SnapPhotoView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct SnapPhotoView: View {
    @ObservedObject var model: NewWineModel
    @State var isTakingPhoto = false
    @State var isPickingImage = false
    @State var showNextScreen = false
    
    var body: some View {
        VStack(spacing: 0) {
            AddWineHeaderView()
            
            VStack(spacing: 20) {
                Text("Snap the Bottle")
                    .font(.system(size: 37))
                    .fontWeight(.black)
                VStack(spacing: 4) {
                    PickImageButton(title: "Take Photo", sourceType: .camera, isPicking: $isTakingPhoto, image: $model.image, showNextScreen: $showNextScreen)
                    PickImageButton(title: "Choose from Library", sourceType: .photoLibrary, isPicking: $isPickingImage, image: $model.image, showNextScreen: $showNextScreen)
                }
            }
            Spacer()
            NavigationLink(destination: FinalizeWineView(model: model)) {
                Text("Take Later")
                    .font(.system(size: 21))
                    .foregroundColor(Color("Primary Light"))
            }
            
            NavigationLink(destination: ConfirmPhotoView(model: model), isActive: $showNextScreen) {
                EmptyView()
            }
        }
        .padding(16)
    }
}

struct SnapPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        SnapPhotoView(model: NewWineModel())
    }
}
