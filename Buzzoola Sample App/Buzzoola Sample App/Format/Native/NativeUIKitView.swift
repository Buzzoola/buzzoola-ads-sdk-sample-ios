//
//  NativeUIKitView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct NativeUIKitView: UIViewRepresentable {

    @EnvironmentObject var adCoordinator: AdCoordinator

    @Binding var state: FullScreenState

    func makeUIView(context: Context) -> UIView {
        let nativeAdView = NativeCustomAdView()

        context.coordinator.nativeView = nativeAdView

        context.coordinator.adLoader = NativeAdLoader()
        context.coordinator.adLoader?.delegate = context.coordinator

        context.coordinator.adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.native.rawValue))

        return nativeAdView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

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

    class Coordinator: NSObject, NativeAdLoaderProtocol, NativeAdDelegate, ImageLoadingDelegate {

        // MARK: Properties

        var nativeView: NativeCustomAdView?
        
        var adLoader: NativeAdLoader?
        
        var parent: NativeUIKitView

        var loadAdClosure: (() -> Void)?

        private var ads = [NativeAd]()

        init(_ parent: NativeUIKitView) {
            self.parent = parent
        }

        func loadAd() {
            adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.native.rawValue))

            parent.state = .loading
        }

        // MARK: NativeAdLoaderProtocol

        func onAdsLoaded(loader: BuzzoolaAdsSDK.NativeAdLoader, ads: [any BuzzoolaAdsSDK.NativeAd]) {
            let ad = ads.first

            self.ads = ads
            ad?.delegate = self
            ad?.imageDelegate = self

            ad?.bindAd(nativeView!)
        }

        func onAdsFailed(loader: BuzzoolaAdsSDK.NativeAdLoader, adError: BuzzoolaAdsSDK.AdError) {
            parent.state = .error

            print("onAdsFailed", adError.errorDescription)
        }

        // MARK: NativeAdDelegate

        func onAdLoaded(_ ad: any BuzzoolaAdsSDK.NativeAd) {
            parent.state = .ready
            print("onAdLoaded")

            nativeView?.checkEmpty()
        }

        func onAdFailed(_ ad: any BuzzoolaAdsSDK.NativeAd, adError: BuzzoolaAdsSDK.AdError) {
            parent.state = .error

            print("onAdFailed", adError.errorDescription)
        }

        func onAdClicked(_ ad: any BuzzoolaAdsSDK.NativeAd) {
            print("onAdClicked")
        }

        func onCloseAd(_ ad: any BuzzoolaAdsSDK.NativeAd) {
            print("onCloseAd")

            parent.state = .close
        }

        func onLeftApplication(_ ad: any BuzzoolaAdsSDK.NativeAd) {
            print("onLeftApplication")
        }

        func onReturnedToApplication(_ ad: any BuzzoolaAdsSDK.NativeAd) {
            print("onReturnedToApplication")
        }

        func onImpression(_ ad: any BuzzoolaAdsSDK.NativeAd, _ data: String?) {
            print("onImpression", data ?? "")
        }

        // MARK: ImageLoadingDelegate

        func onImageLoaded(ad: any BuzzoolaAdsSDK.NativeAd, color: UIColor?) {
            nativeView?.media.backgroundColor = color
        }

        func onImageLoadFailed(ad: any BuzzoolaAdsSDK.NativeAd) {
            print("onImageLoadFailed")
        }
    }
}
