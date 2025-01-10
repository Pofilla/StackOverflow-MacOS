import SwiftUI

struct FilteredQuestionsView: View {
    let tag: String

    var body: some View {
        VStack {
            Text("Questions tagged with \(tag)")
                .font(.largeTitle)
                .padding()
            // Add your logic to display questions related to the tag
        }
        .navigationTitle("Questions with \(tag)")
    }
}

#Preview {
    FilteredQuestionsView(tag: "ExampleTag")
} 