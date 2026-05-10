//
//  DailyHabitTrackerApp.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 29/4/2026.
//


import SwiftUI
// App entry point which creates a single HabitStore and injects it into the environment,
@main
struct DailyHabitTrackerApp: App {
    @StateObject private var store = HabitStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.dark) // Forces dark mode regardless of system setting
        }
    }
}
