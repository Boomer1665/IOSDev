//
//  DailyProgressBar.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 2/5/2026.
//

import SwiftUI

struct DailyProgressBar: View {
    @EnvironmentObject var store: HabitStore

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle().stroke(Color.white.opacity(0.08), lineWidth: 7)
                Circle()
                    .trim(from: 0, to: store.dailyProgress)
                    .stroke(
                        AngularGradient(colors: [.green, .teal], center: .center),
                        style: StrokeStyle(lineWidth: 7, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(), value: store.dailyProgress)
                VStack(spacing: 1) {
                    Text("\(store.completedCount)").font(.system(size: 20, weight: .bold)).foregroundColor(.white)
                    Text("/ \(store.habits.count)").font(.system(size: 11)).foregroundColor(NXColor.subtle)
                }
            }
            .frame(width: 72, height: 72)

            VStack(alignment: .leading, spacing: 8) {
                Text("Daily Progress").font(.system(size: 15, weight: .semibold)).foregroundColor(.white)
                Text(progressMsg).font(.system(size: 13)).foregroundColor(NXColor.subtle)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color.white.opacity(0.08)).frame(height: 6)
                        Capsule()
                            .fill(LinearGradient(colors: [.green, .teal], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * store.dailyProgress, height: 6)
                            .animation(.spring(), value: store.dailyProgress)
                    }
                }
                .frame(height: 6)
            }
        }
        .padding(18)
        .background(NXColor.surface)
        .cornerRadius(22)
    }

    private var progressMsg: String {
        switch store.dailyProgress {
        case 1.0       : return "All done — perfect day 🔥"
        case 0.7...    : return "Almost there, keep pushing!"
        case 0.3...    : return "Good momentum, keep going."
        default        : return store.habits.isEmpty ? "Add habits to start" : "Let's get it started 💪"
        }
    }
}
