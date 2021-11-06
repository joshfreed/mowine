//
//  ProfilePictureOverlayView.swift
//  mowine
//
//  Created by Josh Freed on 9/19/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct ChangeProfilePictureView: View {
    @Binding var profilePicture: UserPhoto

    @State private var isSelectingImageSource = false
    @State private var imagePickerSourceType: ImagePickerView.SourceType?

    var body: some View {
        ZStack {
            UserPhotoView(photo: profilePicture, size: 128)
            Image("Profile Picture Overlay")
                .resizable()
                .frame(width: 128, height: 128)
        }
        .onTapGesture {
            isSelectingImageSource = true
        }
        .actionSheet(isPresented: $isSelectingImageSource) {
            ActionSheet(title: Text("Change Profile Picture"), message: nil, buttons: [
                .default(Text("Camera")) {
                    imagePickerSourceType = .camera
                },
                .default(Text("Photo Library")) {
                    imagePickerSourceType = .photoLibrary
                },
                .cancel()
            ])
        }
        .sheet(item: $imagePickerSourceType) { sourceType in
            ImagePickerView(sourceType: sourceType) { image in
                profilePicture = .uiImage(image)
                imagePickerSourceType = nil
            } onCancel: {
                imagePickerSourceType = nil
            }
        }
    }
}

struct ChangeProfilePictureView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var photo: UserPhoto = .uiImage(UIImage(named: "JoshCats")!)

        var body: some View {
            ChangeProfilePictureView(profilePicture: $photo)
        }
    }

    static var previews: some View {
        ShimView()
            .previewLayout(.sizeThatFits)
    }
}
