//
//  BannerView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct BannerView: View {

    @State private var state: FullScreenState = .loading

    @Environment(\.dismiss) private var dismiss

    @State private var lastSelectedButton: Int = 0

    @State private var selectedButton: Int = 0

    @StateObject private var adCoordinator = AdCoordinator()

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("Баннеры")
                    .foregroundColor(Constants.Format.foregroundColor)
                    .font(Constants.Format.textFont)
                    .padding(.leading, 24)
                    .padding(.top, 16)
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image("close")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding(.top, 16)
                        .padding(.trailing, 16)
                }
            }

            ZStack {
                VStack {
                    BannerUIKitView(
                        state: $state,
                        isStatic: Binding<Bool>(
                        get: { selectedButton == 0 },
                        set: { _ in }))
                    .frame(width: 320, height: selectedButton == 0 ? 50 : 250)
                    .environmentObject(adCoordinator)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                VStack {
                    switch state {
                    case .loading:
                        VStack {
                            SpinnerView()
                        }
                    case .error:
                        VStack {
                            Image("error")
                            Text("Ошибка! Не удалось\nзагрузить рекламу :(")
                                .foregroundColor(Constants.Description.foregroundColor)
                                .font(Constants.Description.textFont)
                        }
                    case .ready:
                        VStack {}
                    case .close:
                        VStack {
                            Text("Выберите тип креатива для повторной\nзагрузки рекламы")
                                .foregroundColor(Constants.Text.foregroundColor)
                                .font(Constants.Text.textFont)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 112)
                    }
                }
            }

            HStack(spacing: 8) {
                switch state {
                case .loading, .ready, .close:
                    Button(action: {
                        selectedButton = 0

                        if selectedButton != lastSelectedButton {
                            lastSelectedButton = 0
                            state = .loading
                        }

                        if state == .close {
                            adCoordinator.loadAd()
                        }
                    }) {
                        Text("Статичный")
                            .frame(width: 145, height: 44)
                            .foregroundColor(selectedButton == 0 || state == .close ? Color("backgroundMain") : Color("primary"))
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous)
                                .fill(selectedButton == 0 || state == .close ? Color("primaryLink") : Color("secondary")))
                            .font(Constants.Button.textFont)
                    }
                    .buttonStyle(NoAnimationButtonStyle())

                    Button(action: {
                        selectedButton = 1

                        if selectedButton != lastSelectedButton {
                            lastSelectedButton = 1
                            state = .loading
                        }

                        if state == .close {
                            adCoordinator.loadAd()
                        }
                    }) {
                        Text("Анимированный")
                            .frame(width: 145, height: 44)
                            .foregroundColor(selectedButton == 1 || state == .close ? Color("backgroundMain") : Color("primary"))
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous)
                                .fill(selectedButton == 1 || state == .close ? Color("primaryLink") : Color("secondary")))
                            .font(Constants.Button.textFont)
                    }
                    .buttonStyle(NoAnimationButtonStyle())

                case .error:
                    Button(action: {
                        state = .loading
                        adCoordinator.loadAd()
                    }) {
                        Text("Повторить загрузку")
                            .frame(width: 184, height: 44)
                            .foregroundColor(Color("backgroundMain"))
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 16,
                                    style: .continuous)
                                .fill(Color("primaryLink")))
                            .font(Constants.Button.textFont)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color("backgroundMain"))
    }
}

// MARK: - Constants

private extension BannerView {

    enum Constants {

        enum Format {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-Medium", size: 20)
        }

        enum Button {
            static let textFont: Font = .custom("Inter24pt-Medium", size: 16)
        }

        enum Description {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-Medium", size: 14)
        }

        enum Text {
            static let foregroundColor = Color(red: 29/255, green: 32/255, blue: 35/255).opacity(0.64)
            static let textFont: Font = .custom("Inter24pt-Regular", size: 16)
        }
    }
}
