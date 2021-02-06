//
//  EditWineFormView.swift
//  mowine
//
//  Created by Josh Freed on 1/31/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditWineFormView: View {
    @ObservedObject var vm: EditWineFormModel
    
    var body: some View {
        Form {
            Section(header: Text("")) {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Fancy Wine Name", text: $vm.name).multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Rating")
                    Spacer()
                    RatingView(rating: $vm.rating)
                }
            
                Picker("Type", selection: $vm.selectedTypeId) {
                    ForEach(vm.types) {
                        Text($0.name)
                    }
                }
                
                Picker("Variety", selection: $vm.selectedVarietyId) {
                    ForEach(vm.varieties) {
                        Text($0.name)
                    }
                }
                
                HStack {
                    Text("Location")
                    Spacer()
                    TextField("Where did I find this wine?", text: $vm.location).multilineTextAlignment(.trailing)
                }
                
                HStack {
                    Text("Price")
                    Spacer()
                    TextField("How much was this wine?", text: $vm.price).multilineTextAlignment(.trailing)
                }
            }
            
            Section(header: Text("Pairs Well With")) {
                EditPairingsView(pairings: $vm.pairings)
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $vm.notes)
            }
            
            Section(header: Text("")) {
                Button(action: {}) {
                    Text("Delete Wine")
                        .foregroundColor(.red)
                        
                }
            }
        }
    }
}

struct EditWineFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditWineFormView(vm: EditWineFormModel())
    }
}
