//
//  WineCellarView.swift
//  mowine
//
//  Created by Josh Freed on 3/21/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI
import Model

struct WineCellarView: View {
    @StateObject var vm: WineCellarViewModel

    var body: some View {
        Group {
            if vm.types.isEmpty {
                Text("There are no wines in the cellar.")
                    .font(.system(size: 21))
                    .foregroundColor(Color("Text Label"))
            } else {
                VStack(spacing: 4) {
                    ForEach(vm.types, id: \.self) { type in
                        NavigationLink(destination: WineTypeListView(userId: vm.userId, typeName: type)) {
                            PrimaryButtonLabel(title: type, height: 80, fontSize: 37)
                        }
                    }
                }
            }
        }
        .padding(.horizontal)
        .task {
            await vm.load()
        }
    }
}

struct WineCellarView_Previews: PreviewProvider {
    static var previews: some View {
        WineCellarView(vm: .init(userId: "A"))
            .addPreviewEnvironment()
    }
}
