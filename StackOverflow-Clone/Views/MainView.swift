import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationSplitView {
            Sidebar()
                .background(Theme.backgroundColor)
        } detail: {
            Text("Select an item")
                .background(Theme.backgroundColor)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(AuthViewModel())
        .environmentObject(QuestionListViewModel())
} 