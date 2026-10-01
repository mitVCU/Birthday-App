//
//  BabyProfile.swift
//  HappyBirthday
//

import OSLog
import UIKit

/// The baby's details and photo, shared by every screen.
/// Loads from the store once and writes every change back to it.
@MainActor
@Observable
final class BabyProfile {
    var draft: BabyInfoDraft { didSet { store.saveDraft(draft) } }
    private(set) var image: UIImage?

    @ObservationIgnored private let store: BabyInfoStore
    @ObservationIgnored private let logger = Logger(subsystem: "HappyBirthday", category: "BabyProfile")

    private static let maxImageDimension: CGFloat = 1500

    init(store: BabyInfoStore) {
        self.store = store
        self.draft = store.loadDraft()
        self.image = store.loadImage()
    }

    func setImage(_ image: UIImage) {
        let resized = image.downscaled(toMaxDimension: Self.maxImageDimension)
        self.image = resized
        do {
            try store.saveImage(resized)
        } catch {
            logger.error("Failed to save image: \(error)")
        }
    }
}
