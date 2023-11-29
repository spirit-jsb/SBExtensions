//
//  UserDefaultsExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension UserDefaults {
    subscript(key: String) -> Any? {
        get {
            return self.object(forKey: key)
        }
        set {
            self.set(newValue, forKey: key)
        }
    }
}

public extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, forKey key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else {
            return nil
        }

        return try? decoder.decode(type.self, from: data)
    }

    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)

        self.set(data, forKey: key)
    }
}

#endif
