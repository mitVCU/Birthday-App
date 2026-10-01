//
//  HappyBirthdayApp.swift
//  HappyBirthday
//

import SwiftUI

@main
struct HappyBirthdayApp: App {
    @State private var babyInfoInputVM = BabyInfoInputViewModel(store: DefaultBabyInfoStore())

    var body: some Scene {
        WindowGroup {
            BabyInfoInputView(babyInfoInputVM: babyInfoInputVM)
        }
    }
}
