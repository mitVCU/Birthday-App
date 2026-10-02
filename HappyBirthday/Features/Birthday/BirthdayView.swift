//
//  BirthdayView.swift
//  HappyBirthday
//

import SwiftUI

struct BirthdayView: View {
    @State private var viewModel: BirthdayViewModel
    @State private var isPhotoSourcePresented = false
    @State private var renderedShare: RenderedShare?
    @Environment(\.dismiss) private var dismiss
    @Environment(\.displayScale) private var displayScale

    private struct ShareImageKey: Hashable {
        let width: CGFloat
        let height: CGFloat
        let topInset: CGFloat
        let imageVersion: Int
    }

    private struct RenderedShare {
        let key: ShareImageKey
        let image: UIImage
    }

    init(viewModel: BirthdayViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        GeometryReader { proxy in
            let topInset = proxy.safeAreaInsets.top
            let fullSize = CGSize(width: proxy.size.width,
                                  height: proxy.size.height + proxy.safeAreaInsets.top + proxy.safeAreaInsets.bottom)
            let key = ShareImageKey(width: fullSize.width,
                                    height: fullSize.height,
                                    topInset: topInset,
                                    imageVersion: viewModel.imageVersion)

            BirthdayCanvas(viewModel: viewModel,
                           screenWidth: fullSize.width,
                           topInset: topInset,
                           actions: actions(shareImage: shareImage(for: key)))
                .ignoresSafeArea()
                .task(id: key) {
                    renderedShare = renderShareImage(size: fullSize, topInset: topInset)
                        .map { RenderedShare(key: key, image: $0) }
                }
        }
        .toolbar(.hidden, for: .navigationBar)
        .swipeBackEnabled()
        .photoSourcePicker(isPresented: $isPhotoSourcePresented) { image in
            viewModel.setImage(image)
        }
    }

    private func actions(shareImage: UIImage?) -> BirthdayCanvas.CanvasActions {
        BirthdayCanvas.CanvasActions(
            shareImage: shareImage,
            onBack: { dismiss() },
            onChangePhoto: { isPhotoSourcePresented = true }
        )
    }

    private func shareImage(for key: ShareImageKey) -> UIImage? {
        guard let renderedShare, renderedShare.key == key else { return nil }
        return renderedShare.image
    }

    private func renderShareImage(size: CGSize, topInset: CGFloat) -> UIImage? {
        let renderer = ImageRenderer(
            content: BirthdayCanvas(viewModel: viewModel, screenWidth: size.width, topInset: topInset,
                                    actions: nil)
                .frame(width: size.width, height: size.height)
        )
        renderer.scale = displayScale
        return renderer.uiImage
    }
}

// MARK: - Previews

@MainActor private let previewProfile = BabyProfile(store: InMemoryBabyInfoStore())

@MainActor
private func previewViewModel(name: String, monthsOld: Int, theme: BirthdayTheme) -> BirthdayViewModel {
    let birthday = Calendar.current.date(byAdding: .month, value: -monthsOld, to: .now)!
    return BirthdayViewModel(details: BabyInfo(name: name, birthday: birthday)!,
                             profile: previewProfile,
                             theme: theme)
}

#Preview("Elephant · 1 month") {
    NavigationStack {
        BirthdayView(viewModel: previewViewModel(name: "Cristiano Ronaldo", monthsOld: 1, theme: .elephant))
    }
}

#Preview("Fox · 10 months") {
    NavigationStack {
        BirthdayView(viewModel: previewViewModel(name: "Mia", monthsOld: 10, theme: .fox))
    }
}

#Preview("Pelican · 3 years, long name") {
    NavigationStack {
        BirthdayView(viewModel: previewViewModel(name: "Alexandria Catherine Montgomery", monthsOld: 36, theme: .pelican))
    }
}
