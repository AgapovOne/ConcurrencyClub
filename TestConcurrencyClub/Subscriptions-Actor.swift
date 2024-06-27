//import SwiftUI
//
//struct SubscriptionsViewA: View {
//
//    @StateObject var viewModel = ViewModelA()
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Button("Add sub") {
//                viewModel.addSub()
//            }
//            Button("Change sub") {
//                viewModel.changeSub()
//            }
//            HStack {
//                ForEach(viewModel.subs, id: \.id) { sub in
//                    Text("\(sub.value)")
//                }
//            }
//        }
//        .task {
//            do {
//                try await viewModel.megatask()
//            } catch {
//                print("haha")
//            }
//        }
//    }
//}
//
//#Preview {
//    SubscriptionsViewA()
//}
//
//import Combine
//
//@MainActor
//final class ViewModelA: ObservableObject  {
//
//    struct Sub {
//        let id: UUID
//        var value: Int
//    }
//
//    @Published var subs: [Sub] = []
//
//    let service = ServiceA()
//
//    var bag = Set<AnyCancellable>()
//    var subscriptions: [Task<Void, Never>] = []
//
//    func megatask() async throws {
//        try await withTaskCancellationHandler {
//            try await Task.never()
//            print("subszz")
//        } onCancel: {
//            Task { @MainActor in
//                subscriptions.forEach { $0.cancel() }
//                print("canc")
//            }
//            print("cancee")
//        }
//    }
//
//    func addSub() {
//        let index = subs.count
//
//        subscriptions.append(Task {
//            for await v in await service.publisher.values {
//
//                self.subs[index].value = v
//                print(v)
//            }
//        })
//    }
//
//    func changeSub() {
//        let newRandom = (100...999).randomElement()!
//
//        Task {
//            await service.update(age: newRandom)
//        }
//    }
//}
//
//import ConcurrencyExtras
//import AsyncAlgorithms
//
//actor ServiceA {
//
////    var agezz = 10
//
////    @Published var age = 10
//    let age = CurrentValueSubject<Int, Never>(10)
////    var value: Int { age.value }
//    var publisher: AnyPublisher<Int, Never> {
//        age.eraseToAnyPublisher()
//    }
//
//    let not = Notifier<Int>()
//
//    private var bag: [UUID: AnyCancellable] = [:]
//
//    func ch() -> AsyncChannel<Int> {
//        let c = AsyncChannel<Int>()
//
//        let canc = age.sink { age in
//            Task {
//                await c.send(age)
//            }
//        }
//
//        return c
//    }
//
//    func stream() -> AsyncStream<Int> {
//        AsyncStream<Int>(Int.self, bufferingPolicy: .unbounded, { (con: AsyncStream<Int>.Continuation) in
//            let id = UUID()
//            let c = age
//                .sink { age in
//                    con.yield(age)
//                }
//            self.bag[id] = c
//            con.onTermination = { _ in
//                Task { [weak self] in
//                    await self?.cancel(by: id)
//                }
//            }
//        })
//    }
//
//    func cancel(by id: UUID) {
//        bag[id]?.cancel()
//    }
////
////    func otherStream() -> AsyncStream<Int> {
////        let s = AsyncStream<Int>.makeStream()
////
////        nonisolated(unsafe) let cancellable = age.sink { age in
////            s.continuation.yield(age)
////        }
////        s.continuation.onTermination = { _ in
////            cancellable.cancel()
////        }
////
////        return s.stream
////    }
//
//    func update(age: Int) {
//        self.age.value = age
////        self.continu.yield(age)
//    }
//}
//
////extension Publisher where Failure == Never {
////    public var stream: AsyncStream<Output> {
////        AsyncStream<Output> { continuation in
////            nonisolated(unsafe) let cancellable = self.sink { _ in
////                    continuation.finish()
////            } receiveValue: { value in
////                 continuation.yield(value)
////            }
////            continuation.onTermination = { continuation in
////                cancellable.cancel()
////            }
////        }
////    }
////}
////
////extension Publisher where Failure: Error {
////    public var stream: AsyncThrowingStream<Output, Error> {
////        AsyncThrowingStream<Output, Error> { continuation in
////            nonisolated(unsafe) let cancellable = self.sink { completion in
////                switch completion {
////                case .finished:
////                    continuation.finish()
////                case .failure(let error):
////                    continuation.finish(throwing: error)
////                }
////            } receiveValue: { value in
////                 continuation.yield(value)
////            }
////            continuation.onTermination = { continuation in
////                cancellable.cancel()
////            }
////        }
////    }
////}
//
//public struct Counter: AsyncSequence {
//    public typealias Element = Int
//    let howHigh: Int
//
//
//    public struct AsyncIterator: AsyncIteratorProtocol {
//        let howHigh: Int
//        var current = 1
//
//        public mutating func next() async -> Int? {
//            // A genuinely asynchronous implementation uses the `Task`
//            // API to check for cancellation here and return early.
//            guard current <= howHigh else {
//                return nil
//            }
//
//            let result = current
//            current += 1
//            return result
//        }
//    }
//
//
//    public func makeAsyncIterator() -> AsyncIterator {
//        return AsyncIterator(howHigh: howHigh)
//    }
//}
//
//
//
//actor Notifier<Element: Sendable> {
//    typealias CancellableIdentifier = UUID
//
//    private let valuesPublisher = PassthroughSubject<Element, Never>()
//    private var cancellables: [CancellableIdentifier: AnyCancellable] = [:]
//
//    func values() -> AsyncStream<Element> {
//        .init { [valuesPublisher] continuation in
//            let id = CancellableIdentifier()
//
//            cancellables[id] = valuesPublisher.sink { completion in
//                continuation.finish()
//            } receiveValue: { value in
//                continuation.yield(value)
//            }
//
//            continuation.onTermination = { _ in
//                Task { [weak self] in
//                    await self?.removeCancellable(id: id)
//                }
//            }
//        }
//    }
//
//    func send(_ element: Element) {
//        valuesPublisher.send(element)
//    }
//}
//
//private extension Notifier {
//    func removeCancellable(id: UUID) {
//        cancellables.removeValue(forKey: id)
//    }
//}
