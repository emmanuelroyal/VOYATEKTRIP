//
//  TripAPI.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//

import Foundation

enum TripAPI {
    case getTrips
    case createTrip(request: CreateTripRequest)
}

protocol ApiDetails {
    var path: String { get }
    var method: HTTPMethod { get }
    var body: Encodable? { get }
    var headers: [String: String]? { get }
}

extension TripAPI: ApiDetails {
    var path: String {
        switch self {
        case .getTrips, .createTrip:
            return "/trips"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getTrips:
            return .get
        case .createTrip:
            return .post
        }
    }

    var body: Encodable? {
        switch self {
        case .createTrip(let request):
            return request
        default:
            return nil
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
