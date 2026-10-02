//
//  BirthdayViewModel.swift
//  HappyBirthday
//

import UIKit

@MainActor
@Observable
final class BirthdayViewModel: Hashable {
    let theme: BirthdayTheme
    let age: BabyAge
    private let name: String
    private let profile: BabyProfile

    init(details: BabyInfo, profile: BabyProfile, theme: BirthdayTheme = .random(), now: Date = .now) {
        self.theme = theme
        self.name = details.name
        self.age = BabyAge(birthday: details.birthday, now: now)
        self.profile = profile
    }

    var image: UIImage? { profile.image }
    var imageVersion: Int { profile.imageVersion }
    var photoAccessibilityLabel: String { profile.photoAccessibilityLabel }

    var title: String { "Today \(name) is" }

    var accessibilityAgeLabel: String { "\(title) \(age.value) \(age.unitDescription)" }

    var shareTitle: String { "\(title) \(age.value) \(age.unitText)" }

    func setImage(_ image: UIImage) {
        profile.setImage(image)
    }

    nonisolated static func == (lhs: BirthdayViewModel, rhs: BirthdayViewModel) -> Bool {
        lhs === rhs
    }

    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
