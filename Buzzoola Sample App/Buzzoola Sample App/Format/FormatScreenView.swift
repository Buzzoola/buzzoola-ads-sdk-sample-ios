//
//  FormatScreenView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct FormatScreenView: View {

    @Environment(\.dismiss) private var dismiss

    var type: AdType

    init(type: AdType) {
        self.type = type
    }

    var body: some View {
        switch type {
        case .banner:
            BannerView()
        case .native:
            NativeView()
        case .interstitial:
            FullScreenLoaderView(fullScreenType: .interstitial)
        case .rewarded:
            FullScreenLoaderView(fullScreenType: .rewarded)
        case .appOpenAd:
            FullScreenLoaderView(fullScreenType: .appOpenAd)
        default:
            InstreamView()
                .statusBarHidden(false)
        }
    }
}
