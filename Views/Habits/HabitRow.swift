//
//  HabitRow.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//
import SwiftUI

struct HabitRow: View {
    @EnvironmentObject var store: HabitStore
    let habit: Habit
    @State private var bouncing = false

    var body: some View {
        HStack(spacing: 14) {
            Button {
                bouncing = true
                store.toggleHabit(habit.id)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) { bouncing = false }
            } label: {
                ZStack {
                    Circle()
                        .fill(habit.isCompleted ? Color.green : NXColor.surface2)
                        .frame(width: 34, height: 34)
                    if habit.isCompleted {
                        Image(systemName: "checkmark").font(.system(size: 14, weight: .bold)).foregroundColor(.white)
                    } else {
                        Circle().stroke(Color.white.opacity(0.22), lineWidth: 1.5).frame(width: 30, height: 30)
                    }
                }
                .scaleEffect(bouncing ? 1.25 : 1.0)
                .animation(.spring(response: 0.22, dampingFraction: 0.45), value: bouncing)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 3) {
                Text(habit.name)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(habit.isCompleted ? NXColor.subtle : .white)
                    .strikethrough(habit.isCompleted, color: NXColor.subtle)

                HStack(spacing: 10) {
                    Label(habit.frequency.rawValue, systemImage: "repeat")
                        .font(.system(size: 12)).foregroundColor(NXColor.subtle)
                    if habit.streak > 0 {
                        Label("\(habit.streak) day streak", systemImage: "flame.fill")
                            .font(.system(size: 12)).foregroundColor(.orange)
                    }
                }
            }

            Spacer()

            if habit.streak >= 7 {
                Text("🔥 \(habit.streak)")
                    .font(.system(size: 13, weight: .semibold)).foregroundColor(.orange)
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(Color.orange.opacity(0.14)).cornerRadius(10)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(habit.isCompleted ? NXColor.surface.opacity(0.6) : NXColor.surface)
        )
        .opacity(habit.isCompleted ? 0.72 : 1.0)
        .animation(.easeInOut(duration: 0.22), value: habit.isCompleted)
    }
}
