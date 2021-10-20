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
    let varieties: [AddWine.WineVariety]
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
    static let varieties: [AddWine.WineVariety] = [
        .init(name: "Variety 1"),
        .init(name: "Variety 2"),
        .init(name: "Variety 3"),
        .init(name: "Variety 4"),
        .init(name: "Variety 5"),
    ]

    static var previews: some View {
        SelectVarietyView(model: NewWineModel(), varieties: varieties)
    }
}
