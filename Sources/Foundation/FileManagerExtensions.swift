//
//  FileManagerExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension FileManager {
    func createTemporaryDirectory() throws -> URL {
        return try self.url(for: .itemReplacementDirectory, in: .userDomainMask, appropriateFor: self.temporaryDirectory, create: true)
    }

    func jsonFromFile(atPath path: String) throws -> Data {
        if #available(iOS 16.0, *) {
            return try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
        } else {
            return try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        }
    }

    func jsonFromFile(atPath path: String, readingOptions: JSONSerialization.ReadingOptions = .fragmentsAllowed) throws -> [String: Any]? {
        return try JSONSerialization.jsonObject(with: self.jsonFromFile(atPath: path), options: readingOptions) as? [String: Any]
    }

    func jsonFromFile(withFilename filename: String, at bundleClass: AnyClass? = nil) throws -> Data? {
        let name = filename.components(separatedBy: ".")[0]
        let bundle = bundleClass != nil ? Bundle(for: bundleClass!) : Bundle.main

        guard let path = bundle.path(forResource: name, ofType: "json") else {
            return nil
        }

        return try self.jsonFromFile(atPath: path)
    }

    func jsonFromFile(withFilename filename: String, at bundleClass: AnyClass? = nil, readingOptions: JSONSerialization.ReadingOptions = .fragmentsAllowed) throws -> [String: Any]? {
        return try self.jsonFromFile(withFilename: filename, at: bundleClass).flatMap { try JSONSerialization.jsonObject(with: $0, options: readingOptions) as? [String: Any] }
    }
}

#endif
