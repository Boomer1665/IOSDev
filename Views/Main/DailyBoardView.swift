//
//  DailyBoardView.swift
//  HabitMate
//
//  Created by Kian Hirani on 1/5/2026.
//


import SwiftUI

struct DailyBoardView: View {

    @EnvironmentObject var store: HabitStore

    @State private var showAdd = false

    var body: some View {
        ZStack {

            NXColor.bg.ignoresSafeArea()

            ScrollView(showsIndicators: false) {

                VStack(spacing: 18) {

                    boardHeader
                        .padding(.horizontal, 20)

                    WaterTankView()
                        .padding(.horizontal, 20)

                    DailyProgressBar()
                        .padding(.horizontal, 20)

                    habitSection

                    FocusTimerView()
                        .padding(.horizontal, 20)
                        .padding(.bottom, 32)
                }
                .padding(.top, 16)
            }

            if store.showWaterGoalBanner {
                WaterGoalOverlay()
                    .transition(
                        .opacity.combined(
                            with: .scale(scale: 0.9)
                        )
                    )
            }
        }
        .sheet(isPresented: $showAdd) {
            AddHabitSheet()
        }
    }

    private var boardHeader: some View {

        HStack {

            VStack(alignment: .leading, spacing: 3) {

                Text(weekdayName())
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(NXColor.subtle)

                Text("Daily Board")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
            }

            Spacer()

            Text(shortDate())
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(NXColor.subtle)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(NXColor.surface)
                .cornerRadius(10)
        }
    }

    private var habitSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            HStack {

                Text("Today's Stack")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)

                Spacer()

                Button(action: {
                    showAdd = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.55))
                }
            }
            .padding(.horizontal, 20)

            if store.habits.isEmpty {
                emptyState
            } else {

                ForEach(store.sortedHabits) { habit in
                    HabitRow(habit: habit)
                        .padding(.horizontal, 20)
                }
            }
        }
    }

    private var emptyState: some View {

        VStack(spacing: 12) {

            Image(systemName: "checklist")
                .font(.system(size: 48))
                .foregroundColor(.white.opacity(0.12))

            Text("No habits yet")
                .font(.system(size: 17))
                .foregroundColor(NXColor.subtle)

            Button(action: {
                showAdd = true
            }) {

                Text("Add your first habit")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(NXColor.surface)
                    .cornerRadius(12)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 44)
    }

}
