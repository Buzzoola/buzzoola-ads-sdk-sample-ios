//
//  NativeCustomAdView.swift
//  BuzzoolaSampleApp
//

import UIKit
import BuzzoolaAdsSDK

final class NativeCustomAdView: NativeAdView {

    private let title: UILabel = {
        let label = UILabel()

        label.textColor = Constants.TitleLabel.textColor
        label.font = Constants.TitleLabel.font

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let domain: UILabel = {
        let label = UILabel()

        label.textColor = Constants.DomainLabel.textColor
        label.font = Constants.DomainLabel.font

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let age: UILabel = {
        let label = PaddingLabel()

        label.textColor = Constants.BadgeLabel.textColor
        label.font = Constants.BadgeLabel.font
        label.layer.cornerRadius = Constants.cornerRadius
        label.layer.masksToBounds = true
        label.backgroundColor = Constants.BadgeLabel.color
        label.textAlignment = .center
        label.padding(4, 4, 8, 8)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sponsored: UILabel = {
        let label = PaddingLabel()

        label.textColor = Constants.BadgeLabel.textColor
        label.font = Constants.BadgeLabel.font
        label.layer.cornerRadius = Constants.cornerRadius
        label.layer.masksToBounds = true
        label.backgroundColor = Constants.BadgeLabel.color
        label.textAlignment = .center
        label.padding(4, 4, 8, 8)

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let feedback: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let callToAction: UIButton = {
        let button = UIButton()

        button.setTitleColor(Constants.ActionButton.textColor, for: .normal)
        button.titleLabel?.font = Constants.ActionButton.font
        button.backgroundColor = Constants.ActionButton.color
        button.layer.cornerRadius = Constants.cornerRadius

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let media: NativeMediaView = {
        let mediaView = NativeMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }()

    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let body: UILabel = {
        let label = UILabel()

        label.textColor = Constants.DescriptionLabel.textColor
        label.font = Constants.DescriptionLabel.font

        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = Constants.smallMargin
        return stack
    }()

    private let bottomView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let bottomStackLeft: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = Constants.smallMargin
        return stack
    }()

    private let bottomStackRight: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = Constants.bottomRightStackViewMargin
        return stack
    }()

    init() {
        super.init(frame: .zero)

        addSubviews()
        setupConstraints()
        bindAssets()
    }

    required init?(coder: NSCoder) {
        fatalError("Please use this class from code.")
    }

    private func addSubviews() {
        addSubview(media)
        addSubview(title)
        addSubview(body)
        addSubview(stack)

        stack.addArrangedSubview(bottomView)

        bottomView.addSubview(bottomStackLeft)
        bottomView.addSubview(bottomStackRight)

        bottomStackLeft.addArrangedSubview(sponsored)
        bottomStackLeft.addArrangedSubview(age)
        bottomStackLeft.addArrangedSubview(iconImage)
        bottomStackLeft.addArrangedSubview(domain)

        bottomStackRight.addArrangedSubview(callToAction)
        bottomStackRight.addArrangedSubview(feedback)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            media.topAnchor.constraint(equalTo: topAnchor),
            media.leftAnchor.constraint(equalTo: leftAnchor),
            media.rightAnchor.constraint(equalTo: rightAnchor),

            title.topAnchor.constraint(equalTo: media.bottomAnchor, constant: 8),
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.offset),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.offset),

            body.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4),
            body.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.offset),
            body.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.offset),

            stack.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: Constants.offset),
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -Constants.offset),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),

            bottomStackLeft.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomStackLeft.leftAnchor.constraint(equalTo: bottomView.leftAnchor),
            bottomStackLeft.rightAnchor.constraint(lessThanOrEqualTo: bottomStackRight.leftAnchor),
            bottomStackLeft.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),

            bottomStackRight.topAnchor.constraint(equalTo: bottomView.topAnchor),
            bottomStackRight.rightAnchor.constraint(equalTo: bottomView.rightAnchor),
            bottomStackRight.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor),

            media.heightAnchor.constraint(equalToConstant: 140),

            callToAction.heightAnchor.constraint(equalToConstant: 24),
            callToAction.widthAnchor.constraint(equalToConstant: 71),

            feedback.widthAnchor.constraint(equalToConstant: 24),
            feedback.heightAnchor.constraint(equalToConstant: 24),

            iconImage.widthAnchor.constraint(equalToConstant: 12),
            iconImage.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    private func bindAssets() {
        adTitle = title
        adDomain = domain
        adBadge = sponsored
        adInfo = feedback
        adActionBtn = callToAction
        adMedia = media
        adDescription = body
        adIcon = iconImage
        adAge = age
    }

    func checkEmpty() {
        age.isHidden = !(age.text?.isEmpty == false)
        body.isHidden = !(body.text?.isEmpty == false)
    }
}

//MARK: - Constants

private extension NativeCustomAdView {

    enum Constants {
        static let offset: CGFloat = 16
        static let smallMargin: CGFloat = 4
        static let bigMargin: CGFloat = 8
        static let cornerRadius: CGFloat = 8
        static let bottomRightStackViewMargin: CGFloat = 12

        enum TitleLabel {
            static let textColor = UIColor(red: 29, green: 32, blue: 35)
            static let font = UIFont(name: "Inter24pt-Medium", size: 16)
        }

        enum DescriptionLabel {
            static let textColor = UIColor(red: 98, green: 108, blue: 119)
            static let font = UIFont(name: "Inter24pt-Regular", size: 14)
        }

        enum BadgeLabel {
            static let textColor = UIColor(red: 150, green: 159, blue: 168)
            static let font = UIFont(name: "Inter24pt-Regular", size: 8)
            static let color = UIColor(red: 242, green: 243, blue: 247)
        }

        enum DomainLabel {
            static let textColor = UIColor(red: 150, green: 159, blue: 168)
            static let font = UIFont(name: "Inter24pt-Regular", size: 12)
        }

        enum PriceLabel {
            static let textColor = UIColor.white
            static let font = UIFont(name: "Inter24pt-Regular", size: 10)
            static let color = UIColor(red: 29, green: 32, blue: 35).withAlphaComponent(0.4)
        }

        enum ActionButton {
            static let color = UIColor(named: "primaryLink")
            static let textColor = UIColor.white
            static let font = UIFont(name: "Inter24pt-Regular", size: 12)
        }
    }
}
