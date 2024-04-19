//
//  TextStyles.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

extension Text {
    func buttonPrimaryOutline() -> some View {
        self.font(.system(size: 21))
            .fontWeight(.light)
            .foregroundColor(Color(.mwPrimary))
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .frame(height: 48)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color(.mwPrimary), lineWidth: 1)
            )
    }
}
