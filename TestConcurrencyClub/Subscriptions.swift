//import SwiftUI
//
//struct SubscriptionsView: View {
//
//    @StateObject var viewModel = ViewModel()
//
//    var body: some View {
//        VStack(spacing: 16) {
//            Text("\(viewModel.state.counter)")
////            Text("\(viewModel.service.nameX.value)")
//            Button("Increment") {
//                viewModel.increment()
//            }
//            Button("Add sub") {
//                viewModel.addSub()
//            }
//            Button("Change sub") {
//                viewModel.changeSub()
//            }
//            HStack {
//                ForEach(viewModel.subs, id: \.self) { sub in
//                    Text("\(sub)")
//                }
//            }
//        }
//            .task {
//                await viewModel.start()
//            }
//            .task {
//                viewModel.otherStart()
//            }
//    }
//}
//
//#Preview {
//    SubscriptionsView()
//}
//
//import Combine
//
//@MainActor
//final class ViewModel: ObservableObject  {
//
//    struct State {
//        var counter: Int
//    }
//
//    @Published var state: State = .init(counter: 0)
//    @Published var subs: [Int] = []
//
//    let service = TheService.shared
//
//    var cancellables = Set<AnyCancellable>()
//
//    var task: Task<Void, Never>?
//
//    func start() async {
////        for await name in service.$name.values {
////            print("easy", name)
////        }
//    }
//
//    func otherStart() {
//        task = Task {
////            for await name in service.$name.values {
////                print("hard", name)
////            }
//        }
//    }
//
//    func addSub() {
//        let index = subs.count
//        subs.append(-1000)
//
////        Task {
////            for await a in service.age {
////                self.subs[index] = a
////            }
////        }
//
//        Task {
//            await service.storage.age
//                .sink { age in
//                    self.subs[index] = age
//                }.store(in: &cancellables)
//        }
////        subs.append(service.age)
////        subs.append(service.age.value)
////        service.$age.sink { age in
////            service.age.sink { age in
////            self.subs[index] = age
////        }.store(in: &cancellables)
//    }
//
//    func changeSub() {
//        let newRandom = (100...999).randomElement()!
////        service.age.value = newRandom
////        service.age = newRandom
//
//        Task {
//            await service.storage.update(age: newRandom)
////            service.storage.age = newRandom
////            await service.age.send(newRandom)
//        }
//    }
//
//    func increment() {
//        state.counter += 1
//    }
//}
//
//import ConcurrencyExtras
//import AsyncAlgorithms
//
//actor Storage: @unchecked Sendable {
////    @Published var age = 10
//    let age = CurrentValueSubject<Int, Never>(10)
//
//    func update(age: Int) {
//        self.age.value = age
//    }
//}
//
//final class TheService: Sendable {
//
//    static let shared = TheService()
//
//    let storage = Storage()
//
////    private let nameX = LockIsolated("aaa")
//
////    private var continuation: AsyncStream<String>.Continuation?
//
////    func stream() -> AsyncStream {
////        AsyncStream { con in
////            con
////        }
////    }
//
////    var names: AsyncStream<String> {
////        AsyncStream { continuation in
////            self.continuation = continuation
//////            continuation.yield(nameX)
////        }
////    }
//
////    public func send(name: String) {
////
////    }
//
//
////    @Published var name = LockIsolated("aaa")
//
////    let age = AsyncChannel<Int>()
//
////    let agex = CurrentValueSubject<Int, Never>(100)
//
////    @Published var age = 100
//}
