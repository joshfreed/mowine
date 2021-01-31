//
//  EditPairingsView.swift
//  mowine
//
//  Created by Josh Freed on 1/30/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct EditPairingsView: View {
    @Binding var pairings: [String]
    
    var body: some View {
        ForEach(pairings.indices, id: \.self) { index in
            TextField("e.g. Sushi, Cheese, etc", text: $pairings[index])
        }.onDelete(perform: deleteItems)
        
        Button(action: { pairings.append("") }) {
            Text("Add Pairing")
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        pairings.remove(atOffsets: offsets)
    }
}

struct EditPairingsView_Previews: PreviewProvider {
    struct ShimView: View {
        @State var pairings: [String] = []
        
        var body: some View {
            Form {
                Section {
                    EditPairingsView(pairings: $pairings)
                }
            }
        }
    }
    
    static var previews: some View {
        ShimView()
    }
}
