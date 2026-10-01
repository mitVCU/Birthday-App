//
//  BabyInfoInputView.swift
//  HappyBirthday
//
//  Created by Mit Amin on 9/30/26.
//

import PhotosUI
import SwiftUI

struct BabyInfoInputView: View {
    @Bindable var babyInfoInputVM: BabyInfoInputViewModel
    @State private var pickerItem: PhotosPickerItem?
    @FocusState private var isNameFocused: Bool

    var body: some View {
        VStack(spacing: 28) {
            Text("Happy Birthday")
                .font(.largeTitle.bold())

            photoPicker

            fieldsCard

            Spacer()

            Button {
                // Step 3: present the birthday screen
            } label: {
                Text("Show birthday screen")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(!babyInfoInputVM.canShowBirthday)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .onTapGesture { isNameFocused = false }   // 2. tap outside dismisses
        )
        .onChange(of: pickerItem) { _, item in
            Task { await babyInfoInputVM.setImage(from: item) }
        }
    }

    private var fieldsCard: some View {
        VStack(spacing: 0) {
            TextField("Name", text: $babyInfoInputVM.draft.name)
                .focused($isNameFocused)
                .onSubmit { isNameFocused = false }
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .padding(16)

            Divider().padding(.leading, 16)

            birthdayRow
                .padding(16)
        }
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var birthdayRow: some View {
        if let birthday = babyInfoInputVM.draft.birthday {
            DatePicker("Birthday",
                       selection: Binding(get: { birthday },
                                          set: { babyInfoInputVM.draft.birthday = $0 }),
                       in: ...Date.now,
                       displayedComponents: .date)
        } else {
            HStack {
                Text("Birthday")
                Spacer()
                Button("Add birthday") { babyInfoInputVM.draft.birthday = .now }
            }
        }
    }

    @MainActor
    private var photoPicker: some View {
        let selectedImage = babyInfoInputVM.image

        return PhotosPicker(selection: $pickerItem, matching: .images) {
            Group {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "camera.fill")
                    .font(.footnote)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background(Color.accentColor, in: Circle())
                    .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: 3))
            }
        }
    }
}

#Preview {
    @Previewable @State var vm = BabyInfoInputViewModel()

    BabyInfoInputView(babyInfoInputVM: vm)
}
