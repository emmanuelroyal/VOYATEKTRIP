//
//  NetworkLogger.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//
import Foundation

final class NetworkLogger {
    static func log(request: URLRequest) {
        print("--- Request Started ---")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        print("Headers: \(request.allHTTPHeaderFields ?? [:])")
        if let body = request.httpBody {
            print("Body: \(String(data: body, encoding: .utf8) ?? "binary")")
        }
        print("------------------------")
    }

    static func log(response: URLResponse?, data: Data?) {
        print("--- Response Received ---")
        if let httpResponse = response as? HTTPURLResponse {
            print("Status Code: \(httpResponse.statusCode)")
            print("Headers: \(httpResponse.allHeaderFields)")
        }
        if let data = data, let responseString = String(data: data, encoding: .utf8) {
            print("Response Data: \(responseString)")
        }
        print("--------------------------")
    }

    static func log(error: Error, request: URLRequest?) {
        print("--- Network Error ---")
        if let request = request {
            log(request: request)
        }
        print("Error: \(error.localizedDescription)")
        print("---------------------")
    }
}
