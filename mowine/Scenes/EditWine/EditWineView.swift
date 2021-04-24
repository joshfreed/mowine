//
//  EditWineView.swift
//  mowine
//
//  Created by Josh Freed on 1/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import FirebaseCrashlytics

struct EditWineView: View {
    let wineId: String
    @EnvironmentObject var editWineService: EditWineService
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var vm = EditWineViewModel()
    
    var body: some View {
        NavigationView {
            EditWineFormView(vm: vm.form) {
                deleteWine()
            } changeImage: { pickerSourceType in
                vm.selectWinePhoto(from: pickerSourceType)
            }
            .navigationBarTitle("Edit Wine", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                vm.save(editWineService: editWineService) {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .loading(isShowing: vm.isSaving, text: "Saving...")
        .accentColor(.mwSecondary)
        .onAppear {
            vm.load(wineId: wineId, editWineService: editWineService)
        }
        .sheet(isPresented: $vm.isShowingSheet) {
            ImagePickerView(sourceType: vm.pickerSourceType) { image in
                vm.changeWinePhoto(to: image)
            } onCancel: {
                vm.cancelSelectWinePhoto()
            }
        }
    }

    func deleteWine() {
        editWineService.deleteWine(wineId: wineId) { result in
            switch result {
            case .success: presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                SwiftyBeaver.error("\(error)")
                Crashlytics.crashlytics().record(error: error)
            }
        }
    }
}

struct EditWineView_Previews: PreviewProvider {
    static var previews: some View {
        EditWineView(wineId: "")
            .addPreviewEnvironment()
    }
}
