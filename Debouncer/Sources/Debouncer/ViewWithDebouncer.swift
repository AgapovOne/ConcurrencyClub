//
//  ViewWithDebouncer.swift
//  TestConcurrencyClub
//
//  Created by Alex Agapov on 27.06.2024.
//

import Foundation
import SwiftUI

@MainActor
struct ViewWithDebouncer: View {
    
    @State private var cook = 1

    let debouncer = Debouncer.make(minimumDelay: 1)

    var body: some View {
        EmptyView()
            .onAppear {
                Task {}
                Task { @MainActor in }
//                debouncer.debounce { @MainActor in

                Task.detached {
                    debouncer.debounce { @MainActor in
                        cook += 1
                    }
                }

                debouncer.debounce { @MainActor in
//                    DispatchQueue.main.async {
                        cook += 1
//                    }
//
//                    Task { @MainActor in
//                        cook += 1
//                    }
//
//                    MainActor.assumeIsolated {
//                        cook += 1 //1
//                    }
//                    f() // 2
                }
            }
    }
}

import ConcurrencyExtras

final class SomeService: Sendable {
    
    let age = LockIsolated(10)

    let debouncer = Debouncer.make(minimumDelay: 1)

    func doX() {
        debouncer.debounce {
            self.age.withValue { $0 += 10 }
        }
    }
}
