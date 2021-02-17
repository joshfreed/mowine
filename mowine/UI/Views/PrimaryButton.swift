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
    var fontSize: CGFloat = 21

    init(
        action: @escaping () -> Void,
        title: String,
        isLoading: Binding<Bool> = .constant(false),
        height: CGFloat = 48,
        fontSize: CGFloat = 21
    ) {
        self.action = action
        self.title = title
        self._isLoading = isLoading
        self.height = height
        self.fontSize = fontSize
    }
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(height: height)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .background(PrimaryGradient())
                    .cornerRadius(5)
            } else {
                PrimaryButtonLabel(title: title, height: height, fontSize: fontSize)
            }
        }
        .disabled(isLoading)
    }
}

struct PrimaryButtonLabel: View {
    let title: String
    var height: CGFloat = 48
    var fontSize: CGFloat = 21
    
    var body: some View {
        Text(title)
            .font(.system(size: fontSize))
            .fontWeight(.light)
            .foregroundColor(.white)
            .frame(height: height)
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(PrimaryGradient())
            .cornerRadius(5)
    }
}

struct PrimaryGradient: View {
    let colors: [Color] = [
        Color(.mwDefaultGradient1),
        Color(.mwDefaultGradient2)
    ]
    
    var body: some View {
        LinearGradient(gradient: .init(colors: colors), startPoint: .top, endPoint: .bottom)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(action: {}, title: "Click Me").previewLayout(.sizeThatFits)
        PrimaryButton(action: {}, title: "Click Me", isLoading: .constant(true)).previewLayout(.sizeThatFits)
        PrimaryButtonLabel(title: "My Label").previewLayout(.sizeThatFits)
    }
}
