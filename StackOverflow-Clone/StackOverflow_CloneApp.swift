//
//  StackOverflow_CloneApp.swift
//  StackOverflow-Clone
//
//  Created by Reza Ahmadizadeh on 10/12/1403 AP.
//

import SwiftUI

@main
struct StackOverflow_CloneApp: App {
    // Initialize view models that need to be shared across the app
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var questionListViewModel = QuestionListViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(authViewModel)
                .environmentObject(questionListViewModel)
        }
    }
}
