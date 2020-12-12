//
//  FancySecureField.swift
//  mowine
//
//  Created by Josh Freed on 12/6/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct FancySecureField: View {
    let title: String
    let text: Binding<String>
    
    var body: some View {
        SecureField("", text: text)
            .fancyField(title: title, text: text)
            .padding(.bottom, 4)
    }
}

struct FancySecureField_Previews: PreviewProvider {
    static var previews: some View {
        FancySecureField(title: "Password", text: .constant(""))
    }
}
