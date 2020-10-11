//
//  WineCellarListView.swift
//  mowine
//
//  Created by Josh Freed on 10/11/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct WineCellarListView: View {
    let title: String
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationBarTitle(title)
    }
}

struct WineCellarListView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarListView(title: "Red")
    }
}
