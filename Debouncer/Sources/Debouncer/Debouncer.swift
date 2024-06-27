import ConcurrencyExtras
import Foundation

public struct Debouncer: Sendable {

//    public typealias DebounceBlock = @Sendable () -> Void
    public typealias DebounceBlock = @Sendable @isolated(any) () -> Void

    public let reset: @Sendable () -> Void
    public let resetTimer: @Sendable () -> Void
    public let debounce: @Sendable (_ block: @escaping DebounceBlock) -> Void

    public init(
        reset: @escaping @Sendable () -> Void,
        resetTimer: @escaping @Sendable () -> Void,
        debounce: @escaping @Sendable (_: @escaping DebounceBlock) -> Void
//        debounce: @escaping @Sendable (_: sending @escaping DebounceBlock) -> Void
//        @_inheritActorContext debounce: @escaping @Sendable (_: sending @escaping DebounceBlock) -> Void
    ) {
        self.reset = reset
        self.resetTimer = resetTimer
        self.debounce = debounce
    }
}

extension Debouncer {

    public static func make(
        minimumDelay: TimeInterval,
        shouldDelayFirstRun: Bool = false
    ) -> Debouncer {
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

        @Sendable func debounce(_ block: @escaping @Sendable () async -> Void) {
            workItem.withValue {
                $0.cancel()

                $0 = DispatchWorkItem {
                    previousRun.setValue(Date())
                    Task {
                        await block()
                        workItem.setValue(.init(block: {}))
                    }
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
