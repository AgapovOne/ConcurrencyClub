import SwiftUI

struct SubscriptionsViewS: View {

    @StateObject var viewModel = ViewModelS()

    var body: some View {
        VStack(spacing: 16) {
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
    }
}

#Preview {
    SubscriptionsViewS()
}

import Combine

@MainActor
final class ViewModelS: ObservableObject  {

    @Published var subs: [Int] = []
    let sub = CurrentValueSubject<Int, Never>(10)

    let service = TheServiceS()

    var cancellables = Set<AnyCancellable>()

    func addSub() {
        sub.value = 20
        subs = [111]
//        let index = subs.count
//        subs.append(-1000)

//        service.sage.withValue { subject in
//            Task { @MainActor in
//                subject.sink { age in 
//// Mutable capture of 'inout' parameter 'subject' is not allowed in concurrently-executing code
//                    self.subs[index] = age
//                }.store(in: &cancellables)
//            }
//        }
    }

    func changeSub() {
        let newRandom = (100...999).randomElement()!
        service.sage.withValue { $0.value = newRandom }
    }

}

import ConcurrencyExtras
import AsyncAlgorithms

final class TheServiceS: Sendable {

    let sage = LockIsolated(CurrentValueSubject<Int, Never>(100))
}


actor TheService {
    var age = 10
}
