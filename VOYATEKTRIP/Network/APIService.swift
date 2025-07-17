//
//  APIService.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//
import Foundation

final class APIService {
    private let session: URLSession
    private let timeoutInterval: TimeInterval = 30
    private let maxRetryCount = 0

    init(session: URLSession = URLSession(configuration: {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        return config
    }())) {
        self.session = session
    }

    /// 🔹 With body
    func networkRequest<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        body: U? = nil,
        retryCount: Int = 0
    ) async throws -> T {
        guard let baseURL = AppConfig.currentEnvironment.baseURL,
              let url = URL(string: endpoint, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers

        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        NetworkLogger.log(request: request)

        do {
            let (data, response) = try await session.data(for: request)
            NetworkLogger.log(response: response, data: data)

            guard let http = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }

            guard (200..<300).contains(http.statusCode) else {
                throw NetworkError.serverError(statusCode: http.statusCode, data: data)
            }

            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            NetworkLogger.log(error: error, request: request)

            if let urlError = error as? URLError, urlError.code == .timedOut {
                throw NetworkError.timeout
            }

            if retryCount < maxRetryCount {
                return try await networkRequest(
                    endpoint: endpoint,
                    method: method,
                    headers: headers,
                    body: body,
                    retryCount: retryCount + 1
                )
            } else {
                throw NetworkError.requestFailed(error)
            }
        }
    }

    /// 🔹 Overload without body (clean usage for GET, DELETE, etc.)
    func networkRequest<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        retryCount: Int = 0
    ) async throws -> T {
        return try await networkRequest(
            endpoint: endpoint,
            method: method,
            headers: headers,
            body: Optional<EmptyBody>.none,
            retryCount: retryCount
        )
    }

    /// Dummy empty body for overload
    private struct EmptyBody: Encodable {}
}
