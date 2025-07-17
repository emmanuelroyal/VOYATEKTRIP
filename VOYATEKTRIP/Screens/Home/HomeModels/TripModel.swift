//
//  TripModel.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//


import UIKit

class TripModel {
    
    // MARK: - Properties
    var id: String
    var tripName: String
    var travelStyle: String
    var description: String
    var startDate: String
    var endDate: String
    var destination: String
    var noOfDays: String
    var imageUrl: String?
    
    // MARK: - Init from API Response
    init(data: TripResponse) {
        self.id = data.id ?? ""
        self.tripName = data.tripName ?? ""
        self.travelStyle = data.travelStyle ?? ""
        self.description = data.description ?? ""
        self.startDate = data.startDate ?? ""
        self.endDate = data.endDate ?? ""
        self.destination = data.destination ?? ""
        self.noOfDays = String(DateFormatter.calculateDays(from: data.startDate, to: data.endDate) ?? 0)
        self.imageUrl = data.imageUrl
    }
    
    // MARK: - Manual Init
    init(
        id: String = "",
        tripName: String = "",
        travelStyle: String = "",
        description: String = "",
        startDate: String = "",
        endDate: String = "",
        destination: String = "",
        noOfDays: String = "",
        imageUrl: String? = nil
    ) {
        self.id = id
        self.tripName = tripName
        self.travelStyle = travelStyle
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
        self.destination = destination
        self.noOfDays = noOfDays
        self.imageUrl = imageUrl
    }
    
    // MARK: - Sample Data
    static var sampleData: [TripModel] = [
        TripModel(
            id: "1",
            tripName: "Bahamas Family Trip",
            travelStyle: "Family",
            description: "A relaxing family reunion on the beach",
            startDate: "2024-04-19",
            endDate: "2024-04-24",
            destination: "Bahamas",
            noOfDays: "5"
        ),
        TripModel(
            id: "1",
            tripName: "Bahamas Family Trip",
            travelStyle: "Family",
            description: "A relaxing family reunion on the beach",
            startDate: "2024-04-19",
            endDate: "2024-04-24",
            destination: "Bahamas",
            noOfDays: "5"
        ),
        TripModel(
            id: "1",
            tripName: "Bahamas Family Trip",
            travelStyle: "Family",
            description: "A relaxing family reunion on the beach",
            startDate: "2024-04-19",
            endDate: "2024-04-24",
            destination: "Bahamas",
            noOfDays: "5"
        )
    ]
}
