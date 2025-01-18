import SwiftUI

struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        Text(message)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color.green.opacity(0.9))
            .cornerRadius(10)
            .shadow(radius: 5)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation {
                        isShowing = false
                    }
                }
            }
    }
}

#Preview {
    ToastView(message: "Success!", isShowing: .constant(true))
}
