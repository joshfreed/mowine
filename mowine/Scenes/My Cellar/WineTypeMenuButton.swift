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
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(UIColor.mwSecondary))
                .frame(width: 60, height: 90)

            Text(name)
                .font(.system(size: 37))
                .foregroundColor(Color(UIColor.mwSecondary))
        }
    }
}


struct WineTypeMenuButton_Previews: PreviewProvider {
    static var previews: some View {
        WineTypeMenuButton(name: "Red", icon: "Red Wine Button")
    }
}
