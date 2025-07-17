//
//  TripCollectionCell.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//

import UIKit

class TripCollectionCell: UICollectionViewCell {

    @IBOutlet weak var tripImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var viewLabel: UIView!

    private var buttonAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Configure
    func configure(with trip: TripModel, action: @escaping () -> Void) {
        tripImageView.image = UIImage(named: trip.imageUrl ?? "trip.placeholder2")
        locationLabel.text = trip.destination
        titleLabel.text = trip.tripName
        dateLabel.text = formattedDate(from: trip.startDate)
        daysLabel.text = "\(trip.noOfDays) day(s)"
        buttonAction = action
    }
    
    
    // MARK: - Actions
    @IBAction func didTapViewButton(_ sender: UIButton) {
        buttonAction?()
    }
    
    func formattedDate(from dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = formatter.date(from: dateString) {
            return date.formattedWithSuffix()
        } else {
            return dateString // fallback if parsing fails
        }
    }

    private func setupUI() {
        contentView.layer.cornerRadius = 4
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        contentView.clipsToBounds = true

        tripImageView.contentMode = .scaleToFill
        tripImageView.clipsToBounds = true

        viewLabel.backgroundColor = UIColor.black.withAlphaComponent(0.5)

        viewButton.setTitle("View", for: .normal)
        viewButton.backgroundColor = .systemBlue
        viewButton.tintColor = .white
        viewButton.layer.cornerRadius = 6
    }
}
