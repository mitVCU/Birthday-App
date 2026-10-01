//
//  BirthdayView.swift
//  HappyBirthday
//

import SwiftUI

struct BirthdayView: View {
    @State private var viewModel: BirthdayViewModel
    @Environment(\.dismiss) private var dismiss

    init(details: BabyDetails, profile: BabyProfile, theme: BirthdayTheme = .random(), now: Date = .now) {
        _viewModel = State(initialValue: BirthdayViewModel(details: details, profile: profile,
                                                           theme: theme, now: now))
    }

    private enum Layout {
        static let backButtonSize: CGFloat = 44            // tap target around the 24pt arrow
        static let backButtonLeading: CGFloat = 4
        static let backButtonTop: CGFloat = 6
        static let titleHorizontalInset: CGFloat = 50       // clears the back arrow, keeps text centered
        static let ageSectionMinSpacing: CGFloat = 20       // flexible: grows on taller screens
        static let titleToNumber: CGFloat = 13
        static let numberToUnit: CGFloat = 14
        static let swirlToNumber: CGFloat = 22
        static let photoWidthRatio: CGFloat = 275 / 375     // the design's circle on its 375pt frame (≈ 0.733)
        static let photoMinHorizontalInset: CGFloat = 50    // minimum only: margins grow with the ratio
        static let photoToLogo: CGFloat = 15
        static let logoToShareButton: CGFloat = 53
        static let shareButtonHeight: CGFloat = 42
        static let shareButtonToBottom: CGFloat = 53
        static let textSize: CGFloat = 21
        static let textTracking: CGFloat = -0.42
    }

    /// The photo sits under the illustration (the art overlaps it, as in the design);
    /// the text, logo and buttons sit over it.
    private enum Layer {
        case belowIllustration, aboveIllustration
    }

    var body: some View {
        // The reader itself respects the safe area so it can measure the status bar;
        // only the layers inside it extend to the screen edges.
        GeometryReader { proxy in
            let statusBarHeight = proxy.safeAreaInsets.top
            // The photo is 73.3% of the screen width (the design's 275pt on 375pt), so the
            // side margins grow on wider screens; 50pt is only the minimum.
            let maxPhotoDiameter = max(0, min(proxy.size.width * Layout.photoWidthRatio,
                                              proxy.size.width - 2 * Layout.photoMinHorizontalInset))

            ZStack(alignment: .bottom) {
                viewModel.theme.backgroundColor

                content(.belowIllustration, topInset: statusBarHeight, maxPhotoDiameter: maxPhotoDiameter)

                Color.clear
                    .overlay(alignment: .bottom) {
                        Image(viewModel.theme.backgroundImage)
                            .resizable()
                            .scaledToFill()
                    }
                    .clipped()
                    .accessibilityHidden(true)

                content(.aboveIllustration, topInset: statusBarHeight, maxPhotoDiameter: maxPhotoDiameter)
            }
            .ignoresSafeArea()
        }
        .toolbar(.hidden, for: .navigationBar)
        .swipeBackEnabled()   // hiding the bar disables the edge swipe; this restores it
    }

    // MARK: - Layout

    /// The full screen layout. It's built once per layer with identical spacing,
    /// and each layer shows only its own elements, so both line up exactly.
    private func content(_ layer: Layer, topInset: CGFloat, maxPhotoDiameter: CGFloat) -> some View {
        let isAbove = layer == .aboveIllustration

        return VStack(spacing: 0) {
            // Two equal spacers center the age section between the status bar and the photo.
            Spacer(minLength: Layout.ageSectionMinSpacing)

            ageSection
                .fixedSize(horizontal: false, vertical: true)
                .shown(isAbove)

            Spacer(minLength: Layout.ageSectionMinSpacing)

            BirthdayPhotoView(image: viewModel.image, theme: viewModel.theme)
                .frame(maxWidth: maxPhotoDiameter, maxHeight: maxPhotoDiameter)
                .layoutPriority(1)   // gets space before the spacers; shrinks only when height runs out
                .shown(!isAbove)

            Image(.nanitLogo)
                .padding(.top, Layout.photoToLogo)
                .accessibilityHidden(true)
                .shown(isAbove)

            // Step 5: the "Share the news" button takes this slot.
            Color.clear
                .frame(height: Layout.shareButtonHeight)
                .padding(.top, Layout.logoToShareButton)
                .padding(.bottom, Layout.shareButtonToBottom)
        }
        .padding(.top, topInset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            if isAbove {
                backButton
                    .padding(.top, topInset + Layout.backButtonTop)
                    .padding(.leading, Layout.backButtonLeading)
            }
        }
    }

    // MARK: - Sections

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(.icBack)
                .foregroundStyle(Color.birthdayText)
                .frame(width: Layout.backButtonSize, height: Layout.backButtonSize)
                .contentShape(Rectangle())
        }
        .accessibilityLabel("Back")
    }

    private var ageSection: some View {
        VStack(spacing: 0) {
            styledText(viewModel.title)
                .lineLimit(2)
                .padding(.horizontal, Layout.titleHorizontalInset)

            HStack(spacing: Layout.swirlToNumber) {
                Image(.swirlLeft)
                Image(viewModel.age.numberImageName)
                Image(.swirlRight)
            }
            .padding(.top, Layout.titleToNumber)

            styledText(viewModel.age.unitText)
                .padding(.top, Layout.numberToUnit)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.accessibilityAgeLabel)
    }

    private func styledText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: Layout.textSize, weight: .medium))
            .tracking(Layout.textTracking)
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.birthdayText)
    }
}

// MARK: - Previews

@MainActor private let previewProfile = BabyProfile(store: InMemoryBabyInfoStore())

private func previewDetails(name: String, monthsOld: Int) -> BabyDetails {
    let birthday = Calendar.current.date(byAdding: .month, value: -monthsOld, to: .now)!
    return BabyDetails(name: name, birthday: birthday)!
}

#Preview("Elephant · 1 month") {
    NavigationStack {
        BirthdayView(details: previewDetails(name: "Cristiano Ronaldo", monthsOld: 1),
                     profile: previewProfile, theme: .elephant)
    }
}

#Preview("Fox · 10 months") {
    NavigationStack {
        BirthdayView(details: previewDetails(name: "Mia", monthsOld: 10),
                     profile: previewProfile, theme: .fox)
    }
}

#Preview("Pelican · 3 years, long name") {
    NavigationStack {
        BirthdayView(details: previewDetails(name: "Alexandria Catherine Montgomery", monthsOld: 36),
                     profile: previewProfile, theme: .pelican)
    }
}
