//
//  BirthdayPickerSheet.swift
//  HappyBirthday
//

import SwiftUI

struct BirthdayPickerSheet: View {
    let onDone: (Date) -> Void

    @State private var date: Date
    @Environment(\.dismiss) private var dismiss

    init(initialDate: Date?, onDone: @escaping (Date) -> Void) {
        _date = State(initialValue: initialDate ?? .now)
        self.onDone = onDone
    }

    var body: some View {
        NavigationStack {
            DatePicker("Birthday", selection: $date, in: ...Date.now, displayedComponents: .date)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .padding(.horizontal)
                .navigationTitle("Birthday")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") { dismiss() }
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            onDone(date)
                            dismiss()
                        }
                    }
                }
        }
    }
}
