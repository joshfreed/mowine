//
//  EditProfileView.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct EditProfileView: View {
    @StateObject var vm = EditProfileViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            EditProfileFormView(
                fullName: $vm.fullName,
                emailAddress: $vm.emailAddress,
                profilePicture: $vm.profilePicture
            ) { pickerSourceType in
                vm.selectProfilePicture(from: pickerSourceType)
            }
            .navigationBarTitle("Edit Profile", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                Task {
                    await vm.saveProfile()
                    dismiss()
                }
            })
        }
        .accentColor(.mwSecondary)
        .task {
            await vm.loadProfile()
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
                ReauthenticationView {
                    Task {
                        await vm.reauthenticationSuccess()
                        dismiss()
                    }
                }
            } else {
                EmptyView()
            }
        })
        .loading(isShowing: vm.isSaving, text: "Saving...")
    }
}

@MainActor
fileprivate func viewModel() -> EditProfileViewModel {
    let session: FakeSession = try! JFContainer.shared.resolve()
    let userRepo: FakeUserRepository = try! JFContainer.shared.resolve()

    var user = User(id: UserId(), emailAddress: "test@test.com")
    user.fullName = "Testy McTestguy"

    userRepo.addUser(user)
    session.setUser(user: user)

    return EditProfileViewModel(
        getMyAccountQuery: try! JFContainer.shared.resolve(),
        profilePictureWorker: try! JFContainer.shared.resolve(),
        editProfileService: try! JFContainer.shared.resolve()
    )
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(vm: viewModel())
            .addPreviewEnvironment()
    }
}
