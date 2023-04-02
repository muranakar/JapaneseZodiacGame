//
//  ZodiacTest.swift
//  WeekDayGame
//
//  Created by 村中令 on 2022/10/12.
//

import XCTest
@testable import JapaneseZodiacGame

final class ZodiacTest: XCTestCase {



    override class func setUp() {
        super.setUp()
    }

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        var game  =  ZodiacGame(testQuiz: ZodiacQuiz(first: 12, second: 2, third: -2, level: .hard), level: .hard)
        let zodiac = Zodiac.set(for: Date())
        XCTAssertEqual(zodiac, .tiger)
        XCTAssertEqual(game.displayQuizText(), "今年の12年後の再来年の一昨年 の干支は？")

        XCTAssertEqual(game.answer(), .tiger)
        let isCorrect = game.answer(input: .tiger)
        XCTAssertEqual(isCorrect, true)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
