//
//  BirthdayPhotoView.swift
//  HappyBirthday
//

import SwiftUI

/// The round baby photo. Shows the theme's placeholder until a photo is chosen,
/// and draws a ring around a real photo that matches the placeholder's ring.
struct BirthdayPhotoView: View {
    let image: UIImage?
    let theme: BirthdayTheme

    /// The placeholder art's ring is 7pt wide in a 229pt-wide image.
    static let borderWidthRatio: CGFloat = 7 / 229

    var body: some View {
        Group {
            if let image {
                GeometryReader { proxy in
                    let diameter = min(proxy.size.width, proxy.size.height)
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: diameter, height: diameter)
                        .clipShape(Circle())
                        .overlay(
                            Circle().strokeBorder(theme.accentColor,
                                                  lineWidth: diameter * Self.borderWidthRatio)
                        )
                }
            } else {
                Image(theme.placeholderImage)
                    .resizable()
                    .scaledToFit()
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .accessibilityHidden(true)
    }
}
