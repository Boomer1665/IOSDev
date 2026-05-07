//
//  DayRecord.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import Foundation

struct DayRecord: Identifiable, Codable {
    var id = UUID()
    var dateKey: String
    var completedCount: Int
    var totalCount: Int
    var waterML: Double

    var allDone: Bool {
        totalCount > 0 && completedCount >= totalCount
    }
}