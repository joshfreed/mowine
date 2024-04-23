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
import OSLog

struct WineTypeListView: View {
    let userId: String
    let typeName: String

    @Injected private var mediator: Mediator
    private let logger = Logger(category: .ui)

    @State private var wines: [GetWinesByTypeResponse.Wine] = []

    var body: some View {
        List(wines) { wine in
            WineDetailsNavigationLink(wine: wine)
        }
        .listStyle(.plain)
        .task { await load() }
    }

    private func load() async {
        do {
            let response: GetWinesByTypeResponse = try await mediator.send(GetWinesByTypeQuery(userId: userId, type: typeName))
            wines = response.wines
        } catch {
            logger.error("\(error)")
            CrashReporter.shared.record(error: error)
        }
    }
}

struct WineTypeListView_Previews: PreviewProvider {
    static var previews: some View {
        WineTypeListView(userId: "1", typeName: "Red")
            .addPreviewEnvironment()
    }
}
