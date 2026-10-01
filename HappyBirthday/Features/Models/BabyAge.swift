//
//  BabyAge.swift
//  HappyBirthday
//

import Foundation

enum BabyAge: Equatable {
    case months(Int)
    case years(Int)

    /// Oldest age the birthday screen supports (there are number assets for 0–12).
    static let maxYears = 12

    init(birthday: Date, now: Date = .now, calendar: Calendar = .current) {
        // Compare calendar days, not timestamps: the picker keeps the time of day it was set.
        let components = calendar.dateComponents([.year, .month],
                                                 from: calendar.startOfDay(for: birthday),
                                                 to: calendar.startOfDay(for: now))
        let years = max(0, components.year ?? 0)
        let months = max(0, components.month ?? 0)
        self = years == 0 ? .months(months) : .years(years)
    }

    /// Birthdays that give an age from 0 months up to `maxYears` (the day before turning 13).
    static func allowedBirthdays(now: Date = .now, calendar: Calendar = .current) -> ClosedRange<Date> {
        let today = calendar.startOfDay(for: now)
        let tooOld = calendar.date(byAdding: .year, value: -(maxYears + 1), to: today) ?? today
        let earliest = calendar.date(byAdding: .day, value: 1, to: tooOld) ?? today
        return earliest...now
    }

    var value: Int {
        switch self {
        case .months(let n), .years(let n): n
        }
    }

    /// "month old", "years old", … (for VoiceOver and anywhere without the "!")
    var unitDescription: String {
        switch self {
        case .months(1): "month old"
        case .months: "months old"
        case .years(1): "year old"
        case .years: "years old"
        }
    }

    /// Lowercase on purpose: the view uppercases it, so VoiceOver reads normal words.
    var unitText: String { unitDescription + "!" }

    var numberImageName: String { "number_\(value)" }
}
