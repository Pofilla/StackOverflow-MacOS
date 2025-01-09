import SwiftUI

struct MainView: View {
    @State private var isLoggedIn: Bool = UserDefaults.standard.bool(forKey: "isLoggedIn") // Check login state from UserDefaults

    var body: some View {
        NavigationSplitView {
            Sidebar()
        } detail: {
            HomeView() // Set HomeView as the initial detail view
        }
        .toolbar {
            // You can add other toolbar items if needed
        }
        .background(Color.clear) // Set the background to clear
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
        .environmentObject(QuestionListViewModel())
} 