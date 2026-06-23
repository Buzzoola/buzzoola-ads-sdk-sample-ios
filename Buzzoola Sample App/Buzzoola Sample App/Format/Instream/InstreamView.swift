//
//  InstreamView.swift
//  BuzzoolaSampleApp
//

import AVKit
import SwiftUI

struct InstreamView: View {

    @State private var state: FullScreenState = .loading

    @State private var showAd = true

    @State private var isVideoFinished = false

    @StateObject private var adCoordinator = AdCoordinator()

    @State private var player = AVPlayer()

    private let videoURL = URL(string: "https://tube.buzzoola.com/xstatic/inapp-sdk/bird.mp4")!

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text("InStream реклама")
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

            Spacer()
            ZStack {
                VideoPlayer(player: player)
                    .frame(height: 204)
                    .opacity(state == .error ? 0 : 1)
                    .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { notification in
                        guard
                            let item = notification.object as? AVPlayerItem,
                            item == player.currentItem
                        else {
                            return
                        }

                        isVideoFinished = true
                    }

                switch state {
                case .loading:
                    VStack {
                        SpinnerView()
                    }
                case .ready, .close:
                    VStack {}
                case .error:
                    VStack {
                        Image("error")
                        Text("Ошибка! Не удалось\nзагрузить рекламу :(")
                            .foregroundColor(Constants.Description.foregroundColor)
                            .font(Constants.Description.textFont)
                    }
                }

                if showAd {
                    InstreamUIKitView(
                        state: $state,
                        onAdComplete: {
                            if state == .ready {
                                showAd = false

                                let playerItem = AVPlayerItem(url: videoURL)
                                player.replaceCurrentItem(with: playerItem)
                                player.seek(to: .zero)
                                player.play()
                            }
                        }
                    )
                    .opacity(state == .ready || state == .loading ? 1 : 0)
                    .frame(height: 204)
                    .environmentObject(adCoordinator)
                }

                if isVideoFinished {
                    Button(action: {
                        isVideoFinished = false
                        player.seek(to: .zero)
                        player.play()
                    }) {
                        Image(systemName: "play.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black)
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.horizontal, 8)
            
            Spacer()
            if state == .error {
                HStack(spacing: 8) {
                    Button(action: {
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
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .background(Color("backgroundMain"))
        .onDisappear {
            player.pause()
        }
    }
}

// MARK: - Constants

private extension InstreamView {

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
    }
}
