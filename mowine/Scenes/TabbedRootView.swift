//
//  TabbedRootView.swift
//  mowine
//
//  Created by Josh Freed on 1/3/21.
//  Copyright © 2021 Josh Freed. All rights reserved.
//

import SwiftUI

struct TabbedRootView: View {
    var body: some View {
        TabView {
            myCellarView()
                .tabItem {
                    Image("My Wines Tab").renderingMode(.template)
                    Text("My Cellar")
                }
            
            AddWineUIKitView()
                .tabItem {
                    Image("Add Wine Tab").renderingMode(.template)
                    Text("Add Wine")
                }
            
            friendsView()
                .tabItem {
                    Image("Friends Tab").renderingMode(.template)
                    Text("Friends")
                }
            
            myAccountView()
                .tabItem {
                    Image("My Account Tab").renderingMode(.template)
                    Text("My Account")
                }
        }
        .accentColor(Color("Primary"))
    }
    
    private func myCellarView() -> some View {
        let searchMyCellarQuery = SearchMyCellarQuery(
            wineRepository: JFContainer.shared.wineRepository,
            session: JFContainer.shared.session
        )
        let getWinesByTypeQuery = GetWinesByTypeQuery(
            wineRepository: JFContainer.shared.wineRepository,
            session: JFContainer.shared.session
        )
        let viewModel = MyCellarViewModel(
            wineTypeRepository: JFContainer.shared.wineTypeRepository,
            thumbnailFetcher: try! JFContainer.shared.container.resolve(),
            searchMyCellarQuery: searchMyCellarQuery,
            getWinesByTypeQuery: getWinesByTypeQuery
        )
        viewModel.onEditWine = { wineId in
//            self?.selectedWineId = wineId
//            self?.performSegue(withIdentifier: "editWine", sender: nil)
        }
        return MyCellarView(viewModel: viewModel)
    }
    
    private func friendsView() -> some View {
        let session = ObservableSession(session: JFContainer.shared.session)
        
        let emailLogInViewModel = EmailLogInViewModel(emailAuth: try! JFContainer.shared.container.resolve())
        let signUpWorker = SignUpWorker(
            emailAuthService: try! JFContainer.shared.container.resolve(),
            userRepository: try! JFContainer.shared.container.resolve(),
            session: try! JFContainer.shared.container.resolve()
        )
        let emailSignUpViewModel = EmailSignUpViewModel(worker: signUpWorker)
        let socialAuthViewModel = SocialAuthViewModel(firstTimeWorker: JFContainer.shared.firstTimeWorker())
        
        return FriendsContainerView()
            .environmentObject(session)
            .environmentObject(emailLogInViewModel)
            .environmentObject(emailSignUpViewModel)
            .environmentObject(socialAuthViewModel)
    }
    
    private func myAccountView() -> some View {
        let session = ObservableSession(session: JFContainer.shared.session)
        
        let emailLogInViewModel = EmailLogInViewModel(emailAuth: try! JFContainer.shared.container.resolve())
        let signUpWorker = SignUpWorker(
            emailAuthService: try! JFContainer.shared.container.resolve(),
            userRepository: try! JFContainer.shared.container.resolve(),
            session: try! JFContainer.shared.container.resolve()
        )
        let emailSignUpViewModel = EmailSignUpViewModel(worker: signUpWorker)
        let socialAuthViewModel = SocialAuthViewModel(firstTimeWorker: JFContainer.shared.firstTimeWorker())
        
        return MyAccountViewContainer(session: session, viewModel: makeMyAccountViewModel())
            .environmentObject(emailLogInViewModel)
            .environmentObject(emailSignUpViewModel)
            .environmentObject(socialAuthViewModel)
    }
    
    private func makeMyAccountViewModel() -> MyAccountViewModel {
        let session: Session = try! JFContainer.shared.container.resolve()
        let getMyAccountQuery = GetMyAccountQueryHandler(userRepository: JFContainer.shared.userRepository, session: session)
        let profilePictureWorker: ProfilePictureWorkerProtocol = try! JFContainer.shared.container.resolve()
        let signOutCommand = SignOutCommand(session: session)
        return MyAccountViewModel(
            getMyAccountQuery: getMyAccountQuery,
            profilePictureWorker: profilePictureWorker,
            signOutCommand: signOutCommand
        )
    }
}

struct TabbedRootView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedRootView()
    }
}

struct AddWineUIKitView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let storyboard = UIStoryboard(name: "AddWine", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! UINavigationController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
}

struct EditWineUIKitView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> EditWineViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "EditWineViewController") as! EditWineViewController
        return vc
    }
    
    func updateUIViewController(_ uiViewController: EditWineViewController, context: Context) {
        
    }
}

