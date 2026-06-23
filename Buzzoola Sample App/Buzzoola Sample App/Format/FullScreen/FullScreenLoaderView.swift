//
//  FullScreenLoaderView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct SpinnerView: View {

    @State private var isAnimating = false
    var color: Color = Color("loader")
    var size: CGFloat = 35

    var body: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [Color("loader"), Color("loader").opacity(0.5), Color("loader").opacity(0)]),
                    center: .center,
                    startAngle: .degrees(0),
                    endAngle: .degrees(360)
                ),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: size, height: size)
            .rotationEffect(Angle(degrees: isAnimating ? 360 : 0))
            .animation(
                .linear(duration: 1).repeatForever(autoreverses: false),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

enum FullScreenType {
    case interstitial
    case rewarded
    case appOpenAd

    var text: String {
        switch self {
        case .appOpenAd:
            return "Полноэкранная реклама\nпри открытии приложения"
        case .interstitial:
            return "Полноэкранная реклама"
        case .rewarded:
            return "Реклама с вознаграждением"
        }
    }
}

struct FullScreenLoaderView: View {

    var fullScreenType: FullScreenType = .interstitial

    @State private var state: FullScreenState = .loading

    @Environment(\.dismiss) private var dismiss

    @StateObject private var adCoordinator = AdCoordinator()

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(fullScreenType.text)
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
                switch fullScreenType {
                case .appOpenAd:
                    AppOpenView(state: $state, onDismiss: {
                        adCoordinator.loadAd()
                    })
                    .environmentObject(adCoordinator)
                case .interstitial:
                    InterstitialView(state: $state, onDismiss: {
                        adCoordinator.loadAd()
                    })
                    .environmentObject(adCoordinator)
                case .rewarded:
                    RewardedView(state: $state, onDismiss: {
                        adCoordinator.loadAd()
                    })
                    .environmentObject(adCoordinator)
                }
                VStack {
                    switch state {
                    case .loading:
                        VStack {
                            SpinnerView()
                            Text("Загрузка рекламы...")
                                .foregroundColor(Constants.Description.foregroundColor)
                                .font(Constants.Description.textFont)
                        }
                    case .ready, .close:
                        VStack {
                            Image("check")
                            Text("Реклама готова к показу")
                                .foregroundColor(Constants.Description.foregroundColor)
                                .font(Constants.Description.textFont)
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
                .frame(maxHeight: .infinity)
                .safeAreaInset(edge: .bottom) {
                    Button(
                        action: {
                            switch state {
                            case .ready:
                                adCoordinator.showAd()
                            case .error, .close:
                                adCoordinator.loadAd()
                            case .loading:
                                ()
                            }
                        },
                        label: {
                            switch state {
                            case .loading, .ready, .close:
                                Text("Показать рекламу")
                                    .frame(width: 184, height: 44)
                                    .foregroundColor(state == .loading ? Color("primary") : Color("backgroundMain"))
                                    .background(
                                        RoundedRectangle(
                                            cornerRadius: 16,
                                            style: .continuous)
                                        .fill(state == .loading ? Color("secondary") : Color("primaryLink")))
                                    .font(Constants.Button.textFont)
                            case .error:
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
                        })
                    .disabled(state == .loading)
                    .padding(.bottom, 16)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backgroundMain"))
    }
}
// MARK: - Constants

private extension FullScreenLoaderView {

    enum Constants {

        enum Format {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-Medium", size: 20)
        }

        enum Description {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-Medium", size: 14)
        }

        enum Button {
            static let textFont: Font = .custom("Inter24pt-Medium", size: 16)
        }
    }
}
