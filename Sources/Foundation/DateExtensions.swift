//
//  DateExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(Foundation)

import Foundation

public extension Date {
    enum DateComponent {
        case year
        case month
        case day
        case hour
        case minute
        case second
        case weekday
        case nthWeekday
        case week
    }
}

public extension Date {
    private var calendar: Calendar {
        return Calendar.current
    }

    var era: Int {
        return self.calendar.component(.era, from: self)
    }

    var year: Int {
        return self.calendar.component(.year, from: self)
    }

    var month: Int {
        return self.calendar.component(.month, from: self)
    }

    var day: Int {
        return self.calendar.component(.day, from: self)
    }

    var hour: Int {
        return self.calendar.component(.hour, from: self)
    }

    var minute: Int {
        return self.calendar.component(.minute, from: self)
    }

    var second: Int {
        return self.calendar.component(.second, from: self)
    }

    var weekday: Int {
        return self.calendar.component(.weekday, from: self)
    }

    var quarter: Int {
        return self.calendar.component(.quarter, from: self)
    }

    var weekOfMonth: Int {
        return self.calendar.component(.weekOfMonth, from: self)
    }

    var weekOfYear: Int {
        return self.calendar.component(.weekOfYear, from: self)
    }

    var millisecond: Int {
        return self.calendar.component(.nanosecond, from: self) / 1_000_000
    }

    var nanosecond: Int {
        return self.calendar.component(.nanosecond, from: self)
    }

    var isFuture: Bool {
        return self > Date()
    }

    var isPast: Bool {
        return self < Date()
    }

    var isToday: Bool {
        return self.calendar.isDateInToday(self)
    }

    var isYesterday: Bool {
        return self.calendar.isDateInYesterday(self)
    }

    var isTomorrow: Bool {
        return self.calendar.isDateInTomorrow(self)
    }

    var isWeekend: Bool {
        return self.calendar.isDateInWeekend(self)
    }

    var isWorkday: Bool {
        return !self.calendar.isDateInWeekend(self)
    }

    var unixTimestamp: Double {
        return self.timeIntervalSince1970
    }

    var iso8601String: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"

        return dateFormatter.string(from: self).appending("Z")
    }
}

public extension Date {
    static func random(in range: Range<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate ..< range.upperBound.timeIntervalSinceReferenceDate))
    }

    static func random(in range: ClosedRange<Date>) -> Date {
        return Date(timeIntervalSinceReferenceDate: TimeInterval.random(in: range.lowerBound.timeIntervalSinceReferenceDate ... range.upperBound.timeIntervalSinceReferenceDate))
    }

    func string(withFormat dateFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat

        return dateFormatter.string(from: self)
    }

    func nearest(minutes: Int) -> Date {
        var components = self.calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
        components.minute = (components.minute! + minutes) / minutes * minutes

        return self.calendar.date(from: components)!
    }

    func adding(_ dateComp: DateComponent, value: Int) -> Date {
        var components = DateComponents()

        switch dateComp {
            case .year:
                components.year = value
            case .month:
                components.month = value
            case .day:
                components.day = value
            case .hour:
                components.hour = value
            case .minute:
                components.minute = value
            case .second:
                components.second = value
            case .weekday:
                components.weekday = value
            case .nthWeekday:
                components.weekdayOrdinal = value
            case .week:
                components.weekOfYear = value
        }

        return self.calendar.date(byAdding: components, to: self)!
    }

    mutating func add(_ dateComp: DateComponent, value: Int) {
        self = self.adding(dateComp, value: value)
    }
}

public extension Date {
    init?(iso8601String: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = dateFormatter.date(from: iso8601String) else {
            return nil
        }

        self = date
    }

    init(unixTimestamp: Double) {
        self.init(timeIntervalSince1970: unixTimestamp)
    }
}

#endif
