//
//  BuzzoolaSampleApp.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK
import Combine

class AppState: ObservableObject {
    @Published var isAdsConfigured = false
}

@main
struct BuzzoolaSampleApp: App {

    @StateObject private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            if appState.isAdsConfigured {
                ContentView()
            } else {
                LoaderView().onAppear(perform: {
                    Ads().configure {
                        Ads().enableLogging(true)
                        appState.isAdsConfigured = true
                    }
                })
            }
        }
    }
}
