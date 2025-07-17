//
//  CreateTripViewController.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//

import UIKit


protocol CreateTripViewDelegate: AnyObject {
    func getTrip(trip: TripModel?)
}

class CreateTripViewController: UIViewController {

    // MARK: - Properties

    weak var delegate: CreateTripViewDelegate?
    var viewModel: CreateTripViewModel?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let containerView = UIView()

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tripNameField = UITextField()
    private let travelStyleButton = UIButton(type: .system)
    private let tripDescriptionView = UITextView()
    private let nextButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)

    private let tripNameStack = UIStackView()
    private let travelStyleStack = UIStackView()
    private let descriptionStack = UIStackView()

    private let travelStyles = TravelStyleEnum.allCases.map { $0.rawValue }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupUI()
        setupConstraints()
        setupBindings()
    }
}


   private extension CreateTripViewController {
    
    func setupUI() {
        // ScrollView hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(containerView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false

        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 16
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 10

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

        iconImageView.image = UIImage(named: "treepalm.icon") ?? UIImage(systemName: "airplane")
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .systemBlue
        iconImageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        iconImageView.layer.cornerRadius = 8
        iconImageView.clipsToBounds = true

        titleLabel.text = "Create a Trip"
        titleLabel.font = .boldSystemFont(ofSize: 22)

        subtitleLabel.text = "Let's Go! Build Your Next Adventure"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .gray

        tripNameField.placeholder = "Enter the trip name"
        tripNameField.borderStyle = .roundedRect
        tripNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

        setupTravelStyleButton()

        tripDescriptionView.layer.borderColor = UIColor.systemGray4.cgColor
        tripDescriptionView.layer.borderWidth = 1
        tripDescriptionView.layer.cornerRadius = 8
        tripDescriptionView.text = "Tell us more about the trip"
        tripDescriptionView.textColor = .placeholderText
        tripDescriptionView.font = .systemFont(ofSize: 16)
        tripDescriptionView.delegate = self

        tripNameStack.axis = .vertical
        tripNameStack.spacing = 6
        tripNameStack.addArrangedSubview(makeInputLabel(text: "Trip Name"))
        tripNameStack.addArrangedSubview(tripNameField)

        travelStyleStack.axis = .vertical
        travelStyleStack.spacing = 6
        travelStyleStack.addArrangedSubview(makeInputLabel(text: "Travel Style"))
        travelStyleStack.addArrangedSubview(travelStyleButton)

        descriptionStack.axis = .vertical
        descriptionStack.spacing = 6
        descriptionStack.addArrangedSubview(makeInputLabel(text: "Trip Description"))
        descriptionStack.addArrangedSubview(tripDescriptionView)

        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.layer.cornerRadius = 8
        nextButton.isEnabled = false
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

        // Add to containerView
        [closeButton, iconImageView, titleLabel, subtitleLabel, tripNameStack,
         travelStyleStack, descriptionStack, nextButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
    }

    func setupTravelStyleButton() {
        travelStyleButton.setTitle("Select your travel style", for: .normal)
        travelStyleButton.setTitleColor(.lightGray, for: .normal)
        travelStyleButton.titleLabel?.font = .systemFont(ofSize: 16)
        travelStyleButton.backgroundColor = UIColor.white
        travelStyleButton.layer.cornerRadius = 8
        travelStyleButton.layer.borderColor = UIColor.systemGray6.cgColor
        travelStyleButton.layer.borderWidth = 1
        travelStyleButton.contentHorizontalAlignment = .left
        travelStyleButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)

        let menuItems = travelStyles.map { style in
            UIAction(title: style) { [weak self] _ in
                self?.travelStyleButton.setTitle(style, for: .normal)
                self?.travelStyleButton.setTitleColor(.black, for: .normal)
                self?.viewModel?.trip.travelStyle = style
                self?.validateForm()
            }
        }

        travelStyleButton.menu = UIMenu(title: "Choose your travel style", options: .displayInline, children: menuItems)
        travelStyleButton.showsMenuAsPrimaryAction = true
    }

    func makeInputLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .darkGray
        return label
    }

    func setupBindings() {
        validateForm()
    }
}



private extension CreateTripViewController {
    func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24),

            iconImageView.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 16),
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 44),
            iconImageView.heightAnchor.constraint(equalToConstant: 44),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: iconImageView.leadingAnchor),

            tripNameStack.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 30),
            tripNameStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            tripNameStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            tripNameField.heightAnchor.constraint(equalToConstant: 44),

            travelStyleStack.topAnchor.constraint(equalTo: tripNameStack.bottomAnchor, constant: 20),
            travelStyleStack.leadingAnchor.constraint(equalTo: tripNameStack.leadingAnchor),
            travelStyleStack.trailingAnchor.constraint(equalTo: tripNameStack.trailingAnchor),
            travelStyleButton.heightAnchor.constraint(equalToConstant: 44),

            descriptionStack.topAnchor.constraint(equalTo: travelStyleStack.bottomAnchor, constant: 20),
            descriptionStack.leadingAnchor.constraint(equalTo: tripNameStack.leadingAnchor),
            descriptionStack.trailingAnchor.constraint(equalTo: tripNameStack.trailingAnchor),
            tripDescriptionView.heightAnchor.constraint(equalToConstant: 100),

            nextButton.topAnchor.constraint(equalTo: descriptionStack.bottomAnchor, constant: 40),
            nextButton.leadingAnchor.constraint(equalTo: tripNameStack.leadingAnchor),
            nextButton.trailingAnchor.constraint(equalTo: tripNameStack.trailingAnchor),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            nextButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -40)
        ])
    }
}



extension CreateTripViewController: UITextViewDelegate {

    @objc private func dismissSelf() {
        dismiss(animated: true)
    }

    @objc private func textFieldChanged() {
        viewModel?.trip.tripName = tripNameField.text ?? ""
        validateForm()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = "Tell us more about the trip"
            textView.textColor = .placeholderText
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.textColor != .placeholderText {
            viewModel?.trip.description = textView.text
            validateForm()
        }
    }

    @objc private func nextTapped() {
        delegate?.getTrip(trip: viewModel?.trip)
        dismiss(animated: true)
    }

    private func validateForm() {
        viewModel?.trip.tripName = tripNameField.text ?? ""
        viewModel?.trip.travelStyle = travelStyleButton.title(for: .normal) ?? ""

        let desc = tripDescriptionView.text == "Tell us more about the trip" ? "" : tripDescriptionView.text
        viewModel?.trip.description = desc?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        viewModel?.updateFormValidity()

        nextButton.isEnabled = viewModel?.formIsValid == true
        nextButton.backgroundColor = viewModel?.formIsValid == true ? .systemBlue : UIColor.systemBlue.withAlphaComponent(0.3)
    }
}
