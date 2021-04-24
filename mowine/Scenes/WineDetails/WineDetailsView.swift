//
//  WineDetailsView.swift
//  mowine
//
//  Created by Josh Freed on 4/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct WineDetailsView: View {
    @EnvironmentObject var query: GetWineDetailsQuery
    let wineId: String

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
        .onAppear {
            query.execute(wineId: wineId)
        }
    }
}

struct WineDetailsHeaderView: View {
    let wine: GetWineDetailsQuery.WineDetails

    var body: some View {
        VStack(spacing: 16) {
            WineImageView(image: nil).frame(width: 172, height: 172)
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

struct WineDetailsView_Previews: PreviewProvider {
    static var query: GetWineDetailsQuery = {
        let q = GetWineDetailsQuery(wineRepository: MemoryWineRepository())
        q.wine = .init(
            id: "A",
            name: "Test Wine",
            rating: 3,
            varietyName: "Merlot",
            typeName: "Red",
            price: "",
            location: ""
        )
        return q
    }()

    static var previews: some View {
        WineDetailsView(wineId: "ABC")
            .environmentObject(query)
    }
}
