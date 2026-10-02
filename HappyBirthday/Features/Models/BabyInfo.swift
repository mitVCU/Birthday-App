//
//  BabyInfo.swift
//  HappyBirthday
//

import Foundation

struct BabyInfoDraft: Codable {
    var name: String = ""
    var birthday: Date?
}

struct BabyInfo {
    let name: String
    let birthday: Date

    init?(name: String, birthday: Date, now: Date = .now, calendar: Calendar = .current) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              BabyAge.allowedBirthdays(now: now, calendar: calendar).contains(birthday)
        else { return nil }

        self.name = trimmed
        self.birthday = birthday
    }
}

extension BabyInfo {
    init?(draft: BabyInfoDraft) {
        guard let birthday = draft.birthday else { return nil }
        self.init(name: draft.name, birthday: birthday)
    }
}
