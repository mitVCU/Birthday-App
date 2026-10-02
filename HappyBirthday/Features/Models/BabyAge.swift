//
//  BabyAge.swift
//  HappyBirthday
//

import Foundation

enum BabyAge {
    case months(Int)
    case years(Int)

    static let maxYears = 12

    init(birthday: Date, now: Date = .now, calendar: Calendar = .current) {
        let components = calendar.dateComponents([.year, .month],
                                                 from: calendar.startOfDay(for: birthday),
                                                 to: calendar.startOfDay(for: now))
        let years = max(0, components.year ?? 0)
        let months = max(0, components.month ?? 0)
        self = years == 0 ? .months(months) : .years(years)
    }

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

    var unitDescription: String {
        switch self {
        case .months(1): "month old"
        case .months: "months old"
        case .years(1): "year old"
        case .years: "years old"
        }
    }

    var unitText: String { unitDescription + "!" }

    var numberImageName: String { "number_\(value)" }
}
