//
//  RootView.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var store: HabitStore

    var body: some View {
        Group {
            if store.settings.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIApplication.willEnterForegroundNotification
            )
        ) { _ in
            store.checkMidnightReset()
        }
    }
}