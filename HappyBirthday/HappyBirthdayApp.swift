//
//  HappyBirthdayApp.swift
//  HappyBirthday
//

import SwiftUI

@main
struct HappyBirthdayApp: App {
    @State private var inputViewModel = BabyInfoInputViewModel(
        profile: BabyProfile(store: DefaultBabyInfoStore())
    )

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                BabyInfoInputView(viewModel: inputViewModel)
            }
            .task { await inputViewModel.loadSavedImage() }
        }
    }
}
