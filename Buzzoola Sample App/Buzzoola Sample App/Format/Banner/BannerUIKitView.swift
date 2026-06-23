//
//  BannerUIKitView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct BannerUIKitView: UIViewRepresentable {

    @EnvironmentObject var adCoordinator: AdCoordinator

    @Binding var state: FullScreenState

    @Binding var isStatic: Bool

    func makeUIView(context: Context) -> UIView {
        let view = BannerAdView()
        view.delegate = context.coordinator

        context.coordinator.bannerView = view
        context.coordinator.lastIsStatic = isStatic

        view.loadAd(
            request: AdsRequest(
                placementID: (isStatic ? PlacementID.staticBanner.rawValue : PlacementID.animationBanner.rawValue),
                width: 320,
                height: 250)
        )

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard
            let bannerView = context.coordinator.bannerView
        else {
            return
        }

        if isStatic != context.coordinator.lastIsStatic {
            bannerView.destroy()
            bannerView.loadAd(
                request: AdsRequest(
                    placementID: isStatic ? PlacementID.staticBanner.rawValue : PlacementID.animationBanner.rawValue,
                    width: 320,
                    height: 250)
            )
            context.coordinator.lastIsStatic = isStatic
        }
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)

        coordinator.loadAdClosure = { [weak coordinator] in
            coordinator?.loadAd()
        }

        adCoordinator.loadAdAction = { [weak coordinator] in
            coordinator?.loadAdClosure?()
        }

        return coordinator
    }

    class Coordinator: NSObject, BannerAdEventProtocol {

        // MARK: Properties

        var bannerView: BannerAdView?

        var parent: BannerUIKitView

        var lastIsStatic: Bool = false

        var loadAdClosure: (() -> Void)?

        init(_ parent: BannerUIKitView) {
            self.parent = parent
        }

        func loadAd() {
            bannerView?.destroy()

            bannerView?.loadAd(
                request: AdsRequest(
                    placementID: parent.isStatic ? PlacementID.staticBanner.rawValue : PlacementID.animationBanner.rawValue,
                    width: 320,
                    height: 250))

            parent.state = .loading
        }

        // MARK: BannerAdEventProtocol

        func onAdLoaded(_ banner: BannerAdView) {
            parent.state = .ready

            print("onAdLoaded")
        }

        func onAdFailed(_ banner: BannerAdView, adError: AdError) {
            parent.state = .error

            print("onAdFailed", adError)
        }

        func onAdClicked(_ banner: BannerAdView) {
            print("onAdClicked")
        }

        func onLeftApplication(_ banner: BannerAdView) {
            print("onLeftApplication")
        }

        func onReturnedToApplication(_ banner: BannerAdView) {
            print("onReturnedToApplication")
        }

        func onImpression(_ banner: BannerAdView, data: String?) {
            print("onImpression", data ?? "")
        }

        func onCloseAd(_ banner: BannerAdView) {
            parent.state = .close

            print("onCloseAd")
        }
    }
}
