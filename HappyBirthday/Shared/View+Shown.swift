//
//  View+Shown.swift
//  HappyBirthday
//

import SwiftUI

extension View {

    @ViewBuilder
    func shown(_ isShown: Bool) -> some View {
        if isShown {
            self
        } else {
            hidden()
        }
    }
}
