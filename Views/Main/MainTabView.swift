//
//  MainTabView.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 1/5/2026.
//


import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            DailyBoardView()
                .tabItem {
                    Label("Today", systemImage: "sun.max.fill")
                }

            AnalyticsView()
                .tabItem {
                    Label("Receipts", systemImage: "chart.bar.fill")
                }
        }
        .tint(.white)
    }
}
