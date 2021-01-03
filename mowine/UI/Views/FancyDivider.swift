//
//  FancyDivider.swift
//  mowine
//
//  Created by Josh Freed on 1/1/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct FancyDivider: View {
    var text: String
    
    var body: some View {
        HStack {
            VStack { Divider() }
            Text(text)
                .font(.caption)
                .foregroundColor(Color("Helper Text"))
            VStack { Divider() }
        }
    }
}

struct FancyDivider_Previews: PreviewProvider {
    static var previews: some View {
        FancyDivider(text: "OR")
    }
}
