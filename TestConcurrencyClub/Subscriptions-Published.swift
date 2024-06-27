import SwiftUI

struct SubscriptionsViewP: View {

    @StateObject var viewModel = ViewModelP()

    var body: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.state.counter)")
//            Text("\(viewModel.service.nameX.value)")
            Button("Increment") {
                viewModel.increment()
            }
            Button("Add sub") {
                viewModel.addSub()
            }
            Button("Change sub") {
                viewModel.changeSub()
            }
            HStack {
                ForEach(viewModel.subs, id: \.self) { sub in
                    Text("\(sub)")
                }
            }
        }
            .task {
                await viewModel.start()
            }
            .task {
                viewModel.otherStart()
            }
    }
}

#Preview {
    SubscriptionsViewP()
}

import Combine

@MainActor
final class ViewModelP: ObservableObject  {

    struct State {
        var counter: Int
    }

    @Published var state: State = .init(counter: 0)
    @Published var subs: [Int] = []

    let service = TheServiceP()

    var cancellables = Set<AnyCancellable>()

    var task: Task<Void, Never>?

    func start() async {
//        for await name in service.$name.values {
//            print("easy", name)
//        }
    }

    func otherStart() {
        task = Task {
//            for await name in service.$name.values {
//                print("hard", name)
//            }
        }
    }

    func addSub() {
        let index = subs.count
        subs.append(-1000)

        subs.append(service.age)
        service.$age.sink { age in
            self.subs[index] = age
        }.store(in: &cancellables)
    }

    func changeSub() {
        let newRandom = (100...999).randomElement()!
        service.age = newRandom

        Task {
            service.age = newRandom
        }
    }

    func increment() {
        state.counter += 1
    }
}

import ConcurrencyExtras
import AsyncAlgorithms

final class TheServiceP {
//    final class TheServiceP: Sendable {

    @Published var name = "aaa"
//    @Published var name = LockIsolated("aaa")

    @Published var age = 100
}
