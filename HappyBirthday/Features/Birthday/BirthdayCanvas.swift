//
//  BirthdayCanvas.swift
//  HappyBirthday
//

import SwiftUI

struct BirthdayCanvas: View {
    struct CanvasActions {
        let shareImage: UIImage?
        let onBack: () -> Void
        let onChangePhoto: () -> Void
    }

    let viewModel: BirthdayViewModel
    let screenWidth: CGFloat
    let topInset: CGFloat
    let actions: CanvasActions?

    private enum Layout {
        static let backButtonSize: CGFloat = 44            // tap target around the 24pt arrow
        static let backButtonLeading: CGFloat = 6
        static let backButtonTop: CGFloat = 4
        static let titleHorizontalInset: CGFloat = 50       // clears the back arrow, keeps text centered
        static let ageSectionMinSpacing: CGFloat = 20       // flexible: grows on taller screens
        static let titleToNumber: CGFloat = 13
        static let numberToUnit: CGFloat = 14
        static let swirlToNumber: CGFloat = 22
        static let photoWidthRatio: CGFloat = 0.6           // keeps more of the photo clear of the art
        static let photoMinHorizontalInset: CGFloat = 50    // minimum only: margins grow with the ratio
        static let cameraIconTapSize: CGFloat = 44          // tap target around the 36pt icon
        static let cameraIconAngle: Angle = .degrees(45)    // the design's position on the border
        static let photoToLogo: CGFloat = 15
        static let logoToShareButton: CGFloat = 53
        static let shareButtonHeight: CGFloat = 42
        static let shareButtonToBottom: CGFloat = 53
        static let shareButtonFontSize: CGFloat = 16
        static let shareButtonHorizontalPadding: CGFloat = 21
        static let shareButtonIconSpacing: CGFloat = 8
        static let textSize: CGFloat = 21
        static let textTracking: CGFloat = -0.42
    }

    private enum Layer {
        case belowIllustration, aboveIllustration
    }

    private var maxPhotoDiameter: CGFloat {
        max(0, min(screenWidth * Layout.photoWidthRatio,
                   screenWidth - 2 * Layout.photoMinHorizontalInset))
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            viewModel.theme.backgroundColor

            content(.belowIllustration)

            illustration

            content(.aboveIllustration)
        }
    }

    // MARK: - Layers

    private var illustration: some View {
        Color.clear
            .overlay(alignment: .bottom) {
                Image(viewModel.theme.backgroundImage)
                    .resizable()
                    .scaledToFit()
            }
            .clipped()
            .accessibilityHidden(true)
    }

    private func content(_ layer: Layer) -> some View {
        let isAbove = layer == .aboveIllustration
        let layerControls = isAbove ? actions : nil

        return VStack(spacing: 0) {
            Spacer(minLength: Layout.ageSectionMinSpacing)

            ageSection
                .fixedSize(horizontal: false, vertical: true)
                .shown(isAbove)

            Spacer(minLength: Layout.ageSectionMinSpacing)

            BirthdayPhotoView(image: viewModel.image, theme: viewModel.theme)
                .frame(maxWidth: maxPhotoDiameter, maxHeight: maxPhotoDiameter)
                .layoutPriority(1)
                .shown(!isAbove)
                .overlay {
                    if let layerControls {
                        cameraBadge(action: layerControls.onChangePhoto)
                    }
                }

            Image(.nanitLogo)
                .padding(.top, Layout.photoToLogo)
                .accessibilityHidden(true)
                .shown(isAbove)

            shareButton(layerControls?.shareImage)
                .shown(layerControls != nil)
                .padding(.top, Layout.logoToShareButton)
                .padding(.bottom, Layout.shareButtonToBottom)
        }
        .padding(.top, topInset)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topLeading) {
            if let layerControls {
                backButton(action: layerControls.onBack)
                    .padding(.top, topInset + Layout.backButtonTop)
                    .padding(.leading, Layout.backButtonLeading)
            }
        }
    }

    // MARK: - Age

    private var ageSection: some View {
        VStack(spacing: 0) {
            ageText(viewModel.title)
                .lineLimit(2)
                .padding(.horizontal, Layout.titleHorizontalInset)

            HStack(spacing: Layout.swirlToNumber) {
                Image(.swirlLeft)
                Image(viewModel.age.numberImageName)
                Image(.swirlRight)
            }
            .padding(.top, Layout.titleToNumber)

            ageText(viewModel.age.unitText)
                .padding(.top, Layout.numberToUnit)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(viewModel.accessibilityAgeLabel)
    }

    private func ageText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: Layout.textSize, weight: .medium))
            .tracking(Layout.textTracking)
            .textCase(.uppercase)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.birthdayText)
    }

    // MARK: - Controls

    private func backButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(.icBack)
                .foregroundStyle(Color.birthdayText)
                .frame(width: Layout.backButtonSize, height: Layout.backButtonSize)
                .contentShape(Rectangle())
        }
        .accessibilityLabel("Back")
    }

    private func cameraBadge(action: @escaping () -> Void) -> some View {
        GeometryReader { proxy in
            let diameter = min(proxy.size.width, proxy.size.height)
            let borderWidth = diameter * BirthdayPhotoView.borderWidthRatio
            let radius = (diameter - borderWidth) / 2
            let angle = Layout.cameraIconAngle.radians

            Button(action: action) {
                Image(viewModel.theme.cameraIcon)
                    .frame(width: Layout.cameraIconTapSize, height: Layout.cameraIconTapSize)
                    .contentShape(Circle())
            }
            .accessibilityLabel(viewModel.photoAccessibilityLabel)
            .position(x: proxy.size.width / 2 + radius * cos(angle),
                      y: proxy.size.height / 2 - radius * sin(angle))
        }
    }

    @ViewBuilder
    private func shareButton(_ shareImage: UIImage?) -> some View {
        if let shareImage {
            let image = Image(uiImage: shareImage)
            ShareLink(item: image, preview: SharePreview(viewModel.shareTitle, image: image)) {
                shareButtonLabel
            }
        } else {
            shareButtonLabel
                .opacity(0.6)
        }
    }

    private var shareButtonLabel: some View {
        HStack(spacing: Layout.shareButtonIconSpacing) {
            Text("Share the news")
                .font(.system(size: Layout.shareButtonFontSize, weight: .medium))
            Image(.icShare)
        }
        .foregroundStyle(.white)   // ic_share is a template image, so it turns white too
        .padding(.horizontal, Layout.shareButtonHorizontalPadding)
        .frame(height: Layout.shareButtonHeight)
        .background(Color.birthdayCoral, in: Capsule())
    }
}

private extension View {
    @ViewBuilder
    func shown(_ isShown: Bool) -> some View {
        if isShown {
            self
        } else {
            hidden()
        }
    }
}
