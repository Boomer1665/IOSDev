//
//  AddHabitSheet.swift
//  HabitMate
//
//  Created by Kian Hirani on 2/5/2026.
//
import SwiftUI

struct AddHabitSheet: View {
    @EnvironmentObject var store: HabitStore
    @Environment(\.dismiss) var dismiss
    @State private var name      = ""
    @State private var frequency : HabitFrequency = .daily

    var body: some View {
        NavigationStack {
            ZStack {
                NXColor.sheetBg.ignoresSafeArea()
                VStack(spacing: 22) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Habit Name").font(.system(size: 13, weight: .medium)).foregroundColor(NXColor.subtle)
                        TextField("e.g. Morning Run, Read 20 pages…", text: $name)
                            .foregroundColor(.white)
                            .padding(16)
                            .background(NXColor.surface)
                            .cornerRadius(14)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Frequency").font(.system(size: 13, weight: .medium)).foregroundColor(NXColor.subtle)
                        FrequencyPicker(selection: $frequency)
                    }
                    Spacer()
                    Button {
                        store.addHabit(name: name, frequency: frequency)
                        dismiss()
                    } label: {
                        Text("Add Habit")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(name.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(name.trimmingCharacters(in: .whitespaces).isEmpty ? NXColor.surface : .white)
                            .cornerRadius(18)
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                .padding(24)
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }.foregroundColor(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
