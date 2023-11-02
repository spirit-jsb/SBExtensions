//
//  UIApplicationExtensions.swift
//  SBExtensions
//
//  Created by JONO-Jsb on 2023/11/2.
//

#if canImport(UIKit)

import UIKit

public extension UIApplication {
    enum Environment {
        case debug
        case testFlight
        case appStore
    }
}

public extension UIApplication {
    static var documentURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    }

    static var documentPath: String {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    }

    static var cachesURL: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).last!
    }

    static var cachesPath: String {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
    }

    static var libraryURL: URL {
        return FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last!
    }

    static var libraryPath: String {
        return NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
    }

    var inferredEnvironment: Environment {
        #if DEBUG
        return .debug
        #elseif targetEnvironment(simulator)
        return .debug
        #else
        if Bundle.main.path(forResource: "embedded", ofType: "mobileprovision") != nil {
            return .testFlight
        } else {
            if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL {
                if appStoreReceiptURL.lastPathComponent.lowercased() == "sandboxreceipt" {
                    return .testFlight
                } else if appStoreReceiptURL.path().lowercased().contains("simulator") {
                    return .debug
                } else {
                    return .appStore
                }
            } else {
                return .debug
            }
        }

        #endif
    }

    var bundleIdentifier: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String
    }

    var bundleName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
    }

    var displayName: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
    }

    var version: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }

    var buildNumber: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
}

#endif