//
//  WineTypeMenuButton.swift
//  mowine
//
//  Created by Josh Freed on 10/21/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineTypeMenuButton: View {
    let name: String
    let icon: String

    var body: some View {
        VStack {
            if !icon.isEmpty {
                Image(icon)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(Color(UIColor.mwSecondary))
                    .frame(width: 60, height: 90)
            }

            Text(name)
                .font(.system(size: 37))
                .foregroundColor(Color(UIColor.mwSecondary))
        }
    }
}

struct WineTypeMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        WineTypeMenuButton(name: "Reds", icon: "Red Wine Button").previewLayout(.sizeThatFits)
        WineTypeMenuButton(name: "Reds", icon: "").previewLayout(.sizeThatFits)
        WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
            .frame(width: 160, height: 160)
            .previewLayout(.sizeThatFits)
    }
}
