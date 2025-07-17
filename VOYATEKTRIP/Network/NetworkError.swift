//
//  NetworkError.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//
import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case noData
    case decodingFailed(Error)
    case timeout
    case serverError(statusCode: Int, data: Data?)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid."
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .noData:
            return "No data received from the server."
        case .decodingFailed(let error):
            return "Failed to decode the response: \(error.localizedDescription)"
        case .timeout:
            return "The request timed out."
        case .serverError(let code, _):
            return "Server responded with status code \(code)."
        case .unknown:
            return "An unknown error occurred."
        }
    }
}

extension NetworkError {
    var userFriendlyMessage: String {
        switch self {
        case .timeout:
            return "Network timeout. Check your connection and try again."
        case .serverError(let code, _):
            if code == 500 {
                return "Server is down. Please try again later."
            }
            return "Something went wrong. (Code: \(code))"
        default:
            return self.errorDescription ?? "Unknown error."
        }
    }
}

