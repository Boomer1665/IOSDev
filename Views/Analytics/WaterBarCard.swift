//
//  WaterBarCard.swift
//  HabitMate
//
//  Created by Kian Hirani on 1/5/2026.
//
import SwiftUI

struct WaterBarCard: View {
    @EnvironmentObject var store: HabitStore

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("7-Day Water").font(.system(size: 18, weight: .bold)).foregroundColor(.white)

            let values  = (0..<7).map { store.waterML(daysAgo: $0) }
            let ceiling = max(store.settings.waterGoalML, values.max() ?? store.settings.waterGoalML)

            HStack(alignment: .bottom, spacing: 6) {
                ForEach(Array(values.enumerated().reversed()), id: \.offset) { idx, val in
                    VStack(spacing: 6) {
                        ZStack(alignment: .bottom) {
                            RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.05)).frame(height: 100)
                            let h = ceiling > 0 ? CGFloat(val / ceiling) * 100 : 0
                            RoundedRectangle(cornerRadius: 8)
                                .fill(barColor(val))
                                .frame(height: max(3, h))
                        }
                        Text(dayLabel(daysAgo: idx))
                            .font(.system(size: 10)).foregroundColor(NXColor.subtle)
                    }
                    .frame(maxWidth: .infinity)
                }
            }

            HStack(spacing: 6) {
                Rectangle().fill(Color.white.opacity(0.25)).frame(width: 18, height: 1)
                Text("Goal: \(String(format: "%.1f L", store.settings.waterGoalML / 1000))")
                    .font(.system(size: 12)).foregroundColor(NXColor.subtle)
            }
        }
        .padding(20)
        .background(NXColor.surface)
        .cornerRadius(24)
    }

    private func barColor(_ v: Double) -> Color {
        let r = v / store.settings.waterGoalML
        if r >= 1.0 { return Color(red: 0.25, green: 0.65, blue: 1.0) }
        if r >= 0.5 { return Color.yellow.opacity(0.7) }
        return Color.red.opacity(0.55)
    }

    private func dayLabel(daysAgo: Int) -> String {
        if daysAgo == 0 { return "Today" }
        let cal = Calendar.current
        guard let d = cal.date(byAdding: .day, value: -daysAgo, to: Date()) else { return "" }
        let f = DateFormatter(); f.dateFormat = "EEE"; return f.string(from: d)
    }
}
