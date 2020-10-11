//
//  MyCellarView.swift
//  mowine
//
//  Created by Josh Freed on 10/4/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct MyCellarView: View {
    @ObservedObject private(set) var viewModel: MyCellarViewModel

    init(viewModel: MyCellarViewModel) {
        self.viewModel = viewModel
        let appearance = UINavigationBarAppearance.mwPrimaryAppearance()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: WineCellarListView(title: "Red Wines")) {
                        WineTypeMenuButton(name: "Red", icon: "Red Wine Button")
                    }

                    Spacer()
                    NavigationLink(destination: WineCellarListView(title: "White Wines")) {
                        WineTypeMenuButton(name: "White", icon: "White Wine Button")
                    }
                    Spacer()
                }
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink(destination: WineCellarListView(title: "Rose")) {
                        WineTypeMenuButton(name: "Rose", icon: "Rose Button")
                    }
                    Spacer()
                    NavigationLink(destination: WineCellarListView(title: "Bubbly")) {
                        WineTypeMenuButton(name: "Bubbly", icon: "Bubbly Button")
                    }
                    Spacer()
                }
                Spacer()
                NavigationLink(destination: WineCellarListView(title: "Other Wines")) {
                    Text("Other")
                        .font(.system(size: 37))
                        .foregroundColor(Color(UIColor.mwSecondary))
                        .padding(.bottom, 32)
                }

            }            
                .navigationBarTitle("My Cellar")
        }
        .accentColor(.mwSecondary)
    }
}

struct WineTypeMenuButton: View {
    let name: String
    let icon: String

    var body: some View {
        VStack {
            Image(icon)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(Color(UIColor.mwSecondary))
                .frame(width: 60, height: 90)

            Text(name)
                .font(.system(size: 37))
                .foregroundColor(Color(UIColor.mwSecondary))
        }
    }
}

struct MyCellarView_Previews: PreviewProvider {
    static var previews: some View {
        MyCellarView(viewModel: MyCellarViewModel())
    }
}
