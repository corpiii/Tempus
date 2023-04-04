//
//  TimeTests.swift
//  TempusTests
//
//  Created by 이정민 on 2023/04/04.
//

import XCTest

final class TimeTests: XCTestCase {
    func test_Time_create_is_success() {
        // Arrange
        let second = 3850 // 1hour 4minutes 10seconds
        let time = Time(second: Double(second))
        
        // Act, Assert
        XCTAssertEqual(time.hour, 1)
        XCTAssertEqual(time.minute, 4)
        XCTAssertEqual(time.second, 10)
    }
}
