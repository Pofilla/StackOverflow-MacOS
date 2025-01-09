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
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var questionListViewModel = QuestionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authViewModel)
                .environmentObject(questionListViewModel)
                .preferredColorScheme(isDarkMode ? .dark : .light) // Apply the selected color scheme
        }
    }
}
