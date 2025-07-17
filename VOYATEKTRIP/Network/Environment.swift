//
//  Environment.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 15/07/2025.
//


import Foundation

enum Environment {
    case development
    case production

    var baseURL: URL? {
        switch self {
        case .development:
            return URL(string: "https://cad10a60131ce5fad531.free.beeceptor.com/api/")
        case .production:
            return URL(string: "https://api.production.com")
        }
    }
}

struct AppConfig {
    static let currentEnvironment: Environment = .development
}


