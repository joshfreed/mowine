//
//  FancyTextField.swift
//  mowine
//
//  Created by Josh Freed on 11/25/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct FancyTextField: View {
    let title: String
    let text: Binding<String>
    
    var body: some View {
        TextField("", text: text)
            .fancyField(title: title, text: text)
            .padding(.bottom, 4)
    }
}

struct FancyTextField_Previews: PreviewProvider {
    struct ShimView: View {
        let title: String
        @State var text: String = ""
        
        var body: some View {
            FancyTextField(title: "First Name", text: $text)
        }
    }
    static var previews: some View {
        ShimView(title: "First Name", text: "Larry Bird").previewLayout(.sizeThatFits)
        ShimView(title: "Last Name", text: "").previewLayout(.sizeThatFits)
    }
}
