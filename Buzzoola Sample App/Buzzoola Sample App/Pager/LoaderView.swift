//
//  LoaderView.swift
//  BuzzoolaSampleApp
//

import SwiftUI

struct LoaderView: View {

    var body: some View {
        ZStack {
            Image("buzzIcon")
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("backgroundMain"))
        .ignoresSafeArea()
    }
}

// MARK: - Constants

private extension LoaderView {

    enum Constants {

        enum Header {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-SemiBold", size: 24)
        }
    }
}
