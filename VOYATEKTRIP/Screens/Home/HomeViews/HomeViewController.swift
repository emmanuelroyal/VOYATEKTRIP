//
//  ViewController.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//

import UIKit

class HomeViewController: UIViewController, CreateTripViewDelegate, TripViewModelDelegate {
    func didStartLoading() {
        DispatchQueue.main.async {
            self.loader.startAnimating()
            self.view.isUserInteractionEnabled = false
        }
    }

    func didFinishLoading() {
        DispatchQueue.main.async {
            self.loader.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }

    func didUpdateTrips(_ trips: [TripModel]) {
        DispatchQueue.main.async {
            self.trips = trips
            self.reloadTrips()
        }
    }

    fileprivate func cleanUI() {
        viewModel.trip = TripModel()
        self.startDateLabel.text = ""
        self.endDateLabel.text = ""
        self.selectedCityLabel.text = ""
        self.enableCreateTrip = false
        self.setCreateTripBtnEnabled(self.enableCreateTrip)
    }
    
    func didCreateTripSuccessfully(_ trip: TripResponse) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Trip Created",
                message: "Successfully created \(trip.tripName ?? "your trip")",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
        cleanUI()
    }

    func didFailWithError(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Error",
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }

    
    func getTrip(trip: TripModel?) {
        if let trip = trip {
            viewModel.trip = trip
            viewModel.createTrip()
        }
    }
    
    
    @IBOutlet weak var tripCollectionView: UICollectionView!
    @IBOutlet weak var tripCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedCityLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var selectedCityView: TapView!
    @IBOutlet weak var startDateView: TapView!
    @IBOutlet weak var endDateView: TapView!
    @IBOutlet weak var createTripBtn: UIButton!
    
    var viewModel = TripViewModel()
    private let itemHeight: CGFloat = 400
    private let lineSpacing: CGFloat = 16
    
    private var trips: [TripModel] = []
    var enableCreateTrip: Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        self.setCreateTripBtnEnabled(self.enableCreateTrip)
        tripCollectionView.delegate = self
        tripCollectionView.dataSource = self
        tripCollectionView.clipsToBounds = true
        startDateView.addTap {
            self.showDatePicker(dateType: .start)
        }
        
        endDateView.addTap {
            self.showDatePicker(dateType: .end)
        }
        
        selectedCityView.addTap {
            self.citySelectionButtonTapped()
        }
        viewModel.delegate = self
        
        viewModel.fetchTrips()
        reloadTrips()
    }
    
    @IBAction func createTripTapped(_ sender: Any) {
        self.createButtonTapped()
    }
    
    
    func showDatePicker(dateType: DateType){
        let datePickerVC = DatePickerViewController()
        datePickerVC.dateType = dateType
        datePickerVC.initialDate = .now
        datePickerVC.onDateSelected = { [weak self] selected in
            
            let formattedDate = self?.formatDate(selected)
            switch dateType {
            case .start:
                self?.startDateLabel.text = formattedDate
                self?.viewModel.selectedStartDate = selected
            case .end:
                self?.endDateLabel.text = formattedDate
                self?.viewModel.selectedEndDate = selected
            }
            
            self?.enableCreateTrip =  self?.viewModel.checkCreateTripFormStatus()
            self?.setCreateTripBtnEnabled(self?.enableCreateTrip)
        }
        present(datePickerVC, animated: true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    
    func setCreateTripBtnEnabled(_ enabled: Bool?){
        createTripBtn.isEnabled = enabled ?? false
        createTripBtn.alpha = enabled ?? false ? 1 : 0.5
    }
    
    
    @objc private func citySelectionButtonTapped() {
        let selectCityVC = SelectCityViewController(viewModel: CreateTripViewModel())
        selectCityVC.onCitySelected = { [weak self] selectedLocation in
            // Update UI or state with the selected city
            print("Selected city: \(selectedLocation.city)")
            self?.selectedCityLabel.text = selectedLocation.city
            self?.viewModel.selectedCity = selectedLocation.city
            
            self?.enableCreateTrip = self?.viewModel.checkCreateTripFormStatus()
            self?.setCreateTripBtnEnabled(self?.enableCreateTrip)
        }
        
        let navController = UINavigationController(rootViewController: selectCityVC)
        navController.modalPresentationStyle = .pageSheet  // or .formSheet, .fullScreen
        present(navController, animated: true)
    }
    
    private var loader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    
    @objc private func createButtonTapped() {
        let createTripVC = CreateTripViewController()
        createTripVC.viewModel = CreateTripViewModel()
        createTripVC.viewModel?.trip.startDate = viewModel.trip.startDate
        createTripVC.viewModel?.trip.endDate = viewModel.trip.endDate
        createTripVC.viewModel?.trip.destination = viewModel.trip.destination
        createTripVC.delegate = self
        
        let navController = UINavigationController(rootViewController: createTripVC)
        navController.modalPresentationStyle = .pageSheet  // or .formSheet, .fullScreen
        present(navController, animated: true)
    }
    
    @objc private func seeTripTapped() {
        let vc = TripDetailViewController()
        let navController = UINavigationController(rootViewController: vc)
        navController.modalPresentationStyle = .pageSheet  // or .formSheet, .fullScreen
        present(navController, animated: true)
    }
    
    func reloadTrips() {
        tripCollectionView.reloadData()
        
        DispatchQueue.main.async {
            self.updateCollectionViewHeight()
        }
    }
    
    private func updateCollectionViewHeight() {
        let itemCount = trips.count
        let totalSpacing = CGFloat(max(0, itemCount - 1)) * lineSpacing
        let totalHeight = CGFloat(itemCount) * itemHeight + totalSpacing
        tripCollectionViewHeightConstraint.constant = totalHeight
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return trips.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TripCollectionCell", for: indexPath) as? TripCollectionCell else {
            return UICollectionViewCell()
        }
        
        let trip = trips[indexPath.item]
        cell.configure(with: trip) { [weak self] in
            let vc = TripDetailViewController()
            vc.trip = trip
            let navController = UINavigationController(rootViewController: vc)
            self?.present(navController, animated: true)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}
