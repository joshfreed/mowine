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
    @State private var reauth = ReauthenticationController()
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
                    let didSave = await vm.saveProfile(using: reauth)
                    if didSave {
                        dismiss()
                    }
                }
            })
            .sheet(isPresented: $reauth.isPresenting, onDismiss: {
                // If the user dismisses interactively, treat it as a cancel.
                reauth.fail(CancellationError())
            }) {
                ReauthenticationView(reauth: reauth)
            }
        }
        .accentColor(.mwSecondary)
        .task {
            await vm.loadProfile()
        }
        .alert(isPresented: $vm.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(vm.saveErrorMessage))
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
