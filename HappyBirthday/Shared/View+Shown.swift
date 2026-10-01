//
//  View+Shown.swift
//  HappyBirthday
//

import SwiftUI

extension View {
    /// Hides the view but keeps its space in the layout (unlike removing it).
    /// Hidden views are also skipped by hit testing and VoiceOver.
    @ViewBuilder
    func shown(_ isShown: Bool) -> some View {
        if isShown {
            self
        } else {
            hidden()
        }
    }
}
