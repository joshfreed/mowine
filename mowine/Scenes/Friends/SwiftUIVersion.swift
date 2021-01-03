//
//  SwiftUIVersion.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct FriendsUIKitView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: "friendsNavController") as! UINavigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

class FriendsHostingController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBSegueAction func addSwiftUIView(_ coder: NSCoder) -> UIViewController? {
        let session = ObservableSession(session: JFContainer.shared.session)
        
        let emailLogInViewModel = EmailLogInViewModel(emailAuth: try! JFContainer.shared.container.resolve())
        let signUpWorker = SignUpWorker(
            emailAuthService: try! JFContainer.shared.container.resolve(),
            userRepository: try! JFContainer.shared.container.resolve(),
            session: try! JFContainer.shared.container.resolve()
        )
        let emailSignUpViewModel = EmailSignUpViewModel(worker: signUpWorker)
        let socialAuthViewModel = SocialAuthViewModel(firstTimeWorker: JFContainer.shared.firstTimeWorker())
        
        let rootView = FriendsContainerView()            
            .environmentObject(session)
            .environmentObject(emailLogInViewModel)
            .environmentObject(emailSignUpViewModel)
            .environmentObject(socialAuthViewModel)
        
        return UIHostingController(coder: coder, rootView: rootView)
    }
}

struct FriendsContainerView: View {
    @EnvironmentObject var session: ObservableSession
    
    @State private var activeSheet: MyAccountSheet?
    
    var body: some View {
        Group {
            if session.isAnonymous {
                AnonymousUserView() { activeSheet = $0 }
            } else {
                FriendsUIKitView()
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .logIn: LogInView() { activeSheet = nil }
            case .signUp: SignUpView() { activeSheet = nil }
            default: EmptyView()
            }
        }
    }
}
