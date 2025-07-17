//
//  TripDataSource 2.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//


import Foundation

final class TripDataSource {
    private let apiService: APIService

    init(apiService: APIService = APIService()) {
        self.apiService = apiService
    }
    
    func createTrip(request: CreateTripRequest) async throws -> TripResponse {
        let api = TripAPI.createTrip(request: request)
        return try await apiService.networkRequest(
            endpoint: api.path,
            method: api.method,
            headers: api.headers,
            body: request
        )
    }

    func getTrips() async throws -> TripAPIResponse {
        let api = TripAPI.getTrips
        return try await apiService.networkRequest(
            endpoint: api.path,
            method: api.method,
            headers: api.headers
        )
    }
}
