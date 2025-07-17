//
//  CreateTripViewModelDelegate.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//


import Foundation

protocol CreateTripViewModelDelegate: AnyObject {
    func formValidityDidChange(isValid: Bool)
    func filteredLocationsDidUpdate(_ locations: [Location])
    func selectedLocationDidChange(_ location: Location)
}

class CreateTripViewModel {
    // MARK: - Properties
    weak var delegate: CreateTripViewModelDelegate?
    
    private(set) var locationData: [Location] = Location.data
    private(set) var filteredLocationData: [Location] = []
    private(set) var trip: TripModel
    var formIsValid = false
    
    var selectedLocation: Location = Location() {
        didSet {
            trip.destination = selectedLocation.location
            delegate?.selectedLocationDidChange(selectedLocation)
        }
    }
    
    // MARK: - Init
    init(trip: TripModel = TripModel()) {
        self.trip = trip
        self.filteredLocationData = Location.data
    }
    
    func beginSearch(for searchText: String) {
        filteredLocationData = searchText.isEmpty
            ? locationData  // return full list if nothing is searched
            : locationData.filter { $0.location.lowercased().contains(searchText.lowercased()) }

        delegate?.filteredLocationsDidUpdate(filteredLocationData)
    }
    
    func updateFormValidity() {
       formIsValid = checkCreateTripFormStatus()
    }
    
    func clear() {
        filteredLocationData = []
        selectedLocation = Location()
        trip = TripModel()
        notifyFormValidity()
    }
    
    // MARK: - Validation
    private func checkCreateTripFormStatus() -> Bool {
        return !trip.tripName.isEmpty &&
               !trip.description.isEmpty &&
               !trip.travelStyle.isEmpty
    }
    
    
    private func notifyFormValidity() {
        delegate?.formValidityDidChange(isValid: checkCreateTripFormStatus())
    }
}

enum TravelStyleEnum: String, CaseIterable {
   case solo = "Solo"
   case couple = "Couple"
   case family = "Family"
   case group = "Group"
}
