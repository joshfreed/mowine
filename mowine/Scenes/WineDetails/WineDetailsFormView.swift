//
//  WineDetailsFormView.swift
//  mowine
//
//  Created by Josh Freed on 11/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct WineDetailsFormView: View {
    let wine: GetWineDetailsResponse

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

struct WineDetailsFormView_Previews: PreviewProvider {
    static var wine = GetWineDetailsResponse(
        id: "W1",
        name: "Woodbridge 2019",
        rating: 4,
        varietyName: "Merlot",
        typeName: "Red",
        price: "",
        location: "FWGS on Washington"
    )

    static var previews: some View {
        WineDetailsFormView(wine: wine)
    }
}
