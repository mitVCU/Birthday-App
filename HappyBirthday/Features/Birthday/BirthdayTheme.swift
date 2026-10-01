//
//  BirthdayTheme.swift
//  HappyBirthday
//

import SwiftUI

enum BirthdayTheme: CaseIterable {
    case elephant, fox, pelican

    static func random() -> BirthdayTheme {
        allCases.randomElement() ?? .elephant
    }

    var backgroundColor: Color {
        switch self {
        case .elephant: Color(red: 0.984, green: 0.937, blue: 0.812)
        case .fox: Color(red: 0.800, green: 0.906, blue: 0.875)
        case .pelican: Color(red: 0.871, green: 0.941, blue: 0.961)
        }
    }

    /// Photo border, matching the placeholder ring and the camera icon.
    var accentColor: Color {
        switch self {
        case .elephant: Color(red: 254 / 255, green: 190 / 255, blue: 33 / 255)   // #FEBE21
        case .fox: Color(red: 111 / 255, green: 197 / 255, blue: 175 / 255)       // #6FC5AF
        case .pelican: Color(red: 139 / 255, green: 211 / 255, blue: 228 / 255)   // #8BD3E4
        }
    }

    var backgroundImage: ImageResource {
        switch self {
        case .elephant: .bgElephant
        case .fox: .bgFox
        case .pelican: .bgPelican
        }
    }

    var placeholderImage: ImageResource {
        switch self {
        case .elephant: .placeholderElephant
        case .fox: .placeholderFox
        case .pelican: .placeholderPelican
        }
    }

    var cameraIcon: ImageResource {
        switch self {
        case .elephant: .cameraElephant
        case .fox: .cameraFox
        case .pelican: .cameraPelican
        }
    }
}

extension Color {
    static let birthdayText = Color(red: 57 / 255, green: 69 / 255, blue: 98 / 255)     // #394562
    static let birthdayCoral = Color(red: 239 / 255, green: 123 / 255, blue: 123 / 255) // #EF7B7B
}
