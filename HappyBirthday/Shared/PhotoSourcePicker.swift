//
//  PhotoSourcePicker.swift
//  HappyBirthday
//

import OSLog
import PhotosUI
import SwiftUI

struct PhotoSourcePicker: ViewModifier {
    @Binding var isPresented: Bool
    let onImagePicked: @MainActor @Sendable (UIImage) -> Void

    @State private var isLibraryPresented = false
    @State private var isCameraPresented = false
    @State private var libraryItem: PhotosPickerItem?
    @State private var libraryLoad: Task<Void, Never>?

    private static let logger = Logger(subsystem: "HappyBirthday", category: "PhotoSourcePicker")

    private var isCameraAvailable: Bool {
        UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    func body(content: Content) -> some View {
        content
            .confirmationDialog("Photo", isPresented: $isPresented, titleVisibility: .hidden) {
                Button("Choose from library") { isLibraryPresented = true }
                if isCameraAvailable {
                    Button("Take photo") { isCameraPresented = true }
                }
            }
            .photosPicker(isPresented: $isLibraryPresented, selection: $libraryItem, matching: .images)
            .fullScreenCover(isPresented: $isCameraPresented) {
                CameraPicker { @MainActor @Sendable image in
                    onImagePicked(image)
                }
                    .ignoresSafeArea()
            }
            .onChange(of: libraryItem) { _, item in
                guard let item else { return }
                libraryLoad?.cancel()
                libraryLoad = Task {
                    await loadImage(from: item)
                    libraryItem = nil   // so picking the same photo again still fires onChange
                }
            }
    }

    @MainActor
    private func loadImage(from item: PhotosPickerItem) async {
        do {
            guard let data = try await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                Self.logger.error("Selected library item had no readable image data")
                return
            }
            guard !Task.isCancelled else { return }
            onImagePicked(image)
        } catch {
            guard !Task.isCancelled else { return }
            Self.logger.error("Failed to load library photo: \(error)")
        }
    }
}

extension View {
    func photoSourcePicker(isPresented: Binding<Bool>,
                           onImagePicked: @escaping @MainActor @Sendable (UIImage) -> Void) -> some View {
        modifier(PhotoSourcePicker(isPresented: isPresented, onImagePicked: onImagePicked))
    }
}
