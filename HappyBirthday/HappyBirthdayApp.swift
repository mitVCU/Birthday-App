//
//  HappyBirthdayApp.swift
//  HappyBirthday
//

import SwiftUI

@main
struct HappyBirthdayApp: App {
    @State private var babyInfoInputVM = BabyInfoInputViewModel(
        profile: BabyProfile(store: DefaultBabyInfoStore())
    )

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BabyInfoInputView(babyInfoInputVM: babyInfoInputVM)
            }
        }
    }
}
