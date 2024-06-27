//import SwiftUI
//
//struct SubscriptionsViewStr: View {
//
//    @StateObject var viewModel = ViewModelStr()
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
//            .task {
//                await viewModel.start()
//            }
//    }
//}
//
//#Preview {
//    SubscriptionsViewStr()
//}
//
//import Combine
//
//@MainActor
//final class ViewModelStr: ObservableObject  {
//
//    struct Sub {
//        let id = UUID()
//        var value: Int
//    }
//
//    @Published var subs: [Sub] = []
//
//    let service = TheServiceStr.shared
//
//    var tasks: [Task<Void, Never>] = []
//
//    func start() async {
//        do {
//            try await withTaskCancellationHandler {
//                try await Task.never()
//            } onCancel: {
//                Task { @MainActor in tasks.forEach { $0.cancel() } }
//                Task { await tasks.forEach { $0.cancel() } }
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//    let subject = CurrentValueSubject<Int>()
//
//    func addSub() {
//
////        for await v  in subject.values {
////            hardTask()
////        }
//        let index = subs.count
//        subs.append(.init(value: -1000))
//
//        tasks.append(Task {
//            // 1 - 5s
//            // 2s - 2 - x
//            // 5s - 3 - v
//            for await a in service.stream().debounce(for: .seconds(1)) {
//
////                hardTask() { 
////                    // 5s
////                }
//
//                self.subs[index].value = a
//            }
//        })
//    }
//
//    func changeSub() {
//        let newRandom = (100...999).randomElement()!
//        service.storage.update(newRandom)
//    }
//
//}
//
//import ConcurrencyExtras
//import AsyncAlgorithms
//
//final class StorageStr: Sendable {
//    private let age = LockIsolated(10)
//    private let s = AsyncStream<Int>.makeStream()
//
//    let c = AsyncChannel<Int>()
//
//    var stream: AsyncStream<Int> {
//        s.stream
//    }
//
//    func update(_ age: Int) {
//        AsyncStream<Int>(
//            bufferingPolicy: .unbounded
//        ) { c in
//
//        }
//
//        c.send(10)
//
//        s.continuation.yield(10)
//
//        self.age.setValue(age)
//        s.continuation.yield(age)
//    }
//}
//
//final class TheServiceStr: Sendable {
//
//    static let shared = TheServiceStr()
//
//    let storage = StorageStr()
//
//    func stream() -> AsyncStream<Int> {
//        storage.newSub()
//        AsyncStream(storage.stream)
//    }
//}
