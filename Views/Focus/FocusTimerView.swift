//
//  FocusTimerView.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//
import SwiftUI
import UserNotifications

struct FocusTimerView: View {
    @EnvironmentObject var store: HabitStore
    @State private var expanded       = false
    @State private var running        = false
    @State private var selectedMins   = 25
    @State private var remaining      : Int = 25 * 60
    @State private var timerRef       : Timer?
    @State private var doneBanner     = false

    private let presets = [5, 15, 25, 45, 60]

    var body: some View {
        Group {
            if expanded { expandedView } else { collapsedView }
        }
        .background(NXColor.surface)
        .cornerRadius(24)
        .animation(.spring(response: 0.38, dampingFraction: 0.82), value: expanded)
    }

    // MARK: Collapsed

    private var collapsedView: some View {
        Button { expanded = true } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle().fill(Color.purple.opacity(0.18)).frame(width: 46, height: 46)
                    Image(systemName: "timer").font(.system(size: 20)).foregroundColor(.purple)
                }
                Text("Start Focus Session")
                    .font(.system(size: 17, weight: .semibold)).foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 13, weight: .medium)).foregroundColor(NXColor.subtle)
            }
            .padding(20)
        }
        .buttonStyle(.plain)
    }

    // MARK: Expanded

    private var expandedView: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Focus Session")
                    .font(.system(size: 18, weight: .bold)).foregroundColor(.white)
                Spacer()
                Button { stop(); expanded = false } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22)).foregroundColor(NXColor.subtle)
                }
            }

            // Ring timer
            ZStack {
                Circle().stroke(Color.white.opacity(0.07), lineWidth: 11)
                Circle()
                    .trim(from: 0, to: ringProgress)
                    .stroke(
                        LinearGradient(colors: [.purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 11, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: remaining)
                VStack(spacing: 4) {
                    Text(timeString)
                        .font(.system(size: 52, weight: .bold, design: .monospaced)).foregroundColor(.white)
                    Text(running ? "Stay locked in 🧘" : "Pick a duration")
                        .font(.system(size: 13)).foregroundColor(NXColor.subtle)
                }
            }
            .frame(width: 200, height: 200)

            // Presets
            if !running {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(presets, id: \.self) { m in
                            Button { selectedMins = m; remaining = m * 60 } label: {
                                Text("\(m) min")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedMins == m ? .black : .white)
                                    .padding(.horizontal, 16).padding(.vertical, 9)
                                    .background(selectedMins == m ? Color.white : NXColor.surface2)
                                    .cornerRadius(20)
                            }
                        }
                    }
                }
            }

            // Controls
            HStack(spacing: 12) {
                if running {
                    ctaButton("Pause", icon: "pause.fill", bg: NXColor.surface2, fg: .white) { pause() }
                    ctaButton("Stop",  icon: "stop.fill",  bg: Color.red.opacity(0.2), fg: .white) { stop() }
                } else {
                    ctaButton("Start", icon: "play.fill", bg: .white, fg: .black) { start() }
                }
            }

            if doneBanner {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                    Text("Focus habit auto-completed! 🎯")
                        .font(.system(size: 14, weight: .medium)).foregroundColor(.white)
                }
                .padding(12)
                .background(Color.green.opacity(0.14))
                .cornerRadius(12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .padding(20)
    }

    private func ctaButton(_ label: String, icon: String, bg: Color, fg: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Label(label, systemImage: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(fg)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(bg)
                .cornerRadius(16)
        }
    }

    private var ringProgress: Double {
        1.0 - Double(remaining) / Double(selectedMins * 60)
    }
    private var timeString: String {
        String(format: "%02d:%02d", remaining / 60, remaining % 60)
    }

    private func start() {
        running = true
        timerRef = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if remaining > 0 { remaining -= 1 } else { complete() }
        }
    }
    private func pause() {
        timerRef?.invalidate(); timerRef = nil; running = false
    }
    private func stop() {
        timerRef?.invalidate(); timerRef = nil; running = false
        remaining = selectedMins * 60
    }
    private func complete() {
        stop()
        store.autoCompleteFocusHabit()
        notify()
        withAnimation(.spring()) { doneBanner = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation { doneBanner = false }
        }
    }
    private func notify() {
        let c = UNMutableNotificationContent()
        c.title = "Session Complete! 🎯"; c.body = "Deep work habit logged."; c.sound = .default
        UNUserNotificationCenter.current().add(
            UNNotificationRequest(identifier: UUID().uuidString, content: c,
                                  trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false))
        )
    }
}
