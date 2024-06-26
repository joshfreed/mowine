//
//  AnonymousUserView.swift
//  mowine
//
//  Created by Josh Freed on 12/31/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct AnonymousUserView: View {
    @State private var showLogIn = false
    @State private var showSignUp = false

    var body: some View {
        VStack(spacing: 0) {
            Text("Get mo' out of mo' wine with a free account")
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 37))
                .foregroundColor(.white)
                .frame(minWidth: 0, maxWidth: .infinity)
                .padding(.top, 100)
                .padding(.bottom, 56)
                .background(Color(.mwPrimary))

            Spacer()
            
            VStack(spacing: 40) {
                CoolCopyView(
                    image: "Red Wine Button",
                    headline: "Connect with your friends so they can see the wines you love and hate."
                )
                
                CoolCopyView(
                    image: "Bubbly Button",
                    headline: "Sync your data across all your Apple devices."
                )
            }
            .padding([.leading, .trailing])
            
            Spacer()
            
            HStack {
                PrimaryButton(action: { showLogIn = true }, title: "Log In")
                    .sheet(isPresented: $showLogIn) {
                        LogInView()
                    }
                PrimaryButton(action: { showSignUp = true }, title: "Sign Up")
                    .sheet(isPresented: $showSignUp) {
                        SignUpView()
                    }
            }
            .padding([.leading, .trailing])
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct CoolCopyView: View {
    let image: String
    let headline: String
    
    var body: some View {
        VStack(spacing: 4) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(Color(.mwDarkGray))
            
            Text(headline)
                .fixedSize(horizontal: false, vertical: true)
                .font(.system(size: 21))
                .multilineTextAlignment(.center)
        }
    }
}

struct AnonymousUserView_Previews: PreviewProvider {
    static var previews: some View {
        AnonymousUserView()
    }
}
