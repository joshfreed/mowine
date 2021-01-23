//
//  PrimaryButton.swift
//  mowine
//
//  Created by Josh Freed on 12/12/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct PrimaryButton: View {
    let action: () -> Void
    let title: String
    @Binding var isLoading: Bool
    var height: CGFloat = 48
    var backgroundColor: Color = Color("Primary")

    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(height: height)
                    .frame(minWidth: 0, maxWidth: .infinity)
            } else {
                Text(title)
                    .font(.system(size: 21))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .frame(height: height)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .disabled(isLoading)
        .background(backgroundColor)
        .cornerRadius(5)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(action: {}, title: "Click Me", isLoading: .constant(false))
    }
}
