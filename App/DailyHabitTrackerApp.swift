//
//  DailyHabitTrackerApp.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import SwiftUI

@main
struct DailyHabitTrackerApp: App {
    @StateObject private var store = HabitStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
