import Foundation
import SwiftUI

struct SubscriptionsViewNotifCenter: View {

    @StateObject var viewModel = ViewModelNot()

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
            .task {
                do {
                    try await viewModel.megatask()
                } catch {
                    print("where is megatask?")
                }
            }
        }
    }
}

#Preview {
    SubscriptionsViewNotifCenter()
}

import Combine

@MainActor
final class ViewModelNot: ObservableObject  {

    @Published var subs: [Int] = []

    let service = TheServiceNot.shared

    var subscriptions: [Task<Void, Never>] = []

    func megatask() async throws {
        try await withTaskCancellationHandler {
            try await Task.never()
        } onCancel: {
            Task { @MainActor in
                subscriptions.forEach { $0.cancel() }
                print("canceled tasks")
            }
            print("cancel")
        }
    }

    func addSub() {
        let index = subs.count
        subs.append(-1000)

        subscriptions.append(Task {
            let sequence = NotificationCenter.default
                .notifications(named: service.storage.notification)
                .map { $0.object as! Int }

            for await age in sequence {
                self.subs[index] = age
            }
        })
    }

    func changeSub() {
        let newRandom = (100...999).randomElement()!

        Task {
            service.storage.update(age: newRandom)
        }
    }

}

import ConcurrencyExtras
import AsyncAlgorithms

final class StorageNot: Sendable {
    private let age = LockIsolated(10)

    var value: Int {
        age.value
    }

    var notification: Notification.Name {
        .init("age_update")
    }

    func update(age: Int) {
        self.age.setValue(age)
        NotificationCenter.default.post(Notification(
            name: notification,
            object: age
        ))
    }
}

final class TheServiceNot: Sendable {

    static let shared = TheServiceNot()

    let storage = StorageNot()
    let age = NotifiableStorage(10)
}

final class NotifiableStorage<Value: Sendable>: Sendable {

    var value: Value {
        isolated.value
    }

    private let isolated: LockIsolated<Value>

    init(_ value: Value) {
        self.isolated = LockIsolated(value)
    }

    var notification: Notification.Name {
        .init("haha")
    }

    func update(_ newValue: Value) {
        self.isolated.setValue(newValue)
        NotificationCenter.default.post(Notification(
            name: notification,
//            object: newValue,
            userInfo: ["val": newValue]
        ))
    }
}

typealias Age = Notifiable<Int>

struct Notifiable<Value: Sendable> {

    let value: Value

    func notification() -> Notification {
        .init(name: Self.name, object: value)
    }

    static var name: Notification.Name {
        .init("haha")
    }
}

extension NotificationCenter {
    func post<Value>(_ notifiable: Notifiable<Value>) {
        post(notifiable.notification())
    }

    func notifications<Value>(_ type: Notifiable<Value>.Type) -> any AsyncSequence {
        notifications(named: type.name).map { $0.object as! Value }
    }
}
