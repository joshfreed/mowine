//
//  EditWineFormView.swift
//  mowine
//
//  Created by Josh Freed on 1/31/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct EditWineFormView: View {
    @ObservedObject var vm: EditWineFormModel
    var onDelete: () -> Void = { }
    var changeImage: (ImagePickerView.SourceType) -> Void = { _ in }

    @State private var showConfirmDelete = false

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
                    FormRatingPicker(rating: $vm.rating)
                }
            
                Picker("Type", selection: $vm.selectedTypeId) {
                    ForEach(vm.types) {
                        Text($0.name)
                    }
                }
                
                Picker("Variety", selection: $vm.selectedVarietyId) {
                    Text("").tag(-1)
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
            
            Section(header: Text("Photo")) {
                EditWineImageView(image: $vm.image) { changeImage($0) }
            }.padding(.vertical, 8)
            
            Section(header: Text("Pairs Well With")) {
                EditPairingsView(pairings: $vm.pairings)
            }
            
            Section(header: Text("Notes")) {
                TextEditor(text: $vm.notes)
                    .accessibilityLabel("Notes")
            }
            
            Section(header: Text("")) {
                Button(action: { showConfirmDelete = true }) {
                    Text("Delete Wine")
                        .foregroundColor(.red)
                        
                }
            }
        }
        .actionSheet(isPresented: $showConfirmDelete, content: {
            ActionSheet(title: Text("Are you sure?"), message: Text("This cannot be undone."), buttons: [
                .destructive(Text("Delete Wine")) { onDelete() },
                .cancel()
            ])
        })
    }
}

struct EditWineFormView_Previews: PreviewProvider {
    static var previews: some View {
        EditWineFormView(vm: EditWineFormModel())
    }
}
