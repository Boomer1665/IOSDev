//
//  DateHelpers.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import Foundation
    
func weekdayName() -> String {
    let f = DateFormatter()
    f.dateFormat = "EEEE"
    return f.string(from: Date())
}

func shortDate() -> String {
    let f = DateFormatter()
    f.dateFormat = "MMM d"
    return f.string(from: Date())
}
