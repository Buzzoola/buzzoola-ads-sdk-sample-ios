//
//  PreviewImageView.swift
//  BuzzoolaSampleApp
//

import SwiftUI
import BuzzoolaAdsSDK

struct PreviewImageView: View {

    var image: String
    var title: String
    var description: String

    var body: some View {
        VStack {
            Image(image)
                .padding()
            Text(title)
                .foregroundColor(Constants.Title.foregroundColor)
                .font(Constants.Title.textFont)
                .multilineTextAlignment(.center)
                .padding(.top, 8)
                .padding(.bottom, 2)
            Text(description)
                .foregroundColor(Constants.Description.foregroundColor)
                .font(Constants.Description.textFont)
                .multilineTextAlignment(.center)
                .padding(.bottom, 24)
        }
    }
}

// MARK: - Constants

private extension PreviewImageView {

    enum Constants {

        enum Title {
            static let foregroundColor = Color("primary")
            static let textFont: Font = .custom("Inter24pt-Medium", size: 20)
        }

        enum Description {
            static let foregroundColor = Color("tertiary")
            static let textFont: Font = .custom("Inter24pt-Regular", size: 12)
        }
    }
}
