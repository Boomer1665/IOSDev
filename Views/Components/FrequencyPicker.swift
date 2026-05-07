//
//  FrequencyPicker.swift
//  DailyHabitTracker
//
//  Created by Kian Hirani on 7/5/2026.
//


import SwiftUI

struct FrequencyPicker: View {
    @Binding var selection: HabitFrequency

    var body: some View {
        HStack(spacing: 0) {
            ForEach(HabitFrequency.allCases, id: \.self) { f in
                Button {
                    selection = f
                } label: {
                    Text(f.rawValue)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(selection == f ? .black : .white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(selection == f ? Color.white : Color.clear)
                }
            }
        }
        .background(NXColor.surface)
        .cornerRadius(14)
    }
}