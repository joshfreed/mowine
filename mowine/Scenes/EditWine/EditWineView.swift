//
//  EditWineView.swift
//  mowine
//
//  Created by Josh Freed on 1/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditWineView: View {
    let wineId: String
    @StateObject var vm: EditWineViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            EditWineFormView(vm: vm.form) { pickerSourceType in
                vm.selectWinePhoto(from: pickerSourceType)
            }
            .navigationBarTitle("Edit Wine", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Save") {
                vm.save() {
                    presentationMode.wrappedValue.dismiss()
                }
            })
        }
        .loading(isShowing: vm.isSaving, text: "Saving...")
        .accentColor(.mwSecondary)
        .onAppear {
            vm.load(wineId: wineId)
        }
        .sheet(isPresented: $vm.isShowingSheet) {
            ImagePickerView(sourceType: vm.pickerSourceType) { image in
                vm.changeWinePhoto(to: image)
            } onCancel: {
                vm.cancelSelectWinePhoto()
            }
        }
    }
}

struct EditWineView_Previews: PreviewProvider {
    static var previews: some View {
        EditWineView(wineId: "", vm: EditWineViewModel(editWineService: FakeEditWineService()))
    }
}