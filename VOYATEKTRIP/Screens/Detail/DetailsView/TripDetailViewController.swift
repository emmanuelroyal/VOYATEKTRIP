//
//  TripDetailViewController.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//

import UIKit

class TripDetailViewController: UIViewController {
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    var trip: TripModel?
    
    // MARK: - UI Elements
    private let bannerImageView = UIImageView(image: UIImage(named: "trip.placeholder"))
    private let dateLabel = UILabel()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let buttonStack = UIStackView()
    private let activitiesStack = UIStackView()
    private let itineraryStack = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupScrollView()
        setupUI()
        populateData()
    }

    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupUI() {
        // Banner Image
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.clipsToBounds = true
        bannerImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(bannerImageView)

        NSLayoutConstraint.activate([
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 235)
        ])

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])

        // Date row
        let dateRow = UIStackView()
        dateRow.axis = .horizontal
        dateRow.spacing = 6
        let calendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
        calendarIcon.tintColor = .darkGray
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true

        dateLabel.font = .systemFont(ofSize: 13)
        dateRow.addArrangedSubview(calendarIcon)
        dateRow.addArrangedSubview(dateLabel)
        stack.addArrangedSubview(dateRow)

        // Title
        nameLabel.font = .boldSystemFont(ofSize: 15)
        stack.addArrangedSubview(nameLabel)

        // Subtitle
        subtitleLabel.font = .systemFont(ofSize: 12)
        subtitleLabel.textColor = UIColor.gray.withAlphaComponent(0.8)
        stack.addArrangedSubview(subtitleLabel)

        // Button Row
        buttonStack.axis = .horizontal
        buttonStack.spacing = 12
        stack.addArrangedSubview(buttonStack)
        
        let iteneraryHeaderTitleStack = UIStackView(arrangedSubviews: [dateRow, nameLabel, subtitleLabel, buttonStack])
        iteneraryHeaderTitleStack.axis = .vertical
        iteneraryHeaderTitleStack.spacing = 8

        stack.addArrangedSubview(iteneraryHeaderTitleStack)

        buttonStack.addArrangedSubview(makeOutlinedButton(title: "Trip Collaboration", icon: UIImage(named: "handshake")!))
        buttonStack.addArrangedSubview(makeOutlinedButton(title: "Share trip", icon: UIImage(named: "handshake")!))

        let moreButton = UIButton(type: .system)
        moreButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        moreButton.tintColor = .label
        buttonStack.addArrangedSubview(moreButton)

        // Activity Stack
        activitiesStack.axis = .vertical
        activitiesStack.spacing = 20
        stack.addArrangedSubview(activitiesStack)

        let cards: [(String, String, UIColor, String, Bool)] = [
            ("Activities", "Build, personalize, and explore your itinerary with our trip planner.", UIColor(red: 0.05, green: 0.1, blue: 0.4, alpha: 1), "Add Activities", false ),
            ("Hotels", "Build, personalize, and explore your itinerary with our trip planner.", UIColor.bgLightBlue, "Add Hotels", true),
            ("Flights", "Build, personalize, and explore your itinerary with our trip planner.", UIColor.systemBlue, "Add Flights", false)
        ]

        for (title, message, color, buttonTitle, labelColor) in cards {
            let card = ActivityCardView(title: title, message: message, backgroundColor: color, buttonTitle: buttonTitle, shouldDarkenLabelColor: labelColor)
            activitiesStack.addArrangedSubview(card)
        }

        // Itinerary Section
        let itineraryTitle = UILabel()
        itineraryTitle.font = .boldSystemFont(ofSize: 14)
        itineraryTitle.text = "Trip itineraries"

        let itinerarySubtitle = UILabel()
        itinerarySubtitle.font = .systemFont(ofSize: 12)
        itinerarySubtitle.textColor = .gray
        itinerarySubtitle.text = "Your trip itineraries are placed here"

        itineraryStack.axis = .vertical
        itineraryStack.spacing = 20
        

        let itineraryTitleStack = UIStackView(arrangedSubviews: [itineraryTitle, UIView()])
        itineraryTitleStack.axis = .horizontal
        
        let iteneraryMainTitleStack = UIStackView(arrangedSubviews: [itineraryTitleStack, itinerarySubtitle])
        iteneraryMainTitleStack.axis = .vertical
        iteneraryMainTitleStack.spacing = 8

        stack.addArrangedSubview(iteneraryMainTitleStack)
        stack.addArrangedSubview(itineraryStack)

        let itineraryCards: [(String, UIImage, UIImage, UIColor, Bool)] = [
            ("Flights", UIImage(systemName: "airplane")!, UIImage(named: "flight.placeholder")!, UIColor.systemGray5, true),
            ("Hotels", UIImage(systemName: "building.2")!, UIImage(named: "hotel.placeholder")!, UIColor.appGray, false),
            ("Activities", UIImage(systemName: "figure.walk")!, UIImage(named: "activity.placeholder")!, UIColor.systemBlue, false)
        ]

        for (title, icon, illustration, color, labelColor) in itineraryCards {
            let view = TripItineraryCardView(title: title, icon: icon, illustration: illustration, themeColor: color, shouldDarkenLabelColor: labelColor)
            itineraryStack.addArrangedSubview(view)
        }
    }

    private func makeOutlinedButton(title: String, icon: UIImage) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle("  \(title)", for: .normal)
        btn.setTitleColor(.systemBlue, for: .normal)
        btn.setImage(icon.withRenderingMode(.alwaysTemplate), for: .normal)
        btn.tintColor = .systemBlue
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemBlue.cgColor
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        btn.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        return btn
    }

    private func populateData() {
        guard let trip = trip else { return }
        dateLabel.text = "\(trip.startDate) → \(trip.endDate)"
        nameLabel.text = trip.tripName
        subtitleLabel.text = "\(trip.destination) | \(trip.travelStyle)"
    }
}
