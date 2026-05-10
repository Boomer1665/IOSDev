//
//  WaterGoalOverlay.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 1/5/2026.
//
import SwiftUI

struct WaterGoalOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.55).ignoresSafeArea()
            VStack(spacing: 14) {
                Text("💧").font(.system(size: 80))
                Text("Goal Reached!").font(.system(size: 30, weight: .bold)).foregroundColor(.white)
                Text("You hit your daily water target.").font(.system(size: 16)).foregroundColor(NXColor.subtle)
            }
            .padding(40)
            .background(NXColor.surface)
            .cornerRadius(28)
            .shadow(radius: 40)
        }
    }
}
