//
//  WeekDayGame.swift
//  WeekDayGame
//
//  Created by 村中令 on 2022/10/06.
//

import Foundation

//曜日
enum DayOfTheWeek: Int, Equatable {
    case sunday = 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7

    func textJapanese() -> String {
        switch self {
        case .sunday:
            return "日"
        case .monday:
            return "月"
        case .tuesday:
            return "火"
        case .wednesday:
            return "水"
        case .thursday:
            return "木"
        case .friday:
            return  "金"
        case .saturday:
            return  "土"
        }
    }

    //曜日の判定
    static func set(for date: Date) -> Self {
        let calendar = Calendar(identifier: .gregorian)
        let weekdayNumber = calendar.component(.weekday, from: date)
        //dayOfTheWeekのrawValueが .weekDayの値と一致することを自明として考えてforced unwrapp
        let weekDay = DayOfTheWeek(rawValue: weekdayNumber)!
        return weekDay
    }
}

//Quiz用のイニシャライザ
extension DayOfTheWeek {
    init?(quizValue: Int) {
        var quizValue = quizValue % 7 // 7で割りきれた余りによって判定

        if quizValue == 0 {
            quizValue = 7
        }

        if quizValue < 0 { //マイナスだったら１週間分に進めて曜日を決定
            quizValue = quizValue + 7
        }

        self.init(rawValue: quizValue)
    }
}

//Quizのレベル
enum QuizLevel {
    case hard
    case normal
    case easy
}

enum DateTextFromNum {
    case dateAfter(dateNum: Int)
    case dateBefore(dateNum: Int)

    init(dateNum: Int) {
        if dateNum > 0 {
            self = .dateAfter(dateNum: dateNum)
        } else if dateNum < 0{
            self = .dateBefore(dateNum: dateNum)
        } else {
            fatalError("DateTextFromNumに、引数に誤りがあります。")
        }
    }

    func text() -> String {
        switch self {
        case .dateAfter(dateNum: 2):
            return "明後日"
        case .dateAfter(dateNum: 1):
            return "明日"
        case .dateBefore(dateNum: -1):
            return "昨日"
        case .dateBefore(dateNum: -2):
            return "一昨日"
        case .dateAfter(dateNum: let dateNum):
            return "\(dateNum)日後"
        case .dateBefore(dateNum: let dateNum):
            return "\(abs(dateNum))日前"
        }
    }
}

struct Quiz {
    private let level: QuizLevel
    private let today = Date()

    private let firstDateNumber: Int
    private let secondDateNumber: Int
    private let thirdDateNumber: Int

    var text: String {
        let firstText = DateTextFromNum(dateNum: firstDateNumber).text()
        let secondText = DateTextFromNum(dateNum: secondDateNumber).text()
        let thirdText = DateTextFromNum(dateNum: thirdDateNumber).text()

        let totalText: String
        switch level {
        case .hard: totalText = "今日の\(firstText)の\n\(secondText)の\n\(thirdText)は、\n何曜日？"
        case .normal: totalText = "今日の\(firstText)の\n\(secondText)は、\n何曜日？"
        case .easy: totalText = "今日の\(firstText)は、\n何曜日？"
        }

        return totalText
    }

    init(level: QuizLevel) {
        self.level = level

        //muranakaさんの配列の書き方の方がコード見てパッとわかるので良さげ
        var randomNumber: Int {
            Array(-7...7)
                .filter{ $0 != 0 }
                .randomElement()!
        }

        firstDateNumber = randomNumber
        secondDateNumber = randomNumber
        thirdDateNumber = randomNumber
    }

    //Test用
    init(first: Int, second: Int, third: Int, level : QuizLevel) {
        firstDateNumber = first
        secondDateNumber = second
        thirdDateNumber = third
        self.level = level
    }

    func answer() -> DayOfTheWeek {
        let weekDay = DayOfTheWeek.set(for: today)

        // 今日の曜日に各クイズの日数を合算
        let weekDayNumber: Int
        switch level {
        case .hard:
            weekDayNumber = weekDay.rawValue + firstDateNumber + secondDateNumber + thirdDateNumber
        case .normal:
            weekDayNumber = weekDay.rawValue + firstDateNumber + secondDateNumber
        case .easy:
            weekDayNumber = weekDay.rawValue + firstDateNumber
        }
        return DayOfTheWeek(quizValue: weekDayNumber)!
    }
}

struct WeekDayGame {
    private var quiz: Quiz
    let quizLevel: QuizLevel
    var correctCount: Int = 0
    var missCount: Int = 0


    init(level: QuizLevel) {
        quiz = Quiz(level: level)
        quizLevel = level
    }

    init(testQuiz: Quiz,level: QuizLevel) {
        quiz = testQuiz
        quizLevel = level
    }

    func displayQuizText() -> String {
        quiz.text
    }

    mutating func reset() {
        self.quiz = Quiz(level: quizLevel)
    }

    mutating func answer(input: DayOfTheWeek) -> Bool {
        let answer = quiz.answer()
        if answer == input {
            self.correctCount += 1
        } else {
            self.missCount += 1
        }
        return answer == input ? true : false
    }
    func answer() -> DayOfTheWeek{
        return quiz.answer()
    }
}
