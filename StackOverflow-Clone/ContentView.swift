//
//  ContentView.swift
//  StackOverflow-Clone
//
//  Created by Reza Ahmadizadeh on 10/12/1403 AP.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var questionListViewModel = QuestionListViewModel()
    @StateObject private var userSession = UserSession()
    @State private var showNewQuestion = false

    var body: some View {
        QuestionListView(showNewQuestion: $showNewQuestion)
            .environmentObject(questionListViewModel)
            .environmentObject(userSession)
    }
}

#Preview {
    ContentView()
}