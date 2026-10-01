//
//  HappyBirthdayApp.swift
//  HappyBirthday
//
//  Created by Mit Amin on 9/30/26.
//

import SwiftUI

@main
struct HappyBirthdayApp: App {
    @State private var babyInfoInputVM = BabyInfoInputViewModel()

    var body: some Scene {
        WindowGroup {
            BabyInfoInputView(babyInfoInputVM: babyInfoInputVM)
        }
    }
}
