//
//  InMemoryBabyInfoStore.swift
//  HappyBirthday
//

#if DEBUG
import os
import UIKit

/// Store used by previews so they never touch UserDefaults or disk.
final class InMemoryBabyInfoStore: BabyInfoStore {
    private struct Contents {
        var draft: BabyInfoDraft
        var image: UIImage?
    }

    // The photo is saved from a background task, so access goes through a lock.
    private let contents: OSAllocatedUnfairLock<Contents>

    init(draft: BabyInfoDraft = BabyInfoDraft(), image: UIImage? = nil) {
        contents = OSAllocatedUnfairLock(initialState: Contents(draft: draft, image: image))
    }

    func loadDraft() -> BabyInfoDraft { contents.withLock { $0.draft } }
    func saveDraft(_ draft: BabyInfoDraft) { contents.withLock { $0.draft = draft } }
    func loadImage() -> UIImage? { contents.withLock { $0.image } }
    func saveImage(_ image: UIImage) throws { contents.withLock { $0.image = image } }
}
#endif
