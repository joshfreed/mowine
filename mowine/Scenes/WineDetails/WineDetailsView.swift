//
//  WineDetailsView.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model
import SwiftyBeaver
import FirebaseCrashlytics
import Dip

struct WineDetailsView: View {
    let wineId: String

    @Injected private var query: GetWineDetailsQuery

    @Environment(\.dismiss) private var dismiss

    @State private var wineNotFound = false

    var body: some View {
        Group {
            if let wine = query.wine {
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
            try await query.execute(wineId: wineId)
        } catch GetWineDetailsQuery.Errors.wineNotFound {
            wineNotFound = true
        } catch {
            SwiftyBeaver.error("\(error)")
            Crashlytics.crashlytics().record(error: error)
        }
    }
}

struct WineDetailsHeaderView: View {
    let wine: GetWineDetailsQuery.WineDetails

    var body: some View {
        VStack(spacing: 16) {
            WineThumbnail(wineId: wine.id, size: 172)
            Text(wine.name)
                .foregroundColor(.white)
                .fontWeight(.black)
                .font(.system(size: 28))
            RatingLabel(rating: wine.rating, starSize: 30, showEmptyStars: false)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding([.top, .bottom], 24)
        .background(Color("Primary"))
    }
}

struct WineDetailsFormView: View {
    let wine: GetWineDetailsQuery.WineDetails

    var body: some View {
        Form {
            Section(header: Text("")) {
                HStack {
                    Text("Variety")
                    Spacer()
                    Text(wine.varietyName)
                }

                HStack {
                    Text("Type")
                    Spacer()
                    Text(wine.typeName)
                }

                HStack {
                    Text("Price")
                    Spacer()
                    Text(wine.price)
                }
            }

            Section(header: Text("Where can I buy this?")) {
                HStack {
                    Text(wine.location)
                }
            }
        }
    }
}

fileprivate var wineId = WineId()

struct WineDetailsView_Previews: PreviewProvider {
    static var query: GetWineDetailsQuery = {
        let repo = MemoryWineRepository()

        var wine = Wine(
            id: wineId,
            userId: UserId(),
            type: WineType(name: "Red", varieties: [.init(name: "Merlot")]),
            name: "Test Wine",
            rating: 3
        )
        wine.variety = WineVariety(name: "Merlot")
        wine.price = "Fifty bucks"
        wine.location = "The Wegman's on 13th st"
        repo.wines.append(wine)

        // thumbnailPath: "Wine1"

        return GetWineDetailsQuery(wineRepository: repo)
    }()

    static var previews: some View {
        WineDetailsView(wineId: "W1")
            .addPreviewEnvironment()
            .addPreviewData()
    }
}
