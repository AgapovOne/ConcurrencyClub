//
//  NewDebouncer.swift
//  TestConcurrencyClub
//
//  Created by Alex Agapov on 27.06.2024.
//

import ConcurrencyExtras

final class NewDebouncer<Value: Sendable, C: Clock>: Sendable {
    private let s = AsyncStream.makeStream(of: Value.self)
    private let duration: C.Duration
    private let clock: C
    private let action: LockIsolated<((Value) -> Void)> = LockIsolated({ _ in })
    private let isStarted = LockIsolated(false)
//    private var task: Task<Void, Error>?

    init(duration: C.Duration, clock: C = .continuous) {
        self.duration = duration
        self.clock = clock
    }

    func start() {
        isStarted.setValue(true)
//        task =
        Task {
            for try await value in s.stream.debounce(for: duration, clock: clock) {
                action.withValue { $0(value) }
            }
        }
    }

    func debounce(_ value: Value, action: @escaping @Sendable (Value) -> Void) {
        assert(isStarted.value, "Run start to enable debouncer")
        self.action.setValue(action)
        s.continuation.yield(value)
    }
}
