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

struct FinalizeWineView: View {
    @EnvironmentObject var vm: AddWineViewModel
    @EnvironmentObject var wineWorker: WineWorker
    @ObservedObject var model: NewWineModel
    
    @State private var isSaving = false
    @State private var isErrorSaving = false
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 32) {
            EnterNameView(name: $model.name)
            RateWineView(rating: $model.rating)
            if model.isComplete {
                PrimaryButton(action: { addWine() }, title: "Add Wine", isLoading: $isSaving, height: 64, fontSize: 28)
                    .accessibility(identifier: "createWineButton")
            }
            Spacer()
        }
        .navigationTitle("Add Wine")
        .padding(16)
    }
    
    func addWine() {
        isSaving = true

        wineWorker.createWine(from: model) { result in
            switch result {
            case .success: vm.closeModal = true
            case .failure(let error): displayAddWineError(error)
            }
        }
    }

    private func displayAddWineError(_ error: Error) {
        isSaving = false
        SwiftyBeaver.error("\(error)")
        isErrorSaving = true
        errorMessage = error.localizedDescription
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
