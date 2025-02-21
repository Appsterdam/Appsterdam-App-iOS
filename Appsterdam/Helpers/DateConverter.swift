//
//  DateConverter.swift
//  Appsterdam
//
//  Created by Wesley de Groot on 04/02/2022.
//

import Foundation

class dateFormat {
    init() {

    }

    /// Convert date
    /// - Parameter jsonDate: date string in yyyyMMddHHmmss
    /// - Returns: date string in dd MM yyyy HH:mm
    func convert(jsonDate: String, outputFormat: String = "dd MMM yyyy HH:mm") -> String {
        let extractedDate = jsonDate.split(separator: ":").count > 0 ? String(
            jsonDate.split(separator: ":")[0]
        ) : jsonDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let oldDateTime = dateFormatter.date(
            from: extractedDate
        ) else {
            return extractedDate
        }

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = outputFormat
        convertDateFormatter.locale = Locale.current

        return convertDateFormatter.string(
            from: oldDateTime
        )
    }
}
