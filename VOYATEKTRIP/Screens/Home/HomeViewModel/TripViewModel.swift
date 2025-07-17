//
//  TripViewModelDelegate.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import Foundation

protocol TripViewModelDelegate: AnyObject {
    func didStartLoading()
    func didFinishLoading()
    func didUpdateTrips(_ trips: [TripModel])
    func didFailWithError(_ message: String)
    func didCreateTripSuccessfully(_ trip: TripResponse)
}

class TripViewModel {
    weak var delegate: TripViewModelDelegate?
    
    private var dataSource: TripDataSource?
    var trips: [TripModel] = []
    var trip: TripModel = TripModel()
    var isFetched = false

    var tripCategoryData = ["Planned Trips", "Spontaneous Trips", "Yearly vacation", "Recurring trips"]
    
    var selectedTripCategory: String = ""
    var selectedStartDate: Date = Date() {
        didSet {
            trip.startDate = DateFormatter.getDateString(from: selectedStartDate)
        }
    }
    
    var selectedCity: String = String() {
        didSet {
            trip.destination = selectedCity
        }
    }
    
    var selectedEndDate: Date = Date() {
        didSet {
            trip.endDate = DateFormatter.getDateString(from: selectedEndDate)
        }
    }

    init() {
        self.dataSource = TripDataSource()
    }

    func fetchTrips() {
        delegate?.didStartLoading()
        Task {
            do {
                let rawTrips = try await dataSource?.getTrips()
                let mapped = rawTrips?.data.map { TripModel(data: $0) } ?? []
                DispatchQueue.main.async { [ weak self] in
                    self?.isFetched = true
                    self?.delegate?.didUpdateTrips(mapped)
                    self?.delegate?.didFinishLoading()
                }
            } catch {
                DispatchQueue.main.async { [ weak self] in
                    self?.delegate?.didFinishLoading()
                    if let networkError = error as? NetworkError {
                        self?.delegate?.didFailWithError(networkError.userFriendlyMessage)
                    } else {
                        self?.delegate?.didFailWithError("An unexpected error occurred. Please try again.")
                    }

                }
            }
        }
    }

    func createTrip() {
        let request = CreateTripRequest(
            id: UUID().uuidString,
            imageUrl: trip.imageUrl,
             tripName: trip.tripName,
             travelStyle: trip.travelStyle,
             startDate: trip.startDate,
            endDate: trip.endDate,
             description: trip.description,
            destination: trip.destination
            )

        delegate?.didStartLoading()
        Task {
            do {
                let createdTrip = try await dataSource?.createTrip(request: request)
                DispatchQueue.main.async { [ weak self] in
                    self?.delegate?.didFinishLoading()
                    if let trip = createdTrip {
                        self?.delegate?.didCreateTripSuccessfully(trip)
                        self?.clear()
                    }
                }
            } catch {
                DispatchQueue.main.async { [ weak self] in
                    self?.delegate?.didFinishLoading()
                    if let networkError = error as? NetworkError {
                        self?.delegate?.didFailWithError(networkError.userFriendlyMessage)
                    } else {
                        self?.delegate?.didFailWithError("An unexpected error occurred. Please try again.")
                    }
                }
            }
        }
    }

    func checkCreateTripFormStatus() -> Bool {
        return !trip.destination.isEmpty && !trip.startDate.isEmpty && !trip.endDate.isEmpty
    }

    func clear() {
        trip = TripModel()
    }
}
