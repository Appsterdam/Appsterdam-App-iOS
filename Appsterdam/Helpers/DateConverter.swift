//
//  DateConverter.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 04/02/2022.
//

import Foundation

enum EventDateFormatter {
    private static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddHHmmss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    private static let outputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM y HH:mm"
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()

    static func date(from value: String) -> Date? {
        inputFormatter.date(from: startDateString(from: value))
    }

    static func string(from value: String) -> String {
        guard let date = date(from: value) else {
            return startDateString(from: value)
        }

        return outputFormatter.string(from: date)
    }

    private static func startDateString(from value: String) -> String {
        value.split(separator: ":", maxSplits: 1).first.map(String.init) ?? value
    }
}
