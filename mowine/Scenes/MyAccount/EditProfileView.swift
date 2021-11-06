//
//  EditProfileView.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct EditProfileView: View {
    @StateObject var vm = EditProfileViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            EditProfileFormView(
                fullName: $vm.fullName,
                emailAddress: $vm.emailAddress,
                profilePicture: $vm.profilePicture
            )
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
        .sheet(isPresented: $vm.isReauthenticating) {
            ReauthenticationView {
                Task {
                    await vm.reauthenticationSuccess()
                    dismiss()
                }
            }
        }
        .loading(isShowing: vm.isSaving, text: "Saving...")
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
