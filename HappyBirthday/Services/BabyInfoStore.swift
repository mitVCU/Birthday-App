//
//  BabyInfoStore.swift
//  HappyBirthday
//

import OSLog
import UIKit

protocol BabyInfoStore: Sendable {
    func loadDraft() -> BabyInfoDraft
    func saveDraft(_ draft: BabyInfoDraft)
    func loadImage() -> UIImage?
    func saveImage(_ image: UIImage) throws
}

enum BabyInfoStoreError: Error {
    case imageEncodingFailed
}

final class DefaultBabyInfoStore: BabyInfoStore {
    private static let draftKey = "babyInfoDraft"
    private static let imageFileName = "baby-photo.jpg"
    private static let jpegQuality: CGFloat = 0.8

    private let defaults: UserDefaults
    private let imageURL: URL
    private let logger = Logger(subsystem: "HappyBirthday", category: "BabyInfoStore")

    init(defaults: UserDefaults = .standard,
         directory: URL = .applicationSupportDirectory) {
        self.defaults = defaults
        self.imageURL = directory.appending(path: Self.imageFileName)
    }

    // MARK: Draft

    func loadDraft() -> BabyInfoDraft {
        guard let data = defaults.data(forKey: Self.draftKey) else { return BabyInfoDraft() }
        do {
            return try JSONDecoder().decode(BabyInfoDraft.self, from: data)
        } catch {
            logger.error("Failed to decode draft: \(error)")
            return BabyInfoDraft()
        }
    }

    func saveDraft(_ draft: BabyInfoDraft) {
        do {
            defaults.set(try JSONEncoder().encode(draft), forKey: Self.draftKey)
        } catch {
            logger.error("Failed to encode draft: \(error)")
        }
    }

    // MARK: Image

    func loadImage() -> UIImage? {
        guard let data = try? Data(contentsOf: imageURL) else { return nil }
        return UIImage(data: data)
    }

    func saveImage(_ image: UIImage) throws {
        guard let data = image.jpegData(compressionQuality: Self.jpegQuality) else {
            throw BabyInfoStoreError.imageEncodingFailed
        }
        try FileManager.default.createDirectory(at: imageURL.deletingLastPathComponent(),
                                                withIntermediateDirectories: true)
        try data.write(to: imageURL, options: .atomic)
    }
}
