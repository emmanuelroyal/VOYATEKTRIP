//
//  CityCell.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import UIKit

class CityCell: UITableViewCell {

    let iconImageView = UIImageView()
    let cityLabel = UILabel()
    let subtitleLabel = UILabel()
    let flagImageView = UIImageView()
    let countryCodeLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupUI() {
        iconImageView.image = UIImage(named: "location.gray")
        iconImageView.tintColor = .gray

        cityLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .darkGray

        countryCodeLabel.font = .systemFont(ofSize: 12)

        [iconImageView, cityLabel, subtitleLabel, flagImageView, countryCodeLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),

            cityLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),

            subtitleLabel.leadingAnchor.constraint(equalTo: cityLabel.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4),

            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 30),
            flagImageView.heightAnchor.constraint(equalToConstant: 20),

            countryCodeLabel.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 4),
            countryCodeLabel.centerXAnchor.constraint(equalTo: flagImageView.centerXAnchor)
        ])
    }

    func configure(with location: Location?) {
        cityLabel.text = location?.location
        subtitleLabel.text = location?.city
        flagImageView.image = UIImage(named: location?.countryImageUrl ?? "")
        countryCodeLabel.text = location?.initials
    }
}
