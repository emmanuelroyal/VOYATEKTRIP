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
    private let mainStackView = UIStackView()

    private let travelStyles = TravelStyleEnum.allCases.map { $0.rawValue }


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
           view.addSubview(scrollView)
           scrollView.addSubview(contentView)
           contentView.addSubview(mainStackView)

           scrollView.translatesAutoresizingMaskIntoConstraints = false
           contentView.translatesAutoresizingMaskIntoConstraints = false
           mainStackView.translatesAutoresizingMaskIntoConstraints = false

           scrollView.keyboardDismissMode = .interactive
           mainStackView.axis = .vertical
           mainStackView.spacing = 24
           mainStackView.alignment = .fill
           mainStackView.distribution = .fill

           // Basic layout config
           view.backgroundColor = .white

           closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
           closeButton.tintColor = .black
           closeButton.contentHorizontalAlignment = .right
           closeButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)

           iconImageView.image = UIImage(named: "treepalm.icon") ?? UIImage(systemName: "airplane.circle")
           iconImageView.contentMode = .scaleAspectFit
           iconImageView.tintColor = .systemBlue
           iconImageView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
           iconImageView.layer.cornerRadius = 8
           iconImageView.clipsToBounds = true
           iconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true

           let iconStack = UIStackView()
           iconStack.axis = .horizontal
           iconStack.alignment = .center
           iconStack.distribution = .fill
           iconStack.spacing = 0

           let spacer = UIView()
           spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
           spacer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

           iconImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
           iconImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
           
           iconStack.addArrangedSubview(iconImageView)
           iconStack.addArrangedSubview(spacer)
           
           
           titleLabel.text = "Create a Trip"
           titleLabel.font = .boldSystemFont(ofSize: 22)

           subtitleLabel.text = "Let's Go! Build Your Next Adventure"
           subtitleLabel.font = .systemFont(ofSize: 14)
           subtitleLabel.textColor = .gray

           tripNameField.placeholder = "Enter the trip name"
           tripNameField.borderStyle = .roundedRect
           tripNameField.heightAnchor.constraint(equalToConstant: 44).isActive = true
           tripNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)

           setupTravelStyleButton()
           travelStyleButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

           tripDescriptionView.layer.borderColor = UIColor.systemGray4.cgColor
           tripDescriptionView.layer.borderWidth = 1
           tripDescriptionView.layer.cornerRadius = 8
           tripDescriptionView.text = "Tell us more about the trip"
           tripDescriptionView.textColor = .placeholderText
           tripDescriptionView.font = .systemFont(ofSize: 16)
           tripDescriptionView.delegate = self
           tripDescriptionView.heightAnchor.constraint(equalToConstant: 100).isActive = true

           nextButton.setTitle("Next", for: .normal)
           nextButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.3)
           nextButton.setTitleColor(.white, for: .normal)
           nextButton.layer.cornerRadius = 8
           nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
           nextButton.isEnabled = false
           nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)

           // Add all arranged subviews
           [
               closeButton,
               iconStack,
               titleLabel,
               subtitleLabel,
               tripNameStack,
               travelStyleStack,
               descriptionStack,
               nextButton
           ].forEach {
               $0.translatesAutoresizingMaskIntoConstraints = false
               mainStackView.addArrangedSubview($0)
           }

           // Stack contents
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

            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
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
