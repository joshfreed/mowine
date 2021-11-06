//
//  EditProfileFormView.swift
//  mowine
//
//  Created by Josh Freed on 9/19/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditProfileFormView: View {
    @Binding var fullName: String
    @Binding var emailAddress: String
    @Binding var profilePicture: UserPhoto

    var body: some View {
        VStack(spacing: 6) {
            Color.clear.frame(height: 26)

            ChangeProfilePictureView(profilePicture: $profilePicture)

            Color.clear.frame(height: 20)

            TextField("", text: $fullName)
                .fancyField(title: "Full Name", text: $fullName)
                .padding(.bottom, 4)

            TextField("", text: $emailAddress)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .fancyField(title: "Email Address", text: $emailAddress)
                .padding(.bottom, 4)

            Spacer()
        }.padding([.leading, .trailing], 16)
    }
}

struct EditProfileFormView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var fullName = "Testy Testguy"
        @State var emailAddress = "test@test.com"
        @State var profilePicture: UserPhoto = .uiImage(UIImage(named: "JoshCats")!)

        var body: some View {
            EditProfileFormView(fullName: $fullName, emailAddress: $emailAddress, profilePicture: $profilePicture)
        }
    }

    static var previews: some View {
        ShimView()
    }
}
