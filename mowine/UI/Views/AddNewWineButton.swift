import SwiftUI

struct AddNewWineButton: View {
    @State private var showAddWine = false
    
    var body: some View {
        Button("Add Wine", systemImage: "plus") {
            showAddWine = true
        }
//        .buttonStyle(.borderedProminent)
        .tint(.mwPrimary)
        .accessibilityIdentifier("addWineButton")
        .sheet(isPresented: $showAddWine) {
            AddWineView()
        }
    }
}

#Preview {
    AddNewWineButton()
}
