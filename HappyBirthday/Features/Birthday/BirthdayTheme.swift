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
        case .elephant: Color(.elephantBackground)
        case .fox: Color(.foxBackground)
        case .pelican: Color(.pelicanBackground)
        }
    }

    var accentColor: Color {
        switch self {
        case .elephant: Color(.elephantAccent)
        case .fox: Color(.foxAccent)
        case .pelican: Color(.pelicanAccent)
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
