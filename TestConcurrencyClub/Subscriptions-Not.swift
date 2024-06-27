import Foundation
import SwiftUI
import ConcurrencyExtras
import AsyncAlgorithms

struct SubscriptionsViewDebouncers: View {

//    let stream = AsyncStream<Int>.makeStream()
//    let c = AsyncChannel<Int>()
//    @State var debouncer: NewDebouncer<Int, ContinuousClock> = .init(duration: .seconds(1))

    @State var age = 10

    var body: some View {
        VStack(spacing: 16) {
            Button("Stream") {
                age = Int.random(in: 50..<60)
//                Task {
//                    await c.send(Int.random(in: 10..<20))
//                }
//                stream.continuation.yield(Int.random(in: 0..<10))
//                //
//                debouncer.debounce(Int.random(in: 30..<40)) { value in
//                    print(value)
//                }
            }
//            .task {
//                for await value in stream.stream.debounce(for: .seconds(1)) {
//                    print(value)
//                }
//            }
//            .task {
//                for await value in c.debounce(for: .seconds(1)) {
//                    print(value)
//                }
//            }
            .task(id: age) {
                try? await Task.sleep(for: .seconds(3))
                print(age)
            }
            .debouncer(value: age, for: .seconds(3)) { age in
                print(age)
            }
        }
    }
}

extension View {
    func debouncer<Value: Equatable, C: Clock>(
        value: Value,
        for duration: C.Instant.Duration,
        tolerance: C.Instant.Duration? = nil,
        clock: C = ContinuousClock(),
        _ task: @escaping (Value) async -> Void
    ) -> some View {
        self.task(id: value) {
            do {
                try await Task.sleep(for: duration, tolerance: tolerance, clock: clock)
                await task(value)
            } catch {
                print("task slept")
            }
        }
    }
}

#Preview {
    SubscriptionsViewDebouncers(age: 10)
}
