//
//  BabyInfoInputViewModel.swift
//  HappyBirthday
//

import UIKit

@MainActor
@Observable
final class BabyInfoInputViewModel {
    let profile: BabyProfile

    init(profile: BabyProfile) {
        self.profile = profile
    }

    var name: String {
        get { profile.draft.name }
        set { profile.draft.name = newValue }
    }

    var birthday: Date? {
        get { profile.draft.birthday }
        set { profile.draft.birthday = newValue }
    }

    var image: UIImage? { profile.image }
    var photoAccessibilityLabel: String { profile.photoAccessibilityLabel }

    var details: BabyInfo? { BabyInfo(draft: profile.draft) }
    var canShowBirthday: Bool { details != nil }

    func makeBirthdayViewModel() -> BirthdayViewModel? {
        details.map { BirthdayViewModel(details: $0, profile: profile) }
    }

    func loadSavedImage() async {
        await profile.loadSavedImage()
    }

    func setImage(_ image: UIImage) {
        profile.setImage(image)
    }
}
