//
//  FinalizeWineView.swift
//  mowine
//
//  Created by Josh Freed on 2/12/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import SwiftyBeaver
import Model
import FirebaseCrashlytics

struct FinalizeWineView: View {
    @EnvironmentObject var vm: AddWineViewModel
    @StateObject var wineWorker: WineWorker = try! JFContainer.shared.resolve()
    @ObservedObject var model: NewWineModel
    
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
                    .accessibility(identifier: "createWineButton")
            }
            Spacer()
        }
        .navigationTitle("Add Wine")
        .padding(16)
    }

    @MainActor
    func addWine() async {
        isSaving = true

        do {
            try await wineWorker.createWine(from: model)
            vm.closeModal = true
        } catch {
            isSaving = false
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
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
