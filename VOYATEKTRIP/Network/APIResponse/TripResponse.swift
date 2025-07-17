//
//  TripResponse.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//

struct TripAPIResponse: Decodable {
    let status: Bool
    let message: String
    let data: [TripResponse]
}


struct TripResponse: Decodable {
    var id: String?
    var imageUrl: String?
    var tripName: String?
    var travelStyle: String?
    var startDate: String?
    var endDate: String?
    var description: String?
    var destination: String?
}

struct CreateTripRequest: Encodable {
    var id: String?
    var imageUrl: String?
    var tripName: String?
    var travelStyle: String?
    var startDate: String?
    var endDate: String?
    var description: String?
    var destination: String?
}
