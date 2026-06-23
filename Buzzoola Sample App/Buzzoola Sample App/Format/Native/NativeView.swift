//
//  NativeView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct NativeView: View {

    @State private var state: FullScreenState = .loading

    @StateObject private var adCoordinator = AdCoordinator()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Text("Нативный формат")
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
                    NativeUIKitView(state: $state)
                        .frame(width: 340, height: 290)
                        .aspectRatio(contentMode: .fit)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .opacity(state == .ready ? 1 : 0)
                        .environmentObject(adCoordinator)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                switch state {
                case .loading:
                    VStack {
                        SpinnerView()
                    }
                case .ready:
                    VStack {}
                case .close:
                    VStack {
                        Image("check")
                        Text("Рекламное объявление скрыто")
                            .foregroundColor(Constants.Description.foregroundColor)
                            .font(Constants.Description.textFont)
                        Text("Чтобы загрузить рекламу повторно,\nнажмите кнопку ниже")
                            .foregroundColor(Constants.Text.foregroundColor)
                            .font(Constants.Text.textFont)
                            .multilineTextAlignment(.center)
                            .padding(.top, 8)
                    }
                case .error:
                    VStack {
                        Image("error")
                        Text("Ошибка! Не удалось\nзагрузить рекламу :(")
                            .foregroundColor(Constants.Description.foregroundColor)
                            .font(Constants.Description.textFont)
                    }
                }
            }

            if state == .close || state == .error {
                HStack(spacing: 8) {
                    Button(action: {
                        adCoordinator.loadAd()
                    }) {
                        Text(state == .close ? "Загрузить рекламу" : "Повторить загрузку")
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
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(Color("backgroundMain"))
    }
}

// MARK: - Constants

private extension NativeView {

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
            static let textFont: Font = .custom("Inter24pt-Medium", size: 16)
        }

        enum Text {
            static let foregroundColor = Color(red: 29/255, green: 32/255, blue: 35/255).opacity(0.64)
            static let textFont: Font = .custom("Inter24pt-Regular", size: 16)
        }
    }
}
