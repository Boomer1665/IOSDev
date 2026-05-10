//
//  RootView.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 29/4/2026.
//


import SwiftUI
// Decides whether to show onboarding or the main app based on the persisted flag.
struct RootView: View {
    @EnvironmentObject var store: HabitStore
    // Shows onboarding on first launch, main tabs thereafter
    var body: some View {
        Group {
            if store.settings.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
     // Re-checks if the day has rolled over whenever the app is brought to foreground
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            )
        ) { _ in
            store.checkMidnightReset()
        }
    }
}
