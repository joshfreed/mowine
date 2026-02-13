//
//  WineDetailsView.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineDetailsView: View {
    let wineId: String

    @StateObject private var vm = WineDetailsViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Group {
            if let wine = vm.wine {
                VStack(spacing: 0) {
                    WineDetailsHeaderView(wine: wine)
                    WineDetailsFormView(wine: wine)
                }
            } else {
                Text("Loading...")
            }
        }
        .task {
            await vm.load(wineId: wineId)
        }
        .alert("Wine not found", isPresented: $vm.wineNotFound) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        }
    }
}

#Preview {
    WineDetailsView(wineId: "W1")
        .addPreviewEnvironment()
        .addPreviewData()
}
