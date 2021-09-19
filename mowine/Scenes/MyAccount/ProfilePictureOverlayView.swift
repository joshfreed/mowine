//
//  ProfilePictureOverlayView.swift
//  mowine
//
//  Created by Josh Freed on 9/19/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct ProfilePictureOverlayView: View {
    @Binding
    var profilePicture: UIImage?

    var changeProfilePicture: (ImagePickerView.SourceType) -> Void = { _ in }

    @State
    private var isShowingActionSheet: Bool = false

    var body: some View {
        ZStack {
            ProfilePictureView2(image: profilePicture)
                .frame(width: 128, height: 128)
            Image("Profile Picture Overlay")
                .resizable()
                .frame(width: 128, height: 128)
        }
        .onTapGesture {
            isShowingActionSheet = true
        }
        .actionSheet(isPresented: $isShowingActionSheet, content: {
            ActionSheet(title: Text("Change Profile Picture"), message: nil, buttons: [
                .default(Text("Camera"), action: {
                    changeProfilePicture(.camera)
                }),
                .default(Text("Photo Library"), action: {
                    changeProfilePicture(.photoLibrary)
                }),
                .cancel()
            ])
        })
    }
}

struct ProfilePictureOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePictureOverlayView(profilePicture: .constant(nil)).previewLayout(.sizeThatFits)
        ProfilePictureOverlayView(profilePicture: .constant(UIImage(named: "JoshCats"))).previewLayout(.sizeThatFits)
    }
}
