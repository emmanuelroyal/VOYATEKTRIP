//
//  DateFormater+extension.swift
//  VOYATEKTRIP
//
//  Created by emmanuel obuh on 16/07/2025.
//
import Foundation

extension DateFormatter {
   static func calculateDays(from startDate: String?, to endDate: String?, dateFormat: String = "yyyy-MM-dd") -> Int? {
      guard let startDate = startDate, let endDate = endDate else {
         return nil
      }
      
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = dateFormat
      
      if let start = dateFormatter.date(from: startDate), let end = dateFormatter.date(from: endDate) {
         let calendar = Calendar.current
         let components = calendar.dateComponents([.day], from: start, to: end)
         return components.day
      }
      return nil
   }
   
   static func getDateString(from date: Date, format: String = "yyyy-MM-dd") -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      return dateFormatter.string(from: date)
   } 
   
   static func getMediumDateFromDateString(from dateStr: String, format: String = "yyyy-MM-dd") -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = format
      if let date = dateFormatter.date(from: dateStr) {
         dateFormatter.dateStyle = .medium
         return dateFormatter.string(from: date)
      }
      return String()
   }
}


extension Date {
    func formattedWithSuffix() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        
        let suffix: String
        switch day {
        case 11...13: suffix = "th"
        default:
            switch day % 10 {
            case 1: suffix = "st"
            case 2: suffix = "nd"
            case 3: suffix = "rd"
            default: suffix = "th"
            }
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy" // Example: "April 2024"
        let monthYear = formatter.string(from: self)
        
        return "\(day)\(suffix) \(monthYear)"
    }
}
