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
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = AddWineViewModel()
    @StateObject var newWineModel = NewWineModel()
    
    var body: some View {
        NavigationView {
            SelectTypeView(model: newWineModel)
                .navigationBarTitle("Add a Wine", displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    dismiss()
                })
        }
        .accentColor(.mwSecondary)
        .onChange(of: vm.closeModal) {
            if vm.closeModal {
                dismiss()
            }
        }
        .environmentObject(vm)
        .analyticsScreen(name: "Add Wine", class: "AddWineView")
    }
}

struct AddWineView_Previews: PreviewProvider {
    static var previews: some View {
        AddWineView()
            .addPreviewEnvironment()
    }
}
