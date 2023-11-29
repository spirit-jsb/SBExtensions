//
//  CLLocationCoordinate2DExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(CoreLocation)

import CoreLocation

public extension CLLocationCoordinate2D {
    /// 将WGS-84坐标转换为GCJ-02坐标
    func wgs84ToGCJ02() -> CLLocationCoordinate2D {
        let (dLat, dLng) = CLLocationCoordinate2D.delta(lat: self.latitude, lng: self.longitude)

        let gcjLat = self.latitude + dLat
        let gcjLng = self.longitude + dLng

        return CLLocationCoordinate2D(latitude: gcjLat, longitude: gcjLng)
    }

    /// 将GCJ-02坐标转换为WGS-84坐标
    func gcj02ToWGS84() -> CLLocationCoordinate2D {
        let (dLat, dLng) = CLLocationCoordinate2D.delta(lat: self.latitude, lng: self.longitude)

        let wgsLat = self.latitude - dLat
        let wgsLng = self.longitude - dLng

        return CLLocationCoordinate2D(latitude: wgsLat, longitude: wgsLng)
    }

    /// 将WGS-84坐标转换为BD-09坐标
    func wgs84ToBD09() -> CLLocationCoordinate2D {
        return self.wgs84ToGCJ02().gcj02ToBD09()
    }

    /// 将GCJ-02坐标转换为BD-09坐标
    func gcj02ToBD09() -> CLLocationCoordinate2D {
        let x = self.longitude
        let y = self.latitude
        let z = sqrt(x * x + y * y) + 0.00002 * sin(y * .pi)

        let theta = atan2(y, x) + 0.000003 * cos(x * .pi)

        let bdLat = z * sin(theta) + CLLocationCoordinate2D.BD_DLAT
        let bdLng = z * cos(theta) + CLLocationCoordinate2D.BD_DLNG

        return CLLocationCoordinate2D(latitude: bdLat, longitude: bdLng)
    }

    /// 将BD-09坐标转换为WGS-84坐标
    func bd09ToWGS84() -> CLLocationCoordinate2D {
        return self.bd09ToGCJ02().gcj02ToWGS84()
    }

    /// 将BD-09坐标转换为GCJ-02坐标
    func bd09ToGCJ02() -> CLLocationCoordinate2D {
        let x = self.longitude - CLLocationCoordinate2D.BD_DLNG
        let y = self.latitude - CLLocationCoordinate2D.BD_DLAT
        let z = sqrt(x * x + y * y) - 0.00002 * sin(y * .pi)

        let theta = atan2(y, x) - 0.000003 * cos(x * .pi)

        let gcjLat = z * sin(theta)
        let gcjLng = z * cos(theta)

        return CLLocationCoordinate2D(latitude: gcjLat, longitude: gcjLng)
    }
}

private extension CLLocationCoordinate2D {
    /// Krasovsky 1940 ellipsoid
    static let GCJ_A = 6_378_245.0
    static let GCJ_EE = 0.00669342162296594323 // f = 1/298.3; e^2 = 2*f - f**2

    /// Baidu's artificial deviations
    static let BD_DLAT = 0.006
    static let BD_DLNG = 0.0065

    static func transform(_ x: Double, _ y: Double) -> (lat: Double, lng: Double) {
        let d = 20.0 * sin(6.0 * x * .pi) + 20.0 * sin(2.0 * x * .pi)

        var lat = d
        var lng = d

        lat += 20.0 * sin(y * .pi) + 40.0 * sin(y * .pi / 3.0)
        lng += 20.0 * sin(x * .pi) + 40.0 * sin(x * .pi / 3.0)

        lat += 160.0 * sin(y * .pi / 12.0) + 320.0 * sin(y * .pi / 30.0)
        lng += 150.0 * sin(x * .pi / 12.0) + 300.0 * sin(x * .pi / 30.0)

        lat *= 2.0 / 3.0
        lng *= 2.0 / 3.0

        lat += -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
        lng += 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))

        return (lat, lng)
    }

    static func delta(lat: Double, lng: Double) -> (dLat: Double, dLng: Double) {
        let radiusLat = lat / 180.0 * .pi

        var magic = sin(radiusLat)
        magic = 1.0 - self.GCJ_EE * magic * magic

        let sqrtMagic = sqrt(magic)

        var (dLat, dLng) = self.transform(lng - 105.0, lat - 35.0)

        dLat = (dLat * 180.0) / ((self.GCJ_A * (1.0 - self.GCJ_EE)) / (magic * sqrtMagic) * .pi)
        dLng = (dLng * 180.0) / (self.GCJ_A / sqrtMagic * cos(radiusLat) * .pi)

        return (dLat, dLng)
    }
}

#endif
