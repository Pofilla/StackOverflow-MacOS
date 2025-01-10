import SwiftUI

struct Sidebar: View {
    @State private var selection: String? = "home"
    @State private var showNewQuestion = false
    @EnvironmentObject private var viewModel: QuestionListViewModel

    var body: some View {
        List(selection: $selection) {
            Section("PUBLIC") {
                NavigationLink(value: "home") {
                    Label("Home", systemImage: "house.fill")
                }
                
                NavigationLink(value: "questions") {
                    Label("Questions", systemImage: "text.bubble")
                }
                
                NavigationLink(value: "tags") {
                    Label("Tags", systemImage: "tag")
                }
            }
            
            Section("SETTINGS") {
                NavigationLink(value: "settings") {
                    Label("Settings", systemImage: "gear")
                }
            }
        }
        .listStyle(.sidebar)
        .tint(Theme.primaryColor)
        
        .navigationDestination(for: String.self) { destination in
            VStack(spacing: 0) {
                switch destination {
                case "home":
                    HomeView()
                case "questions":
                    QuestionListView(showNewQuestion: $showNewQuestion)
                case "tags":
                    TagsView()
                case "settings":
                    SettingsView()
                default:
                    Text("View not found")
                }
            }
        }
        .sheet(isPresented: $showNewQuestion) {
            NewQuestionView(questionsViewModel: viewModel)
        }
    }
}

#Preview {
    Sidebar()
        .environmentObject(QuestionListViewModel())
} 
