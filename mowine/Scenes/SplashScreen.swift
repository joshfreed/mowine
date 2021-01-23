//
//  SplashScreen.swift
//  mowine
//
//  Created by Josh Freed on 1/23/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Text("mo' wine")
                .font(.system(size: 37))
                .fontWeight(.heavy)
                .foregroundColor(.white)
            
            Text("Rate and remember the wines you drink.")
                .font(.system(size: 21))
                .foregroundColor(Color.white.opacity(0.54))
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding([.leading, .trailing], 49)
        .frame(minWidth: 0, maxWidth: .infinity)
        .background(Color("Primary"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
