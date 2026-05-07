//
//  AnalyticsView.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//
import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var store: HabitStore

    var body: some View {
        ZStack {
            NXColor.bg.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("The Receipts")
                                .font(.system(size: 28, weight: .bold)).foregroundColor(.white)
                            Text("Your 28-day data").font(.system(size: 14)).foregroundColor(NXColor.subtle)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20).padding(.top, 16)

                    HabitGridCard().padding(.horizontal, 20)
                    WaterBarCard().padding(.horizontal, 20)
                    StreakCard().padding(.horizontal, 20).padding(.bottom, 32)
                }
            }
        }
    }
}
