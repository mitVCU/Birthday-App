//
//  BabyInfoInputViewModel.swift
//  HappyBirthday
//

import OSLog
import UIKit

@MainActor
@Observable
final class BabyInfoInputViewModel {
    var draft: BabyInfoDraft { didSet { store.saveDraft(draft) } }
    private(set) var image: UIImage?

    var details: BabyDetails? { BabyDetails(draft: draft) }
    var canShowBirthday: Bool { details != nil }

    @ObservationIgnored private let store: BabyInfoStore
    @ObservationIgnored private let logger = Logger(subsystem: "HappyBirthday", category: "BabyInfoInput")

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
