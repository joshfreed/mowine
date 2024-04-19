//
//  SignInHeaderView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct SignInHeaderView: View {
    var body: some View {
        VStack {
            Text("i want")
                .foregroundColor(.white)
                .font(.custom("Snell Roundhand", size: 37))
            Text("mo' wine")
                .foregroundColor(.white)
                .font(.system(size: 50))
                .fontWeight(.black)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding(.top, 100)
        .padding(.bottom, 64)
        .background(Color(.mwPrimary))
    }
}

struct SignInHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SignInHeaderView()
    }
}
