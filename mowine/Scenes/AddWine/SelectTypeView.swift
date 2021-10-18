//
//  SelectTypeView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct SelectTypeView: View {
    @ObservedObject var model: NewWineModel
    let wineTypes: [WineType]
    @State private var showNextScreen = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AddWineHeaderView()
                VStack(spacing: 4) {
                    ForEach(wineTypes) { type in
                        PrimaryButton(action: {
                            model.wineType = type
                            showNextScreen = true
                        }, title: type.name, height: 80, fontSize: 37)
                    }
                }
            }
            .padding(16)

            NavigationLink(destination: makeDestinationView(), isActive: $showNextScreen) {
                EmptyView()
            }
        }
        .accessibilityIdentifier("SelectType")
    }
    
    private func makeDestinationView() -> AnyView {
        if let wineType = model.wineType, !wineType.varieties.isEmpty {
            return AnyView(SelectVarietyView(model: model, varieties: wineType.varieties))
        } else {
            return AnyView(SnapPhotoView(model: model))
        }
    }
}

struct SelectTypeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTypeView(model: NewWineModel(), wineTypes: MemoryWineTypeRepository().types)
    }
}
