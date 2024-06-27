//
//  OldDebouncer.swift
//  
//
//  Created by Alex Agapov on 27.06.2024.
//

import ConcurrencyExtras
import Foundation

public struct OldDebouncer: Sendable {
    public let reset: @Sendable () -> Void
    public let resetTimer: @Sendable () -> Void
    public let debounce: @Sendable (_ block: @escaping @Sendable () -> Void) -> Void

    public init(
        reset: @escaping @Sendable () -> Void,
        resetTimer: @escaping @Sendable () -> Void,
        debounce: @escaping @Sendable (_: @escaping @Sendable () -> Void) -> Void
    ) {
        self.reset = reset
        self.resetTimer = resetTimer
        self.debounce = debounce
    }
}

extension OldDebouncer {

    public static func make(
        minimumDelay: TimeInterval,
        shouldDelayFirstRun: Bool = false
    ) -> OldDebouncer {
        let workItem = LockIsolated(DispatchWorkItem(block: {}))
        let previousRun = LockIsolated(Date.distantPast)

        @Sendable func reset() {
            workItem.withValue {
                $0.cancel()
                $0 = .init(block: {})
            }
        }

        @Sendable func resetTimer() {
            previousRun.setValue(Date.distantPast)
        }

        @Sendable func debounce(_ block: @escaping @Sendable () -> Void) {
            workItem.withValue {
                $0.cancel()

                $0 = DispatchWorkItem {
                    previousRun.setValue(Date())
                    block()
                    workItem.setValue(.init(block: {}))
                }
            }

            let delay = shouldDelayFirstRun
                ? minimumDelay
                : Date().timeIntervalSince(previousRun.value) > minimumDelay ? 0 : minimumDelay
            workItem.withValue {
                if delay > 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay), execute: $0)
                } else {
                    DispatchQueue.main.async(execute: $0)
                }
            }
        }

        return .init(
            reset: reset,
            resetTimer: resetTimer,
            debounce: debounce(_:)
        )
    }
}

public struct UnsafeDebouncer {
    public let reset: () -> Void
    public let resetTimer: () -> Void
    public let debounce: (_ block: @escaping () -> Void) -> Void

    public init(
        reset: @escaping () -> Void,
        resetTimer: @escaping () -> Void,
        debounce: @escaping (_: @escaping () -> Void) -> Void
    ) {
        self.reset = reset
        self.resetTimer = resetTimer
        self.debounce = debounce
    }
}

extension UnsafeDebouncer {

    public static func make(
        minimumDelay: TimeInterval,
        shouldDelayFirstRun: Bool = false
    ) -> UnsafeDebouncer {
        var workItem: DispatchWorkItem = DispatchWorkItem(block: {})
        var previousRun: Date = Date.distantPast

        func reset() {
            workItem.cancel()
            workItem = .init(block: {})
        }

        func resetTimer() {
            previousRun = Date.distantPast
        }

        func debounce(_ block: @escaping () -> Void) {
            workItem.cancel()

            workItem = DispatchWorkItem {
                previousRun = Date()
                block()
                workItem = .init(block: {})
            }

            let delay = shouldDelayFirstRun
                ? minimumDelay
                : Date().timeIntervalSince(previousRun) > minimumDelay ? 0 : minimumDelay
            if delay > 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(delay), execute: workItem)
            } else {
                DispatchQueue.main.async(execute: workItem)
            }
        }

        return .init(
            reset: reset,
            resetTimer: resetTimer,
            debounce: debounce(_:)
        )
    }
}
