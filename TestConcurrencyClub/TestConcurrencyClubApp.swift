//
//  TestConcurrencyClubApp.swift
//  TestConcurrencyClub
//
//  Created by Alex Agapov on 07.06.2024.
//

import SwiftUI

@main
struct TestConcurrencyClubApp: App {

    @State var isPresented = false

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack(spacing: 32) {
                    Button("Open") {
                        isPresented.toggle()
                    }

//                    Button("Rename") {
//                        TheService.shared.name.setValue("\((0...1000).randomElement()!)")
//                    }
                }
                .navigationDestination(isPresented: $isPresented) {
                    SubscriptionsViewNotifCenter()
                }
            }
        }
    }
}
