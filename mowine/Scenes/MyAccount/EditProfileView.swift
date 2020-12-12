//
//  EditProfileView.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditProfileView: View {
    @ObservedObject var vm: EditProfileViewModel
    
    var body: some View {
        NavigationView {
            EditProfileFormView(
                firstName: $vm.firstName,
                lastName: $vm.lastName,
                emailAddress: $vm.emailAddress,
                profilePicture: $vm.profilePicture
            ) { pickerSourceType in
                vm.selectProfilePicture(from: pickerSourceType)
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                vm.cancel()
            }, trailing: Button("Save") {
                vm.saveProfile()
            }.disabled(!vm.canSave))
        }
        .accentColor(.mwSecondary)
        .onAppear {
            vm.loadProfile()
        }
        .alert(isPresented: $vm.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(vm.saveErrorMessage))
        }
        .sheet(isPresented: $vm.isShowingSheet, content: {
            if vm.isPickingImage {
                ImagePickerView(sourceType: vm.pickerSourceType) { image in
                    vm.changeProfilePicture(to: image)
                } onCancel: {
                    vm.cancelSelectProfilePicture()
                }
            } else if vm.isReauthenticating {
                ReauthenticationView(vm: ReauthenticationViewModel {
                    vm.reauthenticationSuccess()
                } onCancel: {
                    vm.cancel()
                })
            } else {
                EmptyView()
            }
        })
        .loading(isShowing: vm.isSaving, text: "Saving...")
    }
}

struct EditProfileFormView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var emailAddress: String
    @Binding var profilePicture: Data?
    var changeProfilePicture: (ImagePickerView.SourceType) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 6) {
            Color.clear.frame(height: 26)

            ProfilePictureOverlayView(profilePicture: $profilePicture, changeProfilePicture: changeProfilePicture)

            Color.clear.frame(height: 20)

            FancyTextField(title: "First Name", text: $firstName)
            FancyTextField(title: "Last Name", text: $lastName)
            FancyTextField(title: "Email Address", text: $emailAddress)

            Spacer()
        }.padding([.leading, .trailing], 16)
    }
}

struct ProfilePictureOverlayView: View {
    @Binding
    var profilePicture: Data?
    
    var changeProfilePicture: (ImagePickerView.SourceType) -> Void = { _ in }
    
    @State
    private var isShowingActionSheet: Bool = false

    var body: some View {
        ZStack {
            ProfilePictureView2(data: profilePicture)
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

struct EditProfileView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var isEditingProfile = true

        var body: some View {
            EditProfileView(vm: EditProfileViewModel.make())
        }
    }

    static var previews: some View {
        ShimView()
    }
}
