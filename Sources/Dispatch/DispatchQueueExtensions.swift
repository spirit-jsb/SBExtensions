//
//  DispatchQueueExtensions.swift
//
//  Created by Max on 2023/11/2
//
//  Copyright © 2023 Max. All rights reserved.
//

#if canImport(Dispatch)

import Dispatch

public extension DispatchQueue {
    static var isMainQueue: Bool {
        struct MainStatic {
            static var key: DispatchSpecificKey<Void> = {
                let key = DispatchSpecificKey<Void>()
                DispatchQueue.main.setSpecific(key: key, value: ())
                return key
            }()
        }

        return DispatchQueue.getSpecific(key: MainStatic.key) != nil
    }
}

public extension DispatchQueue {
    static func isCurrentQueue(_ queue: DispatchQueue) -> Bool {
        let key = DispatchSpecificKey<Void>()
        queue.setSpecific(key: key, value: ())
        defer {
            queue.setSpecific(key: key, value: nil)
        }

        return DispatchQueue.getSpecific(key: key) != nil
    }

    func asyncAfter(delay: Double, qos: DispatchQoS = .unspecified, flags: DispatchWorkItemFlags = [], execute work: @escaping () -> Void) {
        self.asyncAfter(deadline: .now() + delay, qos: qos, flags: flags, execute: work)
    }

    func debounce(delay: Double, action: @escaping () -> Void) -> () -> Void {
        var lastFireTime = DispatchTime.now()

        let deadline = { lastFireTime + delay }

        return {
            self.asyncAfter(deadline: deadline()) {
                let now = DispatchTime.now()
                if now >= deadline() {
                    lastFireTime = now
                    action()
                }
            }
        }
    }
}

#endif
