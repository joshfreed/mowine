//
//  AddWineView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver

struct AddWineView: View {
    @EnvironmentObject var container: JFContainer
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: AddWineViewModel
    @StateObject var newWineModel = NewWineModel()
    
    var body: some View {
        NavigationView {
            SelectTypeView(model: newWineModel, wineTypes: vm.wineTypes)
                .navigationBarTitle("Add a Wine", displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
        .accentColor(.mwSecondary)
        .onAppear {
            vm.load()
        }
        .onChange(of: vm.closeModal, perform: { value in
            if value {
                presentationMode.wrappedValue.dismiss()
            }
        })
        .environmentObject(vm)
    }
}

struct AddWineView_Previews: PreviewProvider {
    static var previews: some View {
        AddWineView(vm: AddWineViewModel(
            wineTypeRepository: MemoryWineTypeRepository(),
            worker: FakeWineWorker()
        ))
    }
}
