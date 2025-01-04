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
            VStack(spacing: 0) {
                // Only show header for questions-related views
                if destination == "home" || destination == "questions" {
                    // Header section with Ask Question button
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("All Questions")
                                .font(.title2.bold())
                            Text("\(viewModel.questions.count) questions")
                                .font(.subheadline)
                                .foregroundColor(Theme.secondaryColor)
                        }
                        
                        Spacer()
                        
                        Button(action: { showNewQuestion = true }) {
                            Label("Ask Question", systemImage: "plus.circle.fill")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .buttonStyle(Theme.primaryButtonStyle())
                    }
                    .padding()
                    .background(Theme.cardBackground)
                }
                
                // Content based on destination
                switch destination {
                case "home", "questions":
                    QuestionListView(showNewQuestion: $showNewQuestion)
                case "tags":
                    TagsView()
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
            .background(Theme.backgroundColor)
        }
        .sheet(isPresented: $showNewQuestion) {
            NewQuestionView(questionsViewModel: viewModel)
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
