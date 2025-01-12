//
//  StackOverflow_CloneApp.swift
//  StackOverflow-Clone
//
//  Created by Reza Ahmadizadeh on 10/12/1403 AP.
//

import SwiftUI

@main
struct StackOverflow_CloneApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false // Store the user's preference
    @StateObject private var questionListViewModel = QuestionListViewModel()
    @StateObject private var userSession = UserSession() // Initialize UserSession
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(questionListViewModel)
                .environmentObject(userSession) // Provide UserSession to the environment
                .preferredColorScheme(isDarkMode ? .dark : .light) // Apply the selected color scheme
        }
    }
}
