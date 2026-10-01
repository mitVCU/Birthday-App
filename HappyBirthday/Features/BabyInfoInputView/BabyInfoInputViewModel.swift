//
//  BabyInfoInputViewModel.swift
//  HappyBirthday
//
//  Created by Mit Amin on 9/30/26.
//
import SwiftUI
import PhotosUI
import UIKit

@MainActor
@Observable
final class BabyInfoInputViewModel {
     var draft: BabyInfoDraft { didSet { persist() } }
     var image: UIImage?

     var details: BabyDetails? { BabyDetails(draft: draft) }
     var canShowBirthday: Bool { details != nil }

     init(draft: BabyInfoDraft = BabyInfoDraft()) {
         self.draft = draft
     }
    
    func setImage(from item: PhotosPickerItem?) async {
        guard let data = try? await item?.loadTransferable(type: Data.self),
              let image = UIImage(data: data) else { return }
        self.image = image
        // Step 2: persist the image
    }

     private func persist() {
         // Step 2: store.save(draft)
     }
    
}
