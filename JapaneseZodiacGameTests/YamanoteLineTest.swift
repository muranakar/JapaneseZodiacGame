//
//  YamanoteLineTest.swift
//  WeekDayGameTests
//
//  Created by 村中令 on 2022/10/12.
//

import XCTest
@testable import JapaneseZodiacGame

final class YamanoteLineTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var yamanoteLineGame = YamanoteLineGame(
            testQuiz: YamanoteLineQuiz(
                first: 1,
                second: -3,
                third: 3,
                level: .hard,
                baseStation: .harazyuku
            ),
            level: .hard
        )
        XCTAssertEqual(yamanoteLineGame.displayQuizText(), "原宿の1駅右回り して、3駅左回りして、3駅右回りは、何駅？")
        XCTAssertEqual(yamanoteLineGame.answer(),.yoyogi)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
