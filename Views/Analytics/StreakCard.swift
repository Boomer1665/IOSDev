//
//  StreakCard.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 1/5/2026.
//
import SwiftUI

struct StreakCard: View {
    @EnvironmentObject var store: HabitStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Streaks").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            if store.habits.isEmpty {
                Text("Add habits to see your streaks.")
                    .font(.system(size: 15)).foregroundColor(NXColor.subtle)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 20)
            } else {
                VStack(spacing: 8) {
                    ForEach(store.habits.sorted { $0.streak > $1.streak }) { h in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(h.name).font(.system(size: 16, weight: .medium)).foregroundColor(.white)
                                Text(h.frequency.rawValue).font(.system(size: 12)).foregroundColor(NXColor.subtle)
                            }
                            Spacer()
                            if h.streak > 0 {
                                HStack(spacing: 4) {
                                    Text("🔥")
                                    VStack(alignment: .trailing, spacing: 0) {
                                        Text("\(h.streak)")
                                            .font(.system(size: 24, weight: .bold)).foregroundColor(.orange)
                                        Text("day streak").font(.system(size: 10)).foregroundColor(NXColor.subtle)
                                    }
                                }
                            } else {
                                VStack(alignment: .trailing, spacing: 0) {
                                    Text("0").font(.system(size: 24, weight: .bold)).foregroundColor(NXColor.subtle)
                                    Text("restarted").font(.system(size: 10)).foregroundColor(NXColor.subtle)
                                }
                            }
                        }
                        .padding(16)
                        .background(NXColor.surface2)
                        .cornerRadius(16)
                    }
                }
            }
        }
        .padding(20)
        .background(NXColor.surface)
        .cornerRadius(24)
    }
}
