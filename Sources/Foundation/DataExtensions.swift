//
//  DataExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension Data {
    var bytes: [UInt8] {
        // http://stackoverflow.com/questions/38097710/swift-3-changes-for-getbytes-method
        return [UInt8](self)
    }

    var jsonObject: Any? {
        return try? JSONSerialization.jsonObject(with: self, options: [])
    }

    var jsonString: String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: self, options: []), let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]) else {
            return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }

    var hexString: String {
        // https://stackoverflow.com/questions/39075043/how-to-convert-data-to-hex-string-in-swift
        return self.map { String(format: "%02x", $0) }.joined()
    }

    var base64String: String {
        return self.base64EncodedString()
    }
}

public extension Data {
    func string(encoding: String.Encoding) -> String? {
        return String(data: self, encoding: encoding)
    }
}

#endif
