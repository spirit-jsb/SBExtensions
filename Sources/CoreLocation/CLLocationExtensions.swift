//
//  CLLocationExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/13.
//

#if canImport(CoreLocation)

import CoreLocation

public extension CLLocation {
    static func midLocation(start: CLLocation, end: CLLocation) -> CLLocation {
        let lat1 = start.coordinate.latitude / 180.0 * .pi
        let lng1 = start.coordinate.longitude / 180.0 * .pi
        let lat2 = end.coordinate.latitude / 180.0 * .pi
        let lng2 = end.coordinate.longitude / 180.0 * .pi

        // Formula
        //    Bx = cos φ2 ⋅ cos Δλ
        //    By = cos φ2 ⋅ sin Δλ
        //    φm = atan2( sin φ1 + sin φ2, √(cos φ1 + Bx)² + By² )
        //    λm = λ1 + atan2(By, cos(φ1)+Bx)
        // Source: http://www.movable-type.co.uk/scripts/latlong.html

        let bx = cos(lat2) * cos(lng2 - lng1)
        let by = cos(lat2) * sin(lng2 - lng1)

        let mLat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bx) * (cos(lat1) + bx) + (by * by)))
        let mLng = lng1 + atan2(by, cos(lat1) + bx)

        return CLLocation(latitude: mLat * 180.0 / .pi, longitude: mLng * 180.0 / .pi)
    }

    static func bearing(start: CLLocation, end: CLLocation) -> Double {
        let lat1 = start.coordinate.latitude / 180.0 * .pi
        let lng1 = start.coordinate.longitude / 180.0 * .pi
        let lat2 = end.coordinate.latitude / 180.0 * .pi
        let lng2 = end.coordinate.longitude / 180.0 * .pi

        // Formula
        //    θ = atan2( sin Δλ ⋅ cos φ2 , cos φ1 ⋅ sin φ2 − sin φ1 ⋅ cos φ2 ⋅ cos Δλ )
        // Source: http://www.movable-type.co.uk/scripts/latlong.html

        let radius = atan2(sin(lng2 - lng1) * cos(lat2), cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lng2 - lng1))
        let degrees = radius * 180.0 / .pi

        return (degrees + 360.0).truncatingRemainder(dividingBy: 360.0)
    }

    func midLocation(to point: CLLocation) -> CLLocation {
        return CLLocation.midLocation(start: self, end: point)
    }

    func bearing(to point: CLLocation) -> Double {
        return CLLocation.bearing(start: self, end: point)
    }
}

#endif
