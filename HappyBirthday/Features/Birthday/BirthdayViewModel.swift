//
//  BirthdayViewModel.swift
//  HappyBirthday
//

import UIKit

@MainActor
@Observable
final class BirthdayViewModel {
    let theme: BirthdayTheme
    let age: BabyAge
    private let name: String

    @ObservationIgnored private let profile: BabyProfile

    init(details: BabyDetails, profile: BabyProfile, theme: BirthdayTheme = .random(), now: Date = .now) {
        self.theme = theme
        self.name = details.name
        self.age = BabyAge(birthday: details.birthday, now: now)
        self.profile = profile
    }

    /// Read from the shared profile, so a photo change on either screen shows up on both.
    var image: UIImage? { profile.image }

    var title: String { "Today \(name) is" }

    var accessibilityAgeLabel: String { "Today \(name) is \(age.value) \(age.unitDescription)" }
}
