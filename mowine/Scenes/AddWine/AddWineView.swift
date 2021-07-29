//
//  AddWineView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Model

struct AddWineView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wineTypeService: WineTypeService    
    @StateObject var vm = AddWineViewModel()
    @StateObject var newWineModel = NewWineModel()
    
    var body: some View {
        NavigationView {
            SelectTypeView(model: newWineModel, wineTypes: wineTypeService.wineTypes)
                .navigationBarTitle("Add a Wine", displayMode: .inline)
                .navigationBarItems(leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                })
        }
        .accentColor(.mwSecondary)
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
        AddWineView()
            .addPreviewEnvironment()
    }
}
