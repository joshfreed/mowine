//
//  WineTypeListView.swift
//  mowine
//
//  Created by Josh Freed on 3/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import JFLib_Mediator
import MoWine_Application

struct WineTypeListView: View {
    let userId: String
    let typeName: String

    @Injected private var mediator: Mediator

    @State private var wines: [GetWinesByTypeResponse.Wine] = []
    @State private var showWineDetails = false
    @State private var selectedWineId: String = ""

    var body: some View {
        VStack {
            List(wines) { wine in
                WineItemView(wine: wine)
                    .onTapGesture {
                        showWineDetails = true
                        selectedWineId = wine.id
                    }
            }
            .listStyle(.plain)
            .task {
                do {
                    let response: GetWinesByTypeResponse = try await mediator.send(GetWinesByTypeQuery(userId: userId, type: typeName))
                    wines = response.wines
                } catch {
                    CrashReporter.shared.record(error: error)
                }
            }

            NavigationLink(destination: WineDetailsView(wineId: selectedWineId), isActive: $showWineDetails) {
                EmptyView()
            }
        }
    }
}

struct WineTypeListView_Previews: PreviewProvider {
    static var previews: some View {
        WineTypeListView(userId: "1", typeName: "Red")
            .addPreviewEnvironment()
    }
}
