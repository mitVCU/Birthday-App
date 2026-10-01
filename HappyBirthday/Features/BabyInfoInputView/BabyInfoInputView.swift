//
//  BabyInfoInputView.swift
//  HappyBirthday
//
//  Created by Mit Amin on 9/30/26.
//

import SwiftUI

struct BabyInfoInputView: View {
    @Bindable var babyInfoInputVM: BabyInfoInputViewModel

    @State private var activeInput: ActiveInput?
    @FocusState private var isNameFocused: Bool

    private static let horizontalPadding: CGFloat = 20
    private static let photoSize: CGFloat = 120

    private enum ActiveInput: Hashable {
        case name, birthday, photo
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Text("Happy Birthday")
                    .font(.largeTitle.bold())
                    .multilineTextAlignment(.center)

                photoButton

                fieldsCard
            }
            .padding(.horizontal, Self.horizontalPadding)
            .padding(.top, 24)
            .frame(maxWidth: .infinity)
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture { activeInput = nil }
            )
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.interactively)
        .safeAreaInset(edge: .bottom) { showBirthdayButton }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onChange(of: isNameFocused) { _, focused in
            if focused {
                activeInput = .name
            } else if activeInput == .name {
                activeInput = nil
            }
        }
        .onChange(of: activeInput) { _, input in
            isNameFocused = (input == .name)
        }
    }

    // MARK: - Photo

    private var photoButton: some View {
        Button {
            activeInput = .photo
        } label: {
            photo
        }
        .buttonStyle(.plain)
        .accessibilityLabel(babyInfoInputVM.image == nil ? "Add baby photo" : "Change baby photo")
        .photoSourcePicker(isPresented: isActive(.photo)) { image in
            babyInfoInputVM.setImage(image)
        }
    }

    private var photo: some View {
        Group {
            if let image = babyInfoInputVM.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(width: Self.photoSize, height: Self.photoSize)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing) { cameraBadge }
    }

    private var cameraBadge: some View {
        Image(systemName: "camera.fill")
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(8)
            .background(Color.accentColor, in: Circle())
            .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: 3))
            .accessibilityHidden(true)
    }

    // MARK: - Fields

    private var fieldsCard: some View {
        VStack(spacing: 0) {
            TextField("Name", text: $babyInfoInputVM.draft.name)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($isNameFocused)
                .onSubmit { activeInput = nil }
                .padding(16)

            Divider()
                .padding(.leading, 16)

            birthdayRow
                .padding(16)
        }
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: 16))
    }

    private var birthdayRow: some View {
        let birthday = babyInfoInputVM.draft.birthday

        return Button {
            activeInput = .birthday
        } label: {
            HStack {
                Text("Birthday")
                    .foregroundStyle(Color.primary)
                Spacer()
                Text(birthday?.formatted(date: .abbreviated, time: .omitted) ?? "Select")
                    .foregroundStyle(birthday == nil ? Color.secondary : Color.accentColor)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: isActive(.birthday)) {
            BirthdayPickerSheet(initialDate: birthday) { date in
                babyInfoInputVM.draft.birthday = date
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Show birthday

    private var showBirthdayButton: some View {
        Button {
            // Step 3: present the birthday screen
        } label: {
            Text("Show birthday screen")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!babyInfoInputVM.canShowBirthday)
        .padding(.horizontal, Self.horizontalPadding)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Helpers

    /// Presentation binding for one input. Only one input can be active at a time,
    /// and an input dismissing itself never clears a different input that replaced it.
    private func isActive(_ input: ActiveInput) -> Binding<Bool> {
        Binding(
            get: { activeInput == input },
            set: { isPresented in
                if isPresented {
                    activeInput = input
                } else if activeInput == input {
                    activeInput = nil
                }
            }
        )
    }
}

#Preview("Empty") {
    @Previewable @State var vm = BabyInfoInputViewModel(store: InMemoryBabyInfoStore())

    BabyInfoInputView(babyInfoInputVM: vm)
}

#Preview("Filled") {
    @Previewable @State var vm = BabyInfoInputViewModel(
        store: InMemoryBabyInfoStore(
            draft: BabyInfoDraft(
                name: "Mia Rose",
                birthday: Calendar.current.date(byAdding: .month, value: -7, to: .now)
            )
        )
    )

    BabyInfoInputView(babyInfoInputVM: vm)
}
