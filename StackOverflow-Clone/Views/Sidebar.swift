import SwiftUI

struct Sidebar: View {
    @State private var selection: String? = "home"
    
    var body: some View {
        List(selection: $selection) {
            Section("PUBLIC") {
                NavigationLink(destination: QuestionListView(), tag: "home", selection: $selection) {
                    Label("Questions", systemImage: "list.bullet")
                }
                
                NavigationLink(destination: Text("Tags"), tag: "tags", selection: $selection) {
                    Label("Tags", systemImage: "tag")
                }
                
                NavigationLink(destination: Text("Users"), tag: "users", selection: $selection) {
                    Label("Users", systemImage: "person.2")
                }
            }
            
            Section("COLLECTIVES") {
                NavigationLink(destination: Text("Explore Collectives"), tag: "collectives", selection: $selection) {
                    Label("Explore Collectives", systemImage: "square.grid.2x2")
                }
            }
            
            Section("TEAMS") {
                NavigationLink(destination: Text("Create Team"), tag: "teams", selection: $selection) {
                    Label("Create free Team", systemImage: "plus")
                }
            }
        }
        .listStyle(.sidebar)
        .tint(Theme.primaryColor)
    }
} 