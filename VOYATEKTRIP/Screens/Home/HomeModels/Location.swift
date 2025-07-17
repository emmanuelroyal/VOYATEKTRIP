//
//  Location.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import Foundation

import UIKit

class Location: Identifiable {
    let id = UUID()
    var location: String
    var city: String
    var initials: String
    var countryImageUrl: String
    
    // MARK: - Initializer
    init(location: String = "",
         city: String = "",
         initials: String = "",
         countryImageUrl: String = "") {
        self.location = location
        self.city = city
        self.initials = initials
        self.countryImageUrl = countryImageUrl
    }
    
    // MARK: - Sample Data
    static let data: [Location] = [
        .init(location: "Laghouat, Algeria", city: "Laghouat", initials: "DZ", countryImageUrl: "algeria.flag"),
        .init(location: "Doha, Qatar", city: "Doha", initials: "QA", countryImageUrl: "qatar.flag"),
        .init(location: "Lagos, Nigeria", city: "Lagos", initials: "NG", countryImageUrl: "nigeria.flag"),
        .init(location: "Laghouat, Algeria", city: "Laghouat", initials: "DZ", countryImageUrl: "algeria.flag"),
        .init(location: "Doha, Qatar", city: "Doha", initials: "QA", countryImageUrl: "qatar.flag"),
        .init(location: "Lagos, Nigeria", city: "Lagos", initials: "NG", countryImageUrl: "nigeria.flag")
    ]
}
