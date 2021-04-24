//
//  WineCellarView.swift
//  mowine
//
//  Created by Josh Freed on 3/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

class WineCellarViewModel: ObservableObject, WineCellarDisplayLogic {
    @Published var types: [String] = []

    private var interactor: WineCellarBusinessLogic?

    func setup(services: JFContainer, userId: String) {
        let viewController = self
        let interactor = WineCellarInteractor()
        let presenter = WineCellarPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        interactor.worker = WineCellarWorker(
            wineTypeRepository: services.wineTypeRepository,
            userRepository: services.userRepository,
            wineRepository: services.wineRepository
        )
        interactor.userId = UserId(string: userId)
        presenter.viewController = viewController
    }

    func load() {
        let request = WineCellar.GetWineTypes.Request()
        interactor?.getWineTypes(request: request)
    }

    func displayWineTypes(viewModel: WineCellar.GetWineTypes.ViewModel) {
        self.types = viewModel.types
    }

    func displaySelectedType(viewModel: WineCellar.SelectType.ViewModel) {

    }
}

struct WineCellarView: View {
    var userId: String
    @EnvironmentObject var services: JFContainer
    @StateObject var vm = WineCellarViewModel()

    var body: some View {
        Group {
            if vm.types.isEmpty {
                Text("There are no wines in the cellar.")
                    .font(.system(size: 21))
                    .foregroundColor(Color("Text Label"))
            } else {
                VStack(spacing: 4) {
                    ForEach(vm.types, id: \.self) { type in
                        NavigationLink(destination: WineTypeListView(userId: userId, typeName: type)) {
                            PrimaryButtonLabel(title: type, height: 80, fontSize: 37)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
            vm.setup(services: services, userId: userId)
            vm.load()
//            vm.types = ["Red", "White"]
        }
    }
}

struct WineCellarView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarView(userId: "A")
            .addPreviewEnvironment()
    }
}
