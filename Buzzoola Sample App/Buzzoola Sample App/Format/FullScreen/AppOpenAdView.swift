//
//  AppOpenAdView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK
import Combine

struct AppOpenView: UIViewControllerRepresentable {

    @EnvironmentObject var adCoordinator: AdCoordinator

    @Binding var state: FullScreenState

    var onDismiss: (() -> Void)?

    class Coordinator: NSObject, ObservableObject, AppOpenAdLoaderProtocol, AppOpenAdDelegate {

        // MARK: Private properties

        var viewController: UIViewController?

        var adLoader: AppOpenAdLoader?

        private var appOpenAd: AppOpenAd?

        var parent: AppOpenView

        var showAdClosure: (() -> Void)?

        var loadAdClosure: (() -> Void)?

        init(_ parent: AppOpenView) {
            self.parent = parent
        }

        func showAd() {
            appOpenAd?.show(from: viewController ?? UIViewController())
        }

        func loadAd() {
            adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.native.rawValue))
            parent.state = .loading
        }

        // MARK: AppOpenAdLoaderProtocol

        func onAdLoaded(ad: any BuzzoolaAdsSDK.AppOpenAd) {
            parent.state = .ready

            appOpenAd = ad
            appOpenAd?.delegate = self

            print("onAdLoaded")
        }

        func onAdFailedToLoad(adError: BuzzoolaAdsSDK.AdError) {
            parent.state = .error

            print("onAdFailedToLoad", adError)
        }

        // MARK: AppOpenAdDelegate

        func appOpenAdDidShow() {
            print("appOpenAdDidShow")
        }

        func appOpenAd(didFailToShowWithError error: AdError) {
            print("didFailToShowWithError ", error.errorDescription)
        }

        func appOpenAdDidClick() {
            print("appOpenAdDidClick")
        }

        func appOpenAdDidDismiss() {
            parent.state = .close
            parent.onDismiss?()

            print("appOpenAdDidDismiss")
        }

        func appOpenAd(didTrackImpressionWith impressionData: String?) {
            print("didTrackImpressionWith ", impressionData ?? "nil")
        }
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)

        coordinator.showAdClosure = { [weak coordinator] in
            coordinator?.showAd()
        }

        coordinator.loadAdClosure = { [weak coordinator] in
            coordinator?.loadAd()
        }

        return coordinator
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        context.coordinator.viewController = controller
        context.coordinator.adLoader = AppOpenAdLoader()
        context.coordinator.adLoader?.delegate = context.coordinator

        context.coordinator.adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.native.rawValue))

        adCoordinator.showAdAction = { [weak coordinator = context.coordinator] in
            coordinator?.showAdClosure?()
        }

        adCoordinator.loadAdAction = { [weak coordinator = context.coordinator] in
            coordinator?.loadAdClosure?()
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

