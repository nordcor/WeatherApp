//
//  StringExtension.swift
//  WeatherApp
//
//  Created by ifknord on 12/5/2025.
//

import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
