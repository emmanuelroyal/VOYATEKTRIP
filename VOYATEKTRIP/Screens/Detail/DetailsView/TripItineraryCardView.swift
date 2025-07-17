//
//  TripItineraryCardView.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import UIKit

class TripItineraryCardView: UIView {

    init(title: String, icon: UIImage, illustration: UIImage, themeColor: UIColor, shouldDarkenLabelColor: Bool = false) {
        super.init(frame: .zero)
        setupUI(title: title, icon: icon, illustration: illustration, themeColor: themeColor, shouldDarkenLabelColor: shouldDarkenLabelColor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI(title: String, icon: UIImage, illustration: UIImage, themeColor: UIColor, shouldDarkenLabelColor: Bool) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear

        // OUTER container to simulate border
        let outerContainer = UIView()
        outerContainer.translatesAutoresizingMaskIntoConstraints = false
        outerContainer.backgroundColor = themeColor
        outerContainer.layer.cornerRadius = 8
        outerContainer.clipsToBounds = true

        // INNER card (white background)
        let cardView = UIView()
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 12
        cardView.clipsToBounds = true

        // HEADER
        let headerView = UIView()
        headerView.backgroundColor = themeColor
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerView.layer.cornerRadius = 12
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.clipsToBounds = true

        let headerIcon = UIImageView(image: icon.withRenderingMode(.alwaysTemplate))
        headerIcon.tintColor = shouldDarkenLabelColor ? .black : .white
        headerIcon.contentMode = .scaleAspectFit
        headerIcon.translatesAutoresizingMaskIntoConstraints = false
        headerIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        headerIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true

        let headerLabel = UILabel()
        headerLabel.text = title
        headerLabel.font = .systemFont(ofSize: 13, weight: .medium)
        headerLabel.textColor = shouldDarkenLabelColor ? .black : .white

        let headerStack = UIStackView(arrangedSubviews: [headerIcon, headerLabel])
        headerStack.axis = .horizontal
        headerStack.spacing = 8
        headerStack.alignment = .center
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(headerStack)
        NSLayoutConstraint.activate([
            headerStack.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 12)
        ])

        // CONTENT
        let illustrationView = UIImageView(image: illustration)
        illustrationView.contentMode = .scaleAspectFit
        illustrationView.translatesAutoresizingMaskIntoConstraints = false
        illustrationView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        illustrationView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        let messageLabel = UILabel()
        messageLabel.text = "No request yet"
        messageLabel.font = .systemFont(ofSize: 14)
        messageLabel.textColor = .darkGray
        messageLabel.textAlignment = .center

        let actionButton = UIButton(type: .system)
        actionButton.setTitle("Add \(title)", for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .systemBlue
        actionButton.layer.cornerRadius = 8
        actionButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

        let contentStack = UIStackView(arrangedSubviews: [illustrationView, messageLabel, actionButton])
        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        let innerWrapper = UIView()
        innerWrapper.translatesAutoresizingMaskIntoConstraints = false
        innerWrapper.addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: innerWrapper.topAnchor, constant: 20),
            contentStack.leadingAnchor.constraint(equalTo: innerWrapper.leadingAnchor, constant: 16),
            contentStack.trailingAnchor.constraint(equalTo: innerWrapper.trailingAnchor, constant: -16),
            contentStack.bottomAnchor.constraint(equalTo: innerWrapper.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: contentStack.leadingAnchor),
            actionButton.trailingAnchor.constraint(equalTo: contentStack.trailingAnchor)
        ])

        let mainStack = UIStackView(arrangedSubviews: [headerView, innerWrapper])
        mainStack.axis = .vertical
        mainStack.spacing = 0
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(mainStack)
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: cardView.topAnchor),
            mainStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            mainStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor)
        ])

        outerContainer.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: outerContainer.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: outerContainer.leadingAnchor, constant: 10),
            cardView.trailingAnchor.constraint(equalTo: outerContainer.trailingAnchor, constant: -10),
            cardView.bottomAnchor.constraint(equalTo: outerContainer.bottomAnchor, constant: -10)
        ])

        // Add outerContainer to self
        addSubview(outerContainer)
        NSLayoutConstraint.activate([
            outerContainer.topAnchor.constraint(equalTo: topAnchor),
            outerContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            outerContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            outerContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
