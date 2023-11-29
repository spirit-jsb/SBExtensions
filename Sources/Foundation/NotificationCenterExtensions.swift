//
//  NotificationCenterExtensions.swift
//
//  Created by Max on 2023/11/18
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Foundation)

import Foundation

public extension NotificationCenter {
    func observeOnce(forName name: NSNotification.Name?, object obj: Any?, queue: OperationQueue?, using block: @escaping @Sendable (Notification) -> Void) {
        var handler: (any NSObjectProtocol)!

        let removeObserver = { [unowned self] in
            self.removeObserver(handler!)
        }

        handler = self.addObserver(forName: name, object: obj, queue: queue) {
            removeObserver()
            block($0)
        }
    }
}

#endif
