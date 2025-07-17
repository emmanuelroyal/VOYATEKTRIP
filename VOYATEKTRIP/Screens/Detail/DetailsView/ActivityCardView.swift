//
//  ActivityCardView.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import UIKit

class ActivityCardView: UIView {
    init(title: String, message: String, backgroundColor: UIColor, buttonTitle: String, shouldDarkenLabelColor: Bool = false) {
            super.init(frame: .zero)
            setupUI(title: title, message: message, color: backgroundColor, buttonTitle: buttonTitle, shouldDarkenLabelColor: shouldDarkenLabelColor )
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func setupUI(title: String, message: String, color: UIColor, buttonTitle: String, shouldDarkenLabelColor: Bool) {
            self.backgroundColor = color
            self.layer.cornerRadius = 8
            self.translatesAutoresizingMaskIntoConstraints = false

            let titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.font = .boldSystemFont(ofSize: 16)
            titleLabel.textColor = shouldDarkenLabelColor ? .black : .white

            let messageLabel = UILabel()
            messageLabel.text = message
            messageLabel.font = .systemFont(ofSize: 12)
            messageLabel.textColor = shouldDarkenLabelColor ? .black : .white
            messageLabel.numberOfLines = 2

            let addButton = UIButton(type: .system)
            addButton.setTitle(buttonTitle, for: .normal)
            addButton.setTitleColor(color, for: .normal)
            addButton.backgroundColor = .white
            addButton.layer.cornerRadius = 6
            addButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            addButton.translatesAutoresizingMaskIntoConstraints = false
            addButton.heightAnchor.constraint(equalToConstant: 45).isActive = true

            let vStack = UIStackView(arrangedSubviews: [titleLabel, messageLabel, addButton])
            vStack.axis = .vertical
            vStack.spacing = 15
            vStack.translatesAutoresizingMaskIntoConstraints = false

            addSubview(vStack)

            NSLayoutConstraint.activate([
                vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
                vStack.centerYAnchor.constraint(equalTo: centerYAnchor),
                vStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
                        vStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            ])
        }
    }
