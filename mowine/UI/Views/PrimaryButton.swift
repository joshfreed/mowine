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
    
    var body: some View {
        Button(action: action) {
            if isLoading {
                if #available(iOS 14.0, *) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(height: 48)
                        .frame(minWidth: 0, maxWidth: .infinity)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                Text(title)
                    .font(.system(size: 21))
                    .fontWeight(.light)
                    .foregroundColor(.white)
                    .frame(height: 48)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
        }
        .disabled(isLoading)
        .background(Color("Primary"))
        .cornerRadius(5)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(action: {}, title: "Click Me", isLoading: .constant(true))
    }
}
