//
//  EditWineView.swift
//  mowine
//
//  Created by Josh Freed on 1/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditWineView: View {
    @StateObject var vm: EditWineViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            EditWineFormView(vm: vm.form) {
                deleteWine()
            } changeImage: { pickerSourceType in
                vm.selectWinePhoto(from: pickerSourceType)
            }
            .navigationBarTitle("Edit Wine", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                dismiss()
            }, trailing: Button("Save") {
                saveWine()
            })
        }
        .loading(isShowing: vm.isSaving, text: "Saving...")
        .accentColor(.mwSecondary)
        .task {
            await vm.load()
        }
        .sheet(isPresented: $vm.isShowingSheet) {
            ImagePickerView(sourceType: vm.pickerSourceType) { image in
                vm.changeWinePhoto(to: image)
            } onCancel: {
                vm.cancelSelectWinePhoto()
            }
        }
    }

    func saveWine() {
        Task {
            do {
                try await vm.save()
                dismiss()
            } catch {
                // Don't dismiss
            }
        }
    }

    func deleteWine() {
        Task {
            do {
                try await vm.deleteWine()
                dismiss()
            } catch {
                // Don't dismiss
            }
        }
    }
}

struct EditWineView_Previews: PreviewProvider {
    static var previews: some View {
        EditWineView(vm: .init(wineId: ""))
            .addPreviewEnvironment()
    }
}
