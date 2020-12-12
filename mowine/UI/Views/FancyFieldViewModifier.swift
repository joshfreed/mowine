//
//  FancyFieldViewModifier.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct FancyFieldViewModifier: ViewModifier {
    let title: String
    let text: Binding<String>
    
    func body(content: Content) -> some View {
        ZStack(alignment: .leading) {
            Text(title)
                .foregroundColor(Color(.placeholderText))
                .offset(y: text.wrappedValue.isEmpty ? 0 : -26)
                .scaleEffect(text.wrappedValue.isEmpty ? 1 : 0.75, anchor: .leading)
            VStack(spacing: 2) {
                content
                Divider()
            }
        }
        .padding(.top, 16)
        .animation(.spring(response: 0.2, dampingFraction: 0.5))
    }
}

extension View {
    func fancyField(title: String, text: Binding<String>) -> some View {
        modifier(FancyFieldViewModifier(title: title, text: text))
    }
}
