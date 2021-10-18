//
//  SelectVarietyView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct SelectVarietyView: View {
    @ObservedObject var model: NewWineModel
    let varieties: [WineVariety]
    @State private var showNextScreen = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AddWineHeaderView()
                VStack(spacing: 4) {
                    ForEach(varieties) { variety in
                        PrimaryButton(action: {
                            model.wineVariety = variety
                            showNextScreen = true
                        }, title: variety.name, height: 80, fontSize: 28)
                    }
                }
            }
            .padding(16)

            NavigationLink(destination: SnapPhotoView(model: model), isActive: $showNextScreen) {
                EmptyView()
            }
        }
        .accessibilityIdentifier("SelectVariety")
    }
}

struct SelectVarietyView_Previews: PreviewProvider {
    static var previews: some View {
        SelectVarietyView(model: NewWineModel(), varieties: MemoryWineTypeRepository().types.first!.varieties)
    }
}
