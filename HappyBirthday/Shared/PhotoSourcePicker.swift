//
//  PhotoSourcePicker.swift
//  HappyBirthday
//

import PhotosUI
import SwiftUI

struct PhotoSourcePicker: ViewModifier {
    @Binding var isPresented: Bool
    let onImagePicked: @MainActor @Sendable (UIImage) -> Void

    @State private var isLibraryPresented = false
    @State private var isCameraPresented = false
    @State private var libraryItem: PhotosPickerItem?

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
                Task {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        onImagePicked(image)
                    }
                    libraryItem = nil   // so picking the same photo again still fires onChange
                }
            }
    }
}

extension View {
    func photoSourcePicker(isPresented: Binding<Bool>,
                           onImagePicked: @escaping @MainActor @Sendable (UIImage) -> Void) -> some View {
        modifier(PhotoSourcePicker(isPresented: isPresented, onImagePicked: onImagePicked))
    }
}
