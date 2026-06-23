//
//  InstreamCustomPlayerView.swift
//  BuzzoolaSampleApp
//

import BuzzoolaAdsSDK

final class InstreamCustomPlayerView: InstreamPlayerView {

    private let badgeLabel: UILabel = {
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

    private let infoButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "infoDialog"), for: .normal)
        return button
    }()

    let soundButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false

        button.setImage(UIImage(named: "soundOff"), for: .normal)
        button.setImage(UIImage(named: "soundOn"), for: .selected)

        return button
    }()

    private let media: InstreamMediaView = {
        let mediaView = InstreamMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }()

    private let actionButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(Constants.ActionButton.textColor, for: .normal)
        button.titleLabel?.font = Constants.ActionButton.font
        button.backgroundColor = Constants.ActionButton.color
        button.layer.cornerRadius = Constants.cornerRadius

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    let skipButton: UIButton = {
        let button = UIButton()

        button.setTitleColor(Constants.ActionButton.textColor, for: .normal)
        button.titleLabel?.font = Constants.ActionButton.font
        button.backgroundColor = Constants.ActionButton.color
        button.layer.cornerRadius = Constants.cornerRadius
        button.setTitle("Пропустить", for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let overlay: UIView = {
        let overlayView = UIView()

        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()

    let timerLabel: UILabel = {
        let timer = PaddingLabel()

        timer.textColor = Constants.BadgeLabel.textColor
        timer.font = Constants.TimerLabel.font
        timer.layer.cornerRadius = Constants.cornerRadius
        timer.layer.masksToBounds = true
        timer.backgroundColor = Constants.BadgeLabel.color
        timer.textAlignment = .center
        timer.padding(4, 4, 8, 8)

        timer.translatesAutoresizingMaskIntoConstraints = false
        return timer
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
}

//MARK: - Private functions

private extension InstreamCustomPlayerView {

    func addSubviews() {
        addSubview(media)
        media.addSubview(overlay)

        overlay.addSubview(badgeLabel)
        overlay.addSubview(actionButton)
        overlay.addSubview(infoButton)
        overlay.addSubview(timerLabel)
        overlay.addSubview(skipButton)
        overlay.addSubview(soundButton)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            media.topAnchor.constraint(equalTo: topAnchor),
            media.leftAnchor.constraint(equalTo: leftAnchor),
            media.rightAnchor.constraint(equalTo: rightAnchor),
            media.bottomAnchor.constraint(equalTo: bottomAnchor),

            overlay.topAnchor.constraint(equalTo: media.topAnchor),
            overlay.leftAnchor.constraint(equalTo: media.leftAnchor),
            overlay.rightAnchor.constraint(equalTo: media.rightAnchor),
            overlay.bottomAnchor.constraint(equalTo: media.bottomAnchor),

            media.heightAnchor.constraint(equalToConstant: 150),

            badgeLabel.topAnchor.constraint(equalTo: overlay.topAnchor, constant: Constants.offset),
            badgeLabel.leftAnchor.constraint(equalTo: overlay.leftAnchor, constant: Constants.ActionButton.offset),

            infoButton.topAnchor.constraint(equalTo: overlay.topAnchor, constant: Constants.offset),
            infoButton.rightAnchor.constraint(equalTo: overlay.rightAnchor, constant: -Constants.offset),

            soundButton.rightAnchor.constraint(equalTo: infoButton.leftAnchor, constant: -Constants.offset),
            soundButton.centerYAnchor.constraint(equalTo: infoButton.centerYAnchor),

            actionButton.leftAnchor.constraint(equalTo: overlay.leftAnchor, constant: Constants.ActionButton.offset),
            actionButton.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -Constants.ActionButton.offset),

            timerLabel.rightAnchor.constraint(equalTo: overlay.rightAnchor, constant: -Constants.offset),
            timerLabel.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -Constants.ActionButton.offset),

            skipButton.rightAnchor.constraint(equalTo: overlay.rightAnchor, constant: -Constants.offset),
            skipButton.bottomAnchor.constraint(equalTo: overlay.bottomAnchor, constant: -Constants.ActionButton.offset),

            skipButton.heightAnchor.constraint(equalToConstant: 24),
            skipButton.widthAnchor.constraint(equalToConstant: 79),

            actionButton.heightAnchor.constraint(equalToConstant: 24),
            actionButton.widthAnchor.constraint(equalToConstant: 71),

            infoButton.widthAnchor.constraint(equalToConstant: 20),
            infoButton.heightAnchor.constraint(equalToConstant: 20),

            soundButton.widthAnchor.constraint(equalToConstant: 20),
            soundButton.heightAnchor.constraint(equalToConstant: 20)
        ])

        skipButton.isHidden = true
    }

    func bindAssets() {
        adBadge = badgeLabel
        adInfo = infoButton
        adActionBtn = actionButton
        adMedia = media
    }
}

//MARK: - Constants

private extension InstreamCustomPlayerView {

    enum Constants {
        static let offset: CGFloat = 8
        static let cornerRadius: CGFloat = 8

        enum BadgeLabel {
            static let textColor = UIColor(red: 255, green: 255, blue: 255)
            static let font = UIFont(name: "Inter24pt-Regular", size: 8)
            static let color = UIColor(red: 29, green: 32, blue: 35)
        }

        enum TimerLabel {
            static let font = UIFont(name: "Inter24pt-Regular", size: 12)
        }

        enum ActionButton {
            static let color = UIColor(named: "primaryLink")
            static let textColor = UIColor.white
            static let font = UIFont(name: "Inter24pt-Regular", size: 12)
            static let offset: CGFloat = 16
        }
    }
}
