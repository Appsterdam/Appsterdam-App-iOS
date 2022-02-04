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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        let oldDateTime = dateFormatter.date(
            from: jsonDate
        )

        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = outputFormat
        convertDateFormatter.locale = Locale.current

        return convertDateFormatter.string(
            from: oldDateTime!
        )
    }
}
