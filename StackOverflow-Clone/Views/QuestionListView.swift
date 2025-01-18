import SwiftUI

struct QuestionListView: View {
    @EnvironmentObject private var viewModel: QuestionListViewModel
    @Binding var showNewQuestion: Bool
    @State private var searchText = ""
    @State private var isPressed: Bool = false // State to track button press
    @State private var showDeleteConfirmation = false // State to track delete confirmation alert
    @State private var isHovering = false // State to track button hover

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
                            EmptyStateView() // Call without parameters
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
                        HStack {
                            Image(systemName: "plus") // Add the plus icon
                                .font(.title) // Increase icon size
                                .foregroundColor(.white) // Ensure good contrast
                            Text("Ask a Question")
                                .font(.title) // Increase font size for the button
                                .foregroundColor(.white) // Ensure good contrast
                        }
                        .padding(16) // Increase padding for a larger button
                        .background(isPressed ? Color.blue : Theme.primaryColor) // Change background color on press
                        .clipShape(Capsule()) // Make the button capsule-shaped
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
        .navigationTitle("Questions") // Set the navigation title to "Questions"
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
    let question: Question
    
    // Add these state variables
    @State private var showDeleteConfirmation = false
    @State private var isHovering = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Voting controls
            VStack(spacing: 8) {
                Button(action: { vote(.upvote) }) {
                    Image(systemName: "arrow.up")
  
                }
                
                Text("\(question.totalVotes)")
                    .font(.headline)
                    .foregroundColor(Theme.textColor)
                
                Button(action: { vote(.downvote) }) {
                    Image(systemName: "arrow.down")

                }
            }

            
            // Question content
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(question.title)
                            .font(.title2.bold())
                            .foregroundColor(Theme.textColor)
                        
                        // Add author text
                        Text("by \(question.authorId)")
                            .font(.caption)
                            .foregroundColor(Theme.secondaryColor)
                    }
                    
                    Spacer()
                    
                    // Add delete menu for question author
                    if question.authorId == "anonymous" {
                        Button(action: {
                            showDeleteConfirmation = true
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(isHovering ? Theme.primaryColor : Theme.secondaryColor)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .onHover { hovering in
                            isHovering = hovering
                        }
                        .alert(isPresented: $showDeleteConfirmation) {
                            Alert(
                                title: Text("Confirm Deletion"),
                                message: Text("Are you sure you want to delete this question?"),
                                primaryButton: .destructive(Text("Delete")) {
                                    deleteQuestion()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                    }
                }
                
                Text(question.body)
                    .foregroundColor(Theme.textColor)
                
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(question.tags, id: \.self) { tag in
                            Text(tag)
                                .tagStyle()
                        }
                    }
                }
                
                HStack {
                    // Answer count badge
                    BadgeView(
                        count: question.answers.count,
                        color: Theme.darkOrange,
                        icon: "text.bubble"
                    )
                    
                    Spacer()
                    
                    Text("asked \(timeAgo(question.createdDate))")
                        .font(.caption)
                        .foregroundColor(Theme.secondaryColor)
                }
            }
        }
        .padding()
        .background(Theme.cardBackground)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: Theme.primaryColor.opacity(0.1), radius: 2)
    }
    
    
    private func vote(_ type: VoteType) {
        viewModel.vote(on: question.id, voteType: type)
    }
    
    private func deleteQuestion() {
        viewModel.deleteQuestion(question.id, authorId: question.authorId)
    }
    
    private func timeAgo(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// Preview
#Preview {
    QuestionListView(showNewQuestion: .constant(false))
        .environmentObject(QuestionListViewModel())
}