//
//  TestConcurrencyClubTests.swift
//  TestConcurrencyClubTests
//
//  Created by Alex Agapov on 07.06.2024.
//

import Clocks
import XCTest
@testable import TestConcurrencyClub

final class TestConcurrencyClubTests: XCTestCase {

    func testDebouncer() async throws {

        nonisolated(unsafe) var storage = [Int]()

        let clock = TestClock()
        let debouncer = Debouncer<Int, TestClock>(duration: .seconds(1), clock: clock)
        try await debouncer.start()
        debouncer.debounce(1) { value in
            storage.append(value)
        }
        await clock.advance(by: .seconds(10))
        debouncer.debounce(2) { value in
            storage.append(value)
        }
        debouncer.debounce(3) { value in
            storage.append(value)
        }
        await clock.advance(by: .seconds(2))
        XCTAssertEqual(storage, [1, 3])
    }
}
