//
//  ContentView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct ContentView: View {

    @State private var showModal = false

    @State private var selectedTab = 0

    init() {
        UIPageControl.appearance().currentPageIndicatorTintColor = Constants.pagerSelectedColor
        UIPageControl.appearance().pageIndicatorTintColor = Constants.pagerColor
    }

    var body: some View {
        VStack {
            HStack {
                Image("buzzIcon")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .cornerRadius(10)
                Text("Buzzoola Ads SDK")
                    .foregroundColor(Constants.Header.foregroundColor)
                    .font(Constants.Header.textFont)
            }
            TabView(selection: $selectedTab) {
                PreviewImageView(
                    image: "previewOne",
                    title: "Нативный формат",
                    description: "Адаптируется и маскируется под контент приложения. Внешний вид рекламы полностью определяется на стороне приложения, реклама воспринимается естественно, как оригинальный контент приложения.")
                .tag(0)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
                PreviewImageView(
                    image: "previewTwo",
                    title: "Баннеры",
                    description: "Рекламный блок с текстово-графическими объявлениями, медийной и видеорекламой. При клике  пользователь переходит на сайт рекламодателя.")
                .tag(1)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
                PreviewImageView(
                    image: "previewThree",
                    title: "Полноэкранная реклама",
                    description: "Занимает весь экран и встраивается в контент во время естественных пауз, таких как переход между уровнями игры или окончание действия")
                .tag(2)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
                PreviewImageView(
                    image: "previewFour",
                    title: "Реклама с вознаграждением",
                    description: "Блоки с текстово-графическими объявлениями или видеорекламой, которые используются для монетизации игр. Блок показывается на весь экран приложения. За просмотр рекламы пользователь получает награду.")
                .tag(3)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
                PreviewImageView(
                    image: "previewFive",
                    title: "InStream реклама",
                    description: "Содержит один или несколько рекламных роликов, которые могут проигрываться перед основным контентом")
                .tag(4)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
                PreviewImageView(
                    image: "previewSix",
                    title: "Полноэкранная реклама при открытии приложения",
                    description: "Cпециальный формат рекламы для монетизации экранов загрузки своих приложений")
                .tag(5)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.top, 64)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .never))
            .onChange(of: selectedTab) { _, newValue in
                selectedTab = newValue
            }
            Button(
                action: {
                    showModal = true
                },
                label: {
                    Text("Превью формата")
                        .frame(width: 184, height: 44)
                        .foregroundColor(Color("backgroundMain"))
                        .background(
                            RoundedRectangle(
                                cornerRadius: 16,
                                style: .continuous)
                            .fill(Color("primaryLink")))
                        .font(Constants.Button.textFont)
                })

        }
        .padding()
        .background(Color("backgroundMain"))
        .fullScreenCover(isPresented: $showModal) {
            var type: AdType = .native
            switch selectedTab {
            case 0:
                type = .native
            case 1:
                type = .banner
            case 2:
                type = .interstitial
            case 3:
                type = .rewarded
            case 4:
                type = .instream
            default:
                type = .appOpenAd
            }

            return FormatScreenView(type: type)
        }
    }
}

#Preview {
    ContentView()
}

// MARK: - Constants

private extension ContentView {

    enum Constants {

        static let pagerSelectedColor = UIColor(Color("pagerSelected"))
        static let pagerColor = UIColor(Color("pager"))

        enum Header {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-SemiBold", size: 24)
        }

        enum Button {
            static let foregroundColor = Color("primaryLink")
            static let textFont: Font = .custom("Inter24pt-Medium", size: 16)
        }
    }
}
