//
//  BabyProfile.swift
//  HappyBirthday
//

import OSLog
import UIKit

@MainActor
@Observable
final class BabyProfile {
    var draft: BabyInfoDraft { didSet { store.saveDraft(draft) } }

    private(set) var image: UIImage? { didSet { imageVersion += 1 } }

    private(set) var imageVersion = 0

    @ObservationIgnored private let store: any BabyInfoStore
    @ObservationIgnored private var latestImageRequest = 0
    @ObservationIgnored private var pendingImageSave: Task<Void, Never>?

    private nonisolated static let maxImageDimension: CGFloat = 1500
    private nonisolated static let logger = Logger(subsystem: "HappyBirthday", category: "BabyProfile")

    init(store: any BabyInfoStore) {
        self.store = store
        self.draft = store.loadDraft()
    }

    var photoAccessibilityLabel: String {
        image == nil ? "Add baby photo" : "Change baby photo"
    }

    func loadSavedImage() async {
        let request = latestImageRequest
        let store = store
        let saved = await Task.detached(priority: .userInitiated) { () -> UIImage? in
            guard let loaded = store.loadImage() else { return nil }
            return await loaded.byPreparingForDisplay() ?? loaded
        }.value

        guard let saved, request == latestImageRequest else { return }
        image = saved
    }

    func setImage(_ newImage: UIImage) {
        latestImageRequest += 1
        let request = latestImageRequest

        Task {
            let resized = await Task.detached(priority: .userInitiated) {
                newImage.downscaled(toMaxDimension: Self.maxImageDimension)
            }.value

            guard request == latestImageRequest else { return }
            image = resized
            save(resized)
        }
    }

    private func save(_ image: UIImage) {
        let previousSave = pendingImageSave
        let store = store
        pendingImageSave = Task.detached(priority: .utility) {
            await previousSave?.value
            do {
                try store.saveImage(image)
            } catch {
                Self.logger.error("Failed to save image: \(error)")
            }
        }
    }
}
