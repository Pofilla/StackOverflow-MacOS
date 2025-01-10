import SwiftUI

struct CustomToolbar: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                authViewModel.showAuthSheet = true
            }) {
                Text("Login")
                    .font(.system(size: 16, weight: .bold))
                    .padding()
                    .background(Theme.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .frame(minWidth: 44, minHeight: 44)

            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    CustomToolbar()
        .environmentObject(AuthViewModel())
} 
