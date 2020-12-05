//
//  LoadingView.swift
//  mowine
//
//  Created by Josh Freed on 11/30/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct LoadingOverlayView: View {
    var isShowing: Bool = false
    var text: String = ""

    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
            VStack {
                Text(text)
                if #available(iOS 14.0, *) {
                    ProgressView()
                } else {
                    // Fallback on earlier versions
                }
            }
                .padding(16)
                .background(Color.white)
                .cornerRadius(8)

        }
        .edgesIgnoringSafeArea(.all)
        .opacity(self.isShowing ? 1 : 0)
    }
}

extension View {
    func loading(isShowing: Bool, text: String) -> some View {
        self.overlay(LoadingOverlayView(isShowing: isShowing, text: text))
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingOverlayView(isShowing: true, text: "Loading...")
    }
}
