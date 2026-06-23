//
//  InstreamUIKitView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct InstreamUIKitView: UIViewRepresentable {

    @Binding var state: FullScreenState

    @EnvironmentObject var adCoordinator: AdCoordinator

    let onAdComplete: (() -> Void)

    func makeUIView(context: Context) -> UIView {
        let instreamView = InstreamCustomPlayerView()

        context.coordinator.instreamView = instreamView

        instreamView.isHidden = true

        context.coordinator.adLoader = InstreamAdLoader()
        context.coordinator.adLoader?.delegate = context.coordinator

        context.coordinator.adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.instream.rawValue))

        return instreamView
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

    class Coordinator: NSObject, InstreamAdLoaderProtocol, InstreamAdPlaybackDelegate {

        // MARK: Properties

        var instreamView: InstreamCustomPlayerView?

        var adLoader: InstreamAdLoader?

        var parent: InstreamUIKitView

        var loadAdClosure: (() -> Void)?

        private var ads = [InstreamAd]()

        init(_ parent: InstreamUIKitView) {
            self.parent = parent
        }

        func loadAd() {
            instreamView?.soundButton.isSelected = false
            instreamView?.timerLabel.isHidden = true

            ads.forEach { $0.stop() }
            ads.removeAll()

            adLoader?.loadAd(request: AdsRequest(placementID: PlacementID.instream.rawValue))

            parent.state = .loading
        }

        // MARK: InstreamAdLoaderProtocol

        func onAdLoaded(ad: InstreamAd) {
            print("onAdsLoaded")

            parent.state = .ready

            ad.playbackDelegate = self

            instreamView?.isHidden = false
            instreamView?.skipButton.addTarget(self, action: #selector(skipButtonTouched), for: .touchUpInside)
            instreamView?.soundButton.addTarget(self, action: #selector(soundButtonTouched), for: .touchUpInside)

            ad.attachPlayerView(instreamView!)
            ad.start()

            self.ads.append(ad)
        }

        func onAdFailed(adError: BuzzoolaAdsSDK.AdError) {
            parent.state = .error

            print("onAdFailed", adError.errorDescription)
        }

        // MARK: InstreamAdPlaybackDelegate

        func onComplete() {
            print("onComplete")

            parent.onAdComplete()
        }

        func onFailed(adError: BuzzoolaAdsSDK.AdError) {
            parent.state = .error

            print("onFailed", adError.errorDescription)
        }

        func onStarted() {
            print("onStarted")
        }

        func onVideoAdStarted(video: any BuzzoolaAdsSDK.VideoAd) {
            print("onVideoAdStarted")
        }

        func onVideoAdTimeLeftChange(video: any BuzzoolaAdsSDK.VideoAd, timeLeft: Float) {
            guard
                let instreamView
            else {
                return
            }

            instreamView.timerLabel.isHidden = false

            instreamView.timerLabel.text = String(Int(timeLeft - (video.duration - video.skipOffset)))

            if Int(timeLeft) <= Int(video.duration - video.skipOffset) {
                instreamView.timerLabel.isHidden = true
                instreamView.skipButton.isHidden = false
            } else {
                instreamView.timerLabel.isHidden = false
                instreamView.skipButton.isHidden = true
            }
        }

        func onVideoAdCompleted(video: any BuzzoolaAdsSDK.VideoAd) {
            print("onVideoAdCompleted")
        }

        func onVideoAdPaused(video: any BuzzoolaAdsSDK.VideoAd) {
            print("onVideoAdPaused")
        }

        func onVideoAdResumed(video: any BuzzoolaAdsSDK.VideoAd) {
            print("onVideoAdResumed")
        }

        func onVideoAdError(video: any BuzzoolaAdsSDK.VideoAd, error: String) {
            print("onVideoAdError", error)
        }

        func onVideoAdImpression(video: any BuzzoolaAdsSDK.VideoAd) {
            print("onVideoAdImpression")
        }

        func onVideoAdClicked(video: any BuzzoolaAdsSDK.VideoAd) {
            print("onVideoAdClicked")
        }

        // MARK: Actions

        @objc
        func skipButtonTouched() {
            ads.first?.skip()

            parent.state = .close
        }

        @objc
        func soundButtonTouched() {
            guard
                let instreamView
            else {
                return
            }

            instreamView.soundButton.isSelected = !instreamView.soundButton.isSelected

            if instreamView.soundButton.isSelected {
                ads.first?.setVolume(volume: 1.0)
            } else {
                ads.first?.setVolume(volume: 0.0)
            }
        }
    }
}
