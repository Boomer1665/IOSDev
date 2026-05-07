//
//  OnboardingView.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var store: HabitStore

    @State private var step = 0
    @State private var habitName = ""
    @State private var habitFreq: HabitFrequency = .daily
    @State private var tempHabits: [Habit] = []

    @State private var waterGoalL: Double = 2.5

    @State private var startHour = 8
    @State private var endHour = 22

    var body: some View {
        ZStack {
            NXColor.bg.ignoresSafeArea()

            VStack(spacing: 0) {

                HStack(spacing: 8) {
                    ForEach(0..<3) { i in
                        Capsule()
                            .fill(
                                i == step
                                ? Color.white
                                : Color.white.opacity(0.2)
                            )
                            .frame(width: i == step ? 24 : 8, height: 8)
                            .animation(.spring(response: 0.35), value: step)
                    }
                }
                .padding(.top, 64)

                Spacer()

                Group {
                    switch step {
                    case 0:
                        habitStep

                    case 1:
                        waterStep

                    default:
                        notifStep
                    }
                }
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .trailing)
                            .combined(with: .opacity),

                        removal: .move(edge: .leading)
                            .combined(with: .opacity)
                    )
                )
                .animation(
                    .spring(response: 0.4, dampingFraction: 0.85),
                    value: step
                )

                Spacer()

                Button(action: advance) {
                    Text(step == 2 ? "Let's Go 🚀" : "Continue")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.white)
                        .cornerRadius(18)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 52)
            }
        }
    }

    private var habitStep: some View {
        VStack(alignment: .leading, spacing: 24) {

            VStack(alignment: .leading, spacing: 6) {
                Text("Build Your Stack")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Text("Add the habits you want to own.")
                    .font(.system(size: 17))
                    .foregroundColor(NXColor.subtle)
            }
            .padding(.horizontal, 28)

            VStack(spacing: 10) {

                HStack(spacing: 10) {
                    Image(systemName: "plus.circle")
                        .foregroundColor(NXColor.subtle)

                    TextField(
                        "e.g. Gym, Read, Meditate…",
                        text: $habitName
                    )
                    .foregroundColor(.white)
                }
                .padding(16)
                .background(NXColor.surface)
                .cornerRadius(14)

                FrequencyPicker(selection: $habitFreq)

                Button(action: pushHabit) {
                    Label("Add to Stack", systemImage: "plus")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(NXColor.surface2)
                        .cornerRadius(14)
                }
            }
            .padding(.horizontal, 28)

            if !tempHabits.isEmpty {

                VStack(spacing: 8) {

                    ForEach(tempHabits) { h in
                        HStack {

                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)

                            Text(h.name)
                                .foregroundColor(.white)

                            Spacer()

                            Text(h.frequency.rawValue)
                                .font(.caption)
                                .foregroundColor(NXColor.subtle)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(NXColor.surface)
                                .cornerRadius(6)
                        }
                        .padding(14)
                        .background(NXColor.surface)
                        .cornerRadius(14)
                    }
                }
                .padding(.horizontal, 28)
            }
        }
    }

    private var waterStep: some View {
        VStack(alignment: .leading, spacing: 24) {

            VStack(alignment: .leading, spacing: 6) {
                Text("Hydration Goal 💧")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Text("How much water per day?")
                    .font(.system(size: 17))
                    .foregroundColor(NXColor.subtle)
            }
            .padding(.horizontal, 28)

            VStack(spacing: 4) {

                Text(String(format: "%.1f L", waterGoalL))
                    .font(
                        .system(
                            size: 76,
                            weight: .bold,
                            design: .rounded
                        )
                    )
                    .foregroundColor(.white)

                Text("per day")
                    .font(.system(size: 17))
                    .foregroundColor(NXColor.subtle)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)

            Slider(
                value: $waterGoalL,
                in: 1.0...5.0,
                step: 0.25
            )
            .tint(.blue)
            .padding(.horizontal, 28)

            HStack {
                Text("1.0 L")

                Spacer()

                Text("5.0 L")
            }
            .font(.system(size: 13))
            .foregroundColor(NXColor.subtle)
            .padding(.horizontal, 36)
        }
    }

    private var notifStep: some View {
        VStack(alignment: .leading, spacing: 24) {

            VStack(alignment: .leading, spacing: 6) {
                Text("Active Hours 🔔")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)

                Text("When are you up and at it?")
                    .font(.system(size: 17))
                    .foregroundColor(NXColor.subtle)
            }
            .padding(.horizontal, 28)

            VStack(spacing: 12) {
                hourRow(
                    label: "Wake up",
                    binding: $startHour,
                    range: 4..<13
                )

                hourRow(
                    label: "Wind down",
                    binding: $endHour,
                    range: 18..<25
                )
            }
            .padding(.horizontal, 28)

            Text("Smart nudges only fire within your active window.")
                .font(.system(size: 14))
                .foregroundColor(NXColor.subtle)
                .padding(.horizontal, 28)
        }
    }

    private func hourRow(
        label: String,
        binding: Binding<Int>,
        range: Range<Int>
    ) -> some View {

        HStack {
            Text(label)
                .foregroundColor(.white)

            Spacer()

            Picker(label, selection: binding) {
                ForEach(range, id: \.self) { h in
                    Text(hourLabel(h)).tag(h)
                }
            }
            .pickerStyle(.menu)
            .tint(.blue)
        }
        .padding(16)
        .background(NXColor.surface)
        .cornerRadius(14)
    }

    private func hourLabel(_ h: Int) -> String {
        let suffix = h < 12 ? "AM" : "PM"

        let display = h > 12
            ? h - 12
            : (h == 0 ? 12 : h)

        return "\(display):00 \(suffix)"
    }

    private func pushHabit() {
        guard !habitName.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }

        tempHabits.append(
            Habit(
                name: habitName,
                frequency: habitFreq
            )
        )

        habitName = ""
    }

    private func advance() {

        if step < 2 {
            step += 1
        } else {

            for h in tempHabits {
                store.addHabit(
                    name: h.name,
                    frequency: h.frequency
                )
            }

            store.settings.waterGoalML = waterGoalL * 1000
            store.settings.activeStartHour = startHour
            store.settings.activeEndHour = endHour
            store.settings.hasCompletedOnboarding = true
            store.settings.lastResetDateKey = store.todayKey

            store.save()
            store.requestNotifications()
        }
    }
}