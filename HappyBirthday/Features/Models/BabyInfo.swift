//
//  BabyInfo.swift
//  HappyBirthday
//
//  Created by Mit Amin on 9/30/26.
//

import Foundation

struct BabyInfoDraft: Codable, Equatable {
    var name: String = ""
    var birthday: Date?
}

struct BabyDetails: Equatable {
    let name: String
    let birthday: Date

    init?(name: String, birthday: Date, now: Date = .now) {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, birthday <= now else { return nil }
        self.name = trimmed
        self.birthday = birthday
    }
}

extension BabyDetails {
    init?(draft: BabyInfoDraft, now: Date = .now) {
        guard let birthday = draft.birthday else { return nil }
        self.init(name: draft.name, birthday: birthday, now: now)
    }
}
