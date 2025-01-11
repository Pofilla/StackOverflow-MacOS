import SwiftUI

struct QuestionListView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Binding var showNewQuestion: Bool
    @State private var searchText = ""
    @State private var isPressed: Bool = false // Change to @State

    var filteredQuestions: [Question] {
        let filtered = searchText.isEmpty ? viewModel.questions :
            viewModel.questions.filter { question in
                question.title.localizedCaseInsensitiveContains(searchText) ||
                question.body.localizedCaseInsensitiveContains(searchText) ||
                question.tags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        
        return filtered
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Search section
                HStack {
                    // Search bar with magnifying glass icon
                    HStack {
                        TextField("Search questions...", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .foregroundColor(Theme.textColor)
                            .padding(.leading, 30) // Add padding to make space for the icon inside the box
                            .padding(12) // Overall padding for the field
                            .background(Theme.cardBackground)
                            .cornerRadius(8)
                            .shadow(color: Theme.primaryColor.opacity(0.1), radius: 2, x: 0, y: 2)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(Theme.secondaryColor)
                                        .padding(.leading, 8)
                                    Spacer()
                                }
                            )
                    }
                    .frame(maxWidth: .infinity) // Set the width to be dynamic
                    
                    Spacer() // Push the sorting menu to the right
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                
                // Questions list
                ScrollView {
                    LazyVStack(spacing: 12) {
                        if filteredQuestions.isEmpty {
                            EmptyStateView()
                        } else {
                            ForEach(filteredQuestions) { question in
                                NavigationLink(destination: QuestionDetailView(question: question)) {
                                    QuestionRowView(question: question)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                    .padding()
                }
                .refreshable {
                    viewModel.loadQuestions()
                }
            }
            
            // Floating Ask a Question Button
            VStack {
                Spacer() // Push the button to the bottom
                HStack {
                    Spacer() // Push the button to the right
                    Button(action: {
                        showNewQuestion = true // Show the new question view
                    }) {
                        Text("Ask a Question")
                            .font(.caption)
                            .foregroundColor(.white) // Ensure good contrast
                            .padding(8) // Add padding for touch target
                            .background(isPressed ? Color.blue : Theme.primaryColor) // Change background color on press
                            .cornerRadius(8) // Rounded corners
                            .scaleEffect(isPressed ? 0.95 : 1.0) // Scale effect for animation
                            .animation(.easeInOut(duration: 0.2), value: isPressed) // Animation for press effect
                    }
                    .buttonStyle(PlainButtonStyle()) // Ensure button style is consistent
                    .onHover { isHovered in
                        isPressed = isHovered // Handle hover state changes
                    }
                    .simultaneousGesture(TapGesture().onEnded {
                        isPressed = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isPressed = false // Reset pressed state after a short delay
                        }
                    })
                }
                .padding() // Add padding to position the button
            }
        }
        .navigationTitle("Questions") // Set the navigation title for Questions
    }
}

// Helper Views
struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.bubble")
                .font(.system(size: 48))
                .foregroundColor(Theme.secondaryColor)
            
            Text("No questions yet")
                .font(.headline)
            
            Text("Be the first to ask a question!")
                .font(.subheadline)
                .foregroundColor(Theme.secondaryColor)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct QuestionRowView: View {
    @EnvironmentObject var viewModel: QuestionListViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    let question: Question
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Voting controls
            VStack(spacing: 8) {
                // Add your voting controls here
            }
            VStack(alignment: .leading) {
                Text(question.title) // Display the question title
                    .font(.headline)
                Text(question.body) // Display the question body instead
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Theme.cardBackground)
        .cornerRadius(8)
        .shadow(color: Theme.primaryColor.opacity(0.1), radius: 2) // Add shadow for depth
    }
}

// Preview
#Preview {
    QuestionListView(showNewQuestion: .constant(false))
        .environmentObject(QuestionListViewModel())
        .environmentObject(AuthViewModel())
}
