//
//  BabyInfoInputView.swift
//  HappyBirthday

import SwiftUI

struct BabyInfoInputView: View {
    @Bindable var viewModel: BabyInfoInputViewModel

    @State private var activeInput: ActiveInput?
    @FocusState private var isNameFocused: Bool
    @State private var birthdayViewModel: BirthdayViewModel?

    private enum ActiveInput: Hashable {
        case name, birthday, photo
    }

    private enum Layout {
        static let horizontalPadding: CGFloat = 20
        static let topPadding: CGFloat = 8
        static let photoToFields: CGFloat = 28
        static let photoSize: CGFloat = 120
        static let cameraBadgePadding: CGFloat = 8
        static let cameraBadgeBorderWidth: CGFloat = 3
        static let fieldPadding: CGFloat = 16
        static let cardCornerRadius: CGFloat = 16
        static let buttonVerticalPadding: CGFloat = 12
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Layout.photoToFields) {
                photoButton

                fieldsCard
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.top, Layout.topPadding)
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
        .navigationTitle("Happy Birthday")
        .navigationDestination(item: $birthdayViewModel) { birthdayViewModel in
            BirthdayView(viewModel: birthdayViewModel)
        }
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
        .accessibilityLabel(viewModel.photoAccessibilityLabel)
        .photoSourcePicker(isPresented: isActive(.photo)) { image in
            viewModel.setImage(image)
        }
    }

    private var photo: some View {
        Group {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .foregroundStyle(.tertiary)
            }
        }
        .frame(width: Layout.photoSize, height: Layout.photoSize)
        .clipShape(Circle())
        .overlay(alignment: .bottomTrailing) { cameraBadge }
    }

    private var cameraBadge: some View {
        Image(systemName: "camera.fill")
            .font(.footnote)
            .foregroundStyle(.white)
            .padding(Layout.cameraBadgePadding)
            .background(Color.accentColor, in: Circle())
            .overlay(Circle().stroke(Color(.systemGroupedBackground), lineWidth: Layout.cameraBadgeBorderWidth))
            .accessibilityHidden(true)
    }

    // MARK: - Fields

    private var fieldsCard: some View {
        VStack(spacing: 0) {
            TextField("Name", text: $viewModel.name)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .submitLabel(.done)
                .focused($isNameFocused)
                .onSubmit { activeInput = nil }
                .padding(Layout.fieldPadding)

            Divider()
                .padding(.leading, Layout.fieldPadding)

            birthdayRow
                .padding(Layout.fieldPadding)
        }
        .background(Color(.secondarySystemGroupedBackground),
                    in: RoundedRectangle(cornerRadius: Layout.cardCornerRadius))
    }

    private var birthdayRow: some View {
        let birthday = viewModel.birthday

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
                viewModel.birthday = date
            }
            .presentationDetents([.medium])
        }
    }

    // MARK: - Show birthday

    private var showBirthdayButton: some View {
        Button {
            activeInput = nil
            birthdayViewModel = viewModel.makeBirthdayViewModel()
        } label: {
            Text("Show birthday screen")
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .controlSize(.large)
        .disabled(!viewModel.canShowBirthday)
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.buttonVerticalPadding)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Helpers

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
    @Previewable @State var viewModel = BabyInfoInputViewModel(
        profile: BabyProfile(store: InMemoryBabyInfoStore())
    )

    NavigationStack {
        BabyInfoInputView(viewModel: viewModel)
    }
}

#Preview("Filled") {
    @Previewable @State var viewModel = BabyInfoInputViewModel(
        profile: BabyProfile(
            store: InMemoryBabyInfoStore(
                draft: BabyInfoDraft(
                    name: "Mia Rose",
                    birthday: Calendar.current.date(byAdding: .month, value: -7, to: .now)
                )
            )
        )
    )

    NavigationStack {
        BabyInfoInputView(viewModel: viewModel)
    }
}
