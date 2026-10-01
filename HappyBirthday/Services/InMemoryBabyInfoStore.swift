//
//  InMemoryBabyInfoStore.swift
//  HappyBirthday
//

#if DEBUG
import UIKit

/// Store used by previews so they never touch UserDefaults or disk.
final class InMemoryBabyInfoStore: BabyInfoStore {
    private var draft: BabyInfoDraft
    private var image: UIImage?

    init(draft: BabyInfoDraft = BabyInfoDraft(), image: UIImage? = nil) {
        self.draft = draft
        self.image = image
    }

    func loadDraft() -> BabyInfoDraft { draft }
    func saveDraft(_ draft: BabyInfoDraft) { self.draft = draft }
    func loadImage() -> UIImage? { image }
    func saveImage(_ image: UIImage) throws { self.image = image }
}
#endif
