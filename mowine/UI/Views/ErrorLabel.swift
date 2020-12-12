//
//  ErrorLabel.swift
//  mowine
//
//  Created by Josh Freed on 12/12/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct ErrorLabel: View {
    let error: String
    
    init(_ error: String) {
        self.error = error
    }
    
    var body: some View {
        if !error.isEmpty {
            Text(error)
                .foregroundColor(.red)
        }
    }
}

struct ErrorLabel_Previews: PreviewProvider {
    static var previews: some View {
        ErrorLabel("Something went wrong!")
    }
}
