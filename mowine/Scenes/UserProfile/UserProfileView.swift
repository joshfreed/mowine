//
//  UserProfileView.swift
//  mowine
//
//  Created by Josh Freed on 2/27/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var users: UsersService
    let userId: String
    
    var body: some View {
        VStack(spacing: 0) {
            UserProfileHeaderView(vm: .init(userId: userId, users: users))
            Spacer()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
        .navigationBarItems(trailing: FriendButton(userId: userId))
    }
}

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfileView(userId: "1")
        }
        .environmentObject(FriendsService.make())
        .environmentObject(UsersService.make())
    }
}
