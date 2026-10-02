//
//  BirthdayPhotoView.swift
//  HappyBirthday
//

import SwiftUI

struct BirthdayPhotoView: View {
    let image: UIImage?
    let theme: BirthdayTheme

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
