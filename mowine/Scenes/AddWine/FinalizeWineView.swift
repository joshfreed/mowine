//
//  FinalizeWineView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import JFLib_Mediator
import MoWine_Application
import OSLog

struct FinalizeWineView: View {
    @ObservedObject var model: NewWineModel

    @EnvironmentObject private var vm: AddWineViewModel
    @Injected private var mediator: Mediator
    private let logger = Logger(category: .ui)

    @State private var isSaving = false
    @State private var isErrorSaving = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 32) {
            EnterNameView(name: $model.name)
            RateWineView(rating: $model.rating)
            if model.isComplete {
                PrimaryButton(
                    action: {
                        Task {
                            await addWine()
                        }
                    },
                    title: "Add Wine",
                    isLoading: $isSaving,
                    height: 64,
                    fontSize: 28
                )
                    .accessibilityIdentifier("createWineButton")
            }
            Spacer()
        }
        .navigationTitle("Add Wine")
        .padding(16)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("Finalize Wine View")
    }

    @MainActor
    func addWine() async {
        isSaving = true

        guard model.isComplete else {
            fatalError("Called addWine but the model is not complete")
        }

        guard let wineType = model.wineType else {
            fatalError("model.wineType must not be nil")
        }

        do {
            let command = CreateWineCommand(
                name: model.name,
                rating: model.rating,
                wineType: wineType.name,
                wineVariety: model.wineVariety?.name,
                image: model.image?.pngData()
            )
            try await mediator.send(command)
            vm.closeModal = true
        } catch {
            isSaving = false
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
            isErrorSaving = true
            errorMessage = error.localizedDescription
        }
    }
}

struct EnterNameView: View {
    @Binding var name: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Enter the name, brand, or description of this wine")
                .multilineTextAlignment(.center)
            TextField("", text: $name)
                .accessibility(identifier: "wineName")
                .frame(height: 40)
                .font(.system(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
                .padding([.leading, .trailing], 4)
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(UIColor.separator)))
        }
    }
}

struct RateWineView: View {
    @Binding var rating: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text("How'd you like it?")
            RatingPicker(rating: $rating, starSize: 45)
        }
    }
}

struct FinalizeWineView_Previews: PreviewProvider {
    static var previews: some View {
        FinalizeWineView(model: NewWineModel())
            .addPreviewEnvironment()
    }
}
