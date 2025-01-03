import SwiftUI

struct Sidebar: View {
    @State private var selection: String? = "home"
    
    var body: some View {
        List(selection: $selection) {
            Section("PUBLIC") {
                NavigationLink(value: "home") {
                    Label("Questions", systemImage: "list.bullet")
                }
                
                NavigationLink(value: "tags") {
                    Label("Tags", systemImage: "tag")
                }
                
                NavigationLink(value: "users") {
                    Label("Users", systemImage: "person.2")
                }
            }
            
            Section("COLLECTIVES") {
                NavigationLink(value: "collectives") {
                    Label("Explore Collectives", systemImage: "square.grid.2x2")
                }
            }
            
            Section("TEAMS") {
                NavigationLink(value: "teams") {
                    Label("Create free Team", systemImage: "plus")
                }
            }
        }
        .listStyle(.sidebar)
        .tint(Theme.primaryColor)
        .navigationDestination(for: String.self) { destination in
            switch destination {
            case "home":
                QuestionListView()
            case "tags":
                Text("Tags View")
            case "users":
                Text("Users View")
            case "collectives":
                Text("Explore Collectives View")
            case "teams":
                Text("Create Team View")
            default:
                Text("View not found")
            }
        }
    }
}

#Preview {
    NavigationSplitView {
        Sidebar()
            .background(Theme.backgroundColor)
    } detail: {
        Text("Select an item")
            .background(Theme.backgroundColor)
    }
    .environmentObject(AuthViewModel())
    .environmentObject(QuestionListViewModel())
} 