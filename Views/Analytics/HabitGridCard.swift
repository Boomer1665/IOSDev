//
//  HabitGridCard.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//
import SwiftUI

struct HabitGridCard: View {
    @EnvironmentObject var store: HabitStore
    private let cols = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)
    private let heads = ["S","M","T","W","T","F","S"]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("28-Day History").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            HStack(spacing: 0) {
                ForEach(0..<7, id: \.self) { i in
                    Text(heads[i]).font(.system(size: 12, weight: .medium))
                        .foregroundColor(NXColor.subtle).frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: cols, spacing: 6) {
                ForEach(Array((0..<28).reversed()), id: \.self) { daysAgo in
                    dot(daysAgo: daysAgo)
                }
            }

            HStack(spacing: 16) {
                dotLegend(.green,                  "All done")
                dotLegend(Color.white.opacity(0.12), "Incomplete")
                dotLegend(.blue.opacity(0.7),      "Today")
            }
        }
        .padding(20)
        .background(NXColor.surface)
        .cornerRadius(24)
    }

    @ViewBuilder
    private func dot(daysAgo: Int) -> some View {
        let isToday   = daysAgo == 0
        let record    = store.dayRecord(daysAgo: daysAgo)
        let todayDone = isToday && store.completedCount == store.habits.count && !store.habits.isEmpty
        let allDone   = todayDone || (record?.allDone ?? false)
        let hasData   = isToday || record != nil

        ZStack {
            Circle()
                .fill(isToday ? Color.blue.opacity(0.28) :
                      allDone ? Color.green.opacity(0.75) :
                      hasData ? Color.white.opacity(0.09) : Color.white.opacity(0.04))
                .frame(width: 34, height: 34)
            if isToday {
                Circle().stroke(Color.blue, lineWidth: 2).frame(width: 34, height: 34)
            }
            if allDone {
                Image(systemName: "checkmark").font(.system(size: 10, weight: .bold)).foregroundColor(.white)
            }
        }
    }

    private func dotLegend(_ c: Color, _ label: String) -> some View {
        HStack(spacing: 5) {
            Circle().fill(c).frame(width: 9, height: 9)
            Text(label).font(.system(size: 12)).foregroundColor(NXColor.subtle)
        }
    }
}
