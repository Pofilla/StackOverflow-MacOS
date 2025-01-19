import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var userSession: UserSession
    @State private var showingLoginSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
            }
            .navigationTitle("Stack Overflow")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Group {
                        if let username = userSession.username {
                            // When user is logged in, show their username
                            Text(username)
                                .foregroundColor(Theme.primaryColor)
                                .padding(.horizontal)
                        } else {
                            // When no user is logged in, show login button
                            Button(action: {
                                showingLoginSheet = true
                            }) {
                                Text("Login / Sign Up")
                                    .foregroundColor(Theme.primaryColor)
                                    .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showingLoginSheet) {
                LoginView(isPresented: $showingLoginSheet)
            }
        }
        #if os(macOS)
        .frame(minWidth: 800, minHeight: 600)
        #endif
    }
}

// Preview
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview with logged out state
            HomeView()
                .environmentObject(UserSession())
            
            // Preview with logged in state
            HomeView()
                .environmentObject({
                    let session = UserSession()
                    session.username = "John Doe"
                    return session
                }())
        }
    }
} 
