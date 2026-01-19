import SwiftUI
import Combine
import MoWine_Application

struct TabbedRootView: View {
    var body: some View {
        TabView {
            Tab("My Cellar", image: "My Wines Tab") {
                MyCellarView()
            }

            Tab("Friends", image: "Friends Tab") {
                FriendsPage()
            }

            Tab("My Account", image: "My Account Tab") {
                MyAccountPage()
            }
        }
        .accentColor(Color(.mwPrimary))
    }
}

struct TabbedRootView_Previews: PreviewProvider {
    static var previews: some View {
        TabbedRootView()
            .addPreviewEnvironment()
    }
}
