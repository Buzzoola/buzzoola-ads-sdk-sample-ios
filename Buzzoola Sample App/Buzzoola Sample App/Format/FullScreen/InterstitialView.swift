//
//  InterstitialView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK
import Combine

class AdCoordinator: ObservableObject {
    @Published var isLoading = true
    var showAdAction: (() -> Void)?
    var loadAdAction: (() -> Void)?
    var destroyAdAction: (() -> Void)?

    func showAd() {
        showAdAction?()
    }

    func loadAd() {
        loadAdAction?()
    }
    
    func destroyAd() {
        destroyAdAction?()
    }
}

enum FullScreenState {
    case loading
    case error
    case ready
    case close
}

struct InterstitialView: UIViewControllerRepresentable {

    @EnvironmentObject var adCoordinator: AdCoordinator

    @Binding var state: FullScreenState

    var onDismiss: (() -> Void)?

    class Coordinator: NSObject, ObservableObject, InterstitialAdLoaderProtocol, InterstitialAdDelegate {

        // MARK: Private properties

        var viewController: UIViewController?

        var adLoader: InterstitialAdLoader?

        private var interstitial: InterstitialAd?

        var parent: InterstitialView

        var showAdClosure: (() -> Void)?

        var loadAdClosure: (() -> Void)?

        init(_ parent: InterstitialView) {
            self.parent = parent
        }

        func showAd() {
            interstitial?.show(from: viewController ?? UIViewController())
        }

        func loadAd() {
            adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.native.rawValue))
            parent.state = .loading
        }

        // MARK: InterstitialAdLoaderProtocol

        func onAdLoaded(ad: any BuzzoolaAdsSDK.InterstitialAd) {
            parent.state = .ready

            interstitial = ad
            interstitial?.delegate = self

            print("onAdLoaded")
        }

        func onAdFailedToLoad(adError: BuzzoolaAdsSDK.AdError) {
            parent.state = .error

            print("onAdFailedToLoad", adError)
        }

        // MARK: InterstitialAdDelegate

        func onAdShown() {
            print("onAdShown")
        }

        func onAdFailed(adError: BuzzoolaAdsSDK.AdError) {
            print("onAdFailed", adError)
        }

        func onAdClicked() {
            print("onAdClicked")
        }

        func onAdDismissed() {
            parent.state = .close
            parent.onDismiss?()

            print("onAdDismissed")
        }

        func onImpression(_ data: String?) {
            print("onImpression", data)
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
        context.coordinator.adLoader = InterstitialAdLoader()
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
