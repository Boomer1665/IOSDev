//
//  HabitStore.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//

import SwiftUI
import Combine
import UserNotifications

final class HabitStore: ObservableObject {
    @Published var habits            : [Habit]      = []
    @Published var currentWaterML    : Double       = 0
    @Published var settings          = AppSettings()
    @Published var dayRecords        : [DayRecord]  = []
    @Published var showWaterGoalBanner = false

    // persistence keys
    private enum K {
        static let habits   = "nx_habits_v2"
        static let water    = "nx_water_v2"
        static let settings = "nx_settings_v2"
        static let records  = "nx_records_v2"
    }

    static let dateFmt: DateFormatter = {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"; return f
    }()

    var todayKey: String { Self.dateFmt.string(from: Date()) }

    // MARK: Computed

    var waterProgress: Double {
        guard settings.waterGoalML > 0 else { return 0 }
        return min(currentWaterML / settings.waterGoalML, 1.0)
    }

    var waterColor: Color {
        switch waterProgress {
        case 0.9... : return Color(red: 0.25, green: 0.65, blue: 1.0)
        case 0.5... : return Color(red: 1.0,  green: 0.85, blue: 0.1)
        default     : return Color(red: 1.0,  green: 0.3,  blue: 0.3)
        }
    }

    var sortedHabits: [Habit] {
        habits.sorted {
            if $0.isCompleted != $1.isCompleted { return !$0.isCompleted }
            return $0.name < $1.name
        }
    }

    var completedCount : Int    { habits.filter { $0.isCompleted }.count }
    var dailyProgress  : Double { habits.isEmpty ? 0 : Double(completedCount) / Double(habits.count) }

    // MARK: Init

    init() { load(); checkMidnightReset() }

    // MARK: Actions

    func toggleHabit(_ id: UUID) {
        guard let i = habits.firstIndex(where: { $0.id == id }) else { return }
        habits[i].isCompleted.toggle()
        habits[i].history[todayKey] = habits[i].isCompleted
        if habits[i].isCompleted { habits[i].streak = calcStreak(habits[i]) }
        save()
    }

    func incrementWater(ml: Double) {
        let wasBelow = currentWaterML < settings.waterGoalML
        currentWaterML = min(currentWaterML + ml, settings.waterGoalML * 1.5)
        if wasBelow && currentWaterML >= settings.waterGoalML {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.65)) {
                showWaterGoalBanner = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
                withAnimation { self.showWaterGoalBanner = false }
            }
        }
        save()
    }

    func addHabit(name: String, frequency: HabitFrequency) {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        habits.append(Habit(name: name, frequency: frequency))
        save()
    }

    func removeHabits(ids: [UUID]) {
        habits.removeAll { ids.contains($0.id) }
        save()
    }

    /// Called by FocusTimerView when the countdown hits zero.
    func autoCompleteFocusHabit() {
        let kw = ["deep work", "focus", "study", "work"]
        if let i = habits.firstIndex(where: { h in
            kw.contains(where: { h.name.lowercased().contains($0) })
        }), !habits[i].isCompleted {
            habits[i].isCompleted = true
            habits[i].history[todayKey] = true
            habits[i].streak = calcStreak(habits[i])
            save()
        }
    }

    // MARK: Midnight Reset

    func checkMidnightReset() {
        let today = todayKey
        guard settings.lastResetDateKey != today else { return }
        // archive previous day
        if !settings.lastResetDateKey.isEmpty { archiveDay(settings.lastResetDateKey) }
        // update streaks + reset
        for i in habits.indices {
            let prevCompleted = habits[i].history[settings.lastResetDateKey] == true
            if !prevCompleted && !settings.lastResetDateKey.isEmpty { habits[i].streak = 0 }
            habits[i].isCompleted = false
        }
        if !settings.lastResetDateKey.isEmpty { currentWaterML = 0 }
        settings.lastResetDateKey = today
        save()
    }

    private func archiveDay(_ key: String) {
        guard !dayRecords.contains(where: { $0.dateKey == key }) else { return }
        let record = DayRecord(
            dateKey        : key,
            completedCount : habits.filter { $0.history[key] == true }.count,
            totalCount     : habits.count,
            waterML        : currentWaterML
        )
        dayRecords.append(record)
        if dayRecords.count > 120 { dayRecords = Array(dayRecords.suffix(120)) }
    }

    private func calcStreak(_ habit: Habit) -> Int {
        let cal = Calendar.current
        var streak = 0
        var date   = Date()
        while true {
            let key = Self.dateFmt.string(from: date)
            guard habit.history[key] == true else { break }
            streak += 1
            guard let prev = cal.date(byAdding: .day, value: -1, to: date) else { break }
            date = prev
        }
        return streak
    }

    // MARK: History helpers

    func waterML(daysAgo: Int) -> Double {
        if daysAgo == 0 { return currentWaterML }
        let key = dateKey(daysAgo: daysAgo)
        return dayRecords.first(where: { $0.dateKey == key })?.waterML ?? 0
    }

    func dayRecord(daysAgo: Int) -> DayRecord? {
        dayRecords.first(where: { $0.dateKey == dateKey(daysAgo: daysAgo) })
    }

    private func dateKey(daysAgo: Int) -> String {
        let cal = Calendar.current
        guard let d = cal.date(byAdding: .day, value: -daysAgo, to: Date()) else { return "" }
        return Self.dateFmt.string(from: d)
    }

    // MARK: Notifications

    func requestNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { ok, _ in
                if ok { self.scheduleNudges() }
            }
    }

    private func scheduleNudges() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        func add(id: String, title: String, body: String, hour: Int, minute: Int = 0) {
            let c = UNMutableNotificationContent()
            c.title = title; c.body = body; c.sound = .default
            var dc = DateComponents(); dc.hour = hour; dc.minute = minute
            center.add(UNNotificationRequest(
                identifier : id,
                content    : c,
                trigger    : UNCalendarNotificationTrigger(dateMatching: dc, repeats: true)
            ))
        }
        add(id: "water_2pm",   title: "Hydration Check 💧",   body: "You might be behind on water — time to catch up!",        hour: 14)
        add(id: "habits_8pm",  title: "Evening Check-in 🔥",   body: "Don't break the streak! Tick off today's habits.",        hour: 20)
    }

    // MARK: Persistence

    func save() {
        let e = JSONEncoder()
        if let d = try? e.encode(habits)     { UserDefaults.standard.set(d, forKey: K.habits)   }
        if let d = try? e.encode(settings)   { UserDefaults.standard.set(d, forKey: K.settings) }
        if let d = try? e.encode(dayRecords) { UserDefaults.standard.set(d, forKey: K.records)  }
        UserDefaults.standard.set(currentWaterML, forKey: K.water)
    }

    func load() {
        let d = JSONDecoder()
        if let raw = UserDefaults.standard.data(forKey: K.habits),
           let v   = try? d.decode([Habit].self,      from: raw) { habits     = v }
        if let raw = UserDefaults.standard.data(forKey: K.settings),
           let v   = try? d.decode(AppSettings.self,  from: raw) { settings   = v }
        if let raw = UserDefaults.standard.data(forKey: K.records),
           let v   = try? d.decode([DayRecord].self,  from: raw) { dayRecords = v }
        currentWaterML = UserDefaults.standard.double(forKey: K.water)
    }
}

