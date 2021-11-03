//
//  WineDetailsView.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import JFLib_Mediator
import MoWine_Application

struct WineDetailsView: View {
    let wineId: String

    @Injected private var mediator: Mediator
    @Environment(\.dismiss) private var dismiss
    @State private var wine: GetWineDetailsResponse?
    @State private var wineNotFound = false

    var body: some View {
        Group {
            if let wine = wine {
                VStack(spacing: 0) {
                    WineDetailsHeaderView(wine: wine)
                    WineDetailsFormView(wine: wine)
                }
            } else {
                Text("Loading...")
            }
        }
        .task {
            await loadWineDetails()
        }
        .alert("Wine not found", isPresented: $wineNotFound) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }

    func loadWineDetails() async {
        do {
            wine = try await mediator.send(GetWineDetails(wineId: wineId))
        } catch GetWineDetailsErrors.wineNotFound {
            wineNotFound = true
        } catch {
            CrashReporter.shared.record(error: error)
        }
    }
}

struct WineDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        WineDetailsView(wineId: "W1")
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
