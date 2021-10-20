//
//  SelectTypeView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application
import SwiftyBeaver
import FirebaseCrashlytics

class SelectTypeViewModel: ObservableObject {
    @Published var types: [AddWine.WineType] = []

    @Injected private var getWineTypesQueryHandler: GetWineTypesQueryHandler

    func load() async {
        do {
            let response = try await getWineTypesQueryHandler.handle()
            types = response.wineTypes.map { typeModel in
                let varieties = typeModel.varieties.map { varietyModel in AddWine.WineVariety(name: varietyModel.name) }
                return AddWine.WineType(name: typeModel.name, varieties: varieties)
            }
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

struct SelectTypeView: View {
    @ObservedObject var model: NewWineModel
    @State private var showNextScreen = false
    @State private var vm = SelectTypeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AddWineHeaderView()
                VStack(spacing: 4) {
                    ForEach(vm.types) { type in
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
        .task {
            await vm.load()
        }
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
        SelectTypeView(model: NewWineModel())
    }
}
