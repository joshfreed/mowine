//
//  WineCellarView.swift
//  mowine
//
//  Created by Josh Freed on 3/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import MoWine_Application

struct WineCellarView: View {
    let userId: String
    @ObservedObject var vm: WineCellarViewModel

    var body: some View {
        Group {
            if vm.types.isEmpty {
                Text("There are no wines in the cellar.")
                    .font(.system(size: 21))
                    .foregroundColor(Color("Text Label"))
            } else {
                VStack(spacing: 4) {
                    ForEach(vm.types, id: \.self) { type in
                        NavigationLink(destination: WineTypeListView(userId: userId, typeName: type)) {
                            PrimaryButtonLabel(title: type, height: 80, fontSize: 37)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    WineCellarView(userId: "U1", vm: WineCellarViewModel())
        .addPreviewEnvironment()
        .addPreviewData()
}
