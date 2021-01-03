//
//  AnonymousUserView.swift
//  mowine
//
//  Created by Josh Freed on 12/31/20.
//  Copyright © 2020 Josh Freed. All rights reserved.
//

import SwiftUI

struct AnonymousUserView: View {
    var action: (AuthSheet) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            
            Text("Go mo' out of mo' wine with a free account")
                .font(.title)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            VStack(alignment: .leading) {
                Text("You'll always know the best wine to bring")
                    .font(.title2)
                
                Text("Find your friends and bring them their favorite wines.")
                    .font(.callout)
            }
            
            VStack(alignment: .leading) {
                Text("Never receive a bad wine again")
                    .font(.title2)
                
                Text("Your friends can discover your favorite wines.")
                    .font(.callout)
            }
            
            VStack(alignment: .leading) {
                Text("Your wines are safe in the cloud")
                    .font(.title2)
                
                Text("Backup and access your wines on any Apple device.")
                    .font(.callout)
            }
            
            Spacer()
            
            HStack {
                PrimaryButton(
                    action: { action(.logIn) },
                    title: "Log In",
                    isLoading: .constant(false),
                    height: 60
                )
                
                PrimaryButton(
                    action: { action(.signUp) },
                    title: "Sign Up",
                    isLoading: .constant(false),
                    height: 60
                )
            }
            
            Spacer()
        }
        .padding()        
    }
}

struct AnonymousUserView_Previews: PreviewProvider {
    static var previews: some View {
        AnonymousUserView() { _ in }
    }
}
