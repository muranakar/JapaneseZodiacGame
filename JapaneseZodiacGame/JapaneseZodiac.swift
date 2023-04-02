//
//  WeekDayGame.swift
//  WeekDayGame
//
//  Created by 村中令 on 2022/10/06.
//

import Foundation

//曜日
enum Zodiac: Int, Equatable {
    case mouse = 0
    case cow = 1
    case tiger = 2
    case rabbit = 3
    case dragon = 4
    case snake = 5
    case horse = 6
    case sheep = 7
    case monkey = 8
    case cock = 9
    case dog = 10
    case boar = 11

    func textJapanese() -> String {
        switch self {
        case .mouse:
           return "子"
        case .cow:
           return "丑"
        case .tiger:
           return "寅"
        case .rabbit:
           return "卯"
        case .dragon:
           return "辰"
        case .snake:
           return "巳"
        case .horse:
           return "午"
        case .sheep:
           return "未"
        case .monkey:
           return "申"
        case .cock:
           return "酉"
        case .dog:
           return "戌"
        case .boar:
           return "亥"
        }
    }

    //曜日の判定
    static func set(for date: Date) -> Self {
        let calendar = Calendar(identifier: .gregorian)
        let yearNumber = calendar.component(.year, from: date)
        //ZodiacのrawValueが .yearの値と一致することを自明として考えてforced unwrapp
        let zodiacIndex = (yearNumber + 8) % 12
        let zodiac = Zodiac(rawValue: zodiacIndex)!
        return zodiac
    }
}

//Quiz用のイニシャライザ
extension Zodiac {
    init?(quizValue: Int) {
        var quizValue = quizValue % 12 // 7で割りきれた余りによって判定
        if quizValue < 0 { //マイナスだったら１週間分に進めて曜日を決定
            quizValue = quizValue + 12
        }
        self.init(rawValue: quizValue)
    }
}

//Quizのレベル
enum ZodiacQuizLevel {
    case hard
    case normal
    case easy
}

enum ZodiacDateTextFromNum {
    case yearAfter(dateNum: Int)
    case yearBefore(dateNum: Int)

    init(dateNum: Int) {
        if dateNum > 0 {
            self = .yearAfter(dateNum: dateNum)
        } else if dateNum < 0{
            self = .yearBefore(dateNum: dateNum)
        } else {
            fatalError("DateTextFromNumに、引数に誤りがあります。")
        }
    }

    func text() -> String {
        switch self {
        case .yearAfter(dateNum: 2):
            return "再来年"
        case .yearAfter(dateNum: 1):
            return "来年"
        case .yearBefore(dateNum: -1):
            return "去年"
        case .yearBefore(dateNum: -2):
            return "一昨年"
        case .yearAfter(dateNum: let dateNum):
            return "\(dateNum)年後"
        case .yearBefore(dateNum: let dateNum):
            return "\(abs(dateNum))年前"
        }
    }
}

struct ZodiacQuiz {
    private let level: ZodiacQuizLevel
    private let today = Date()

    private let firstDateNumber: Int
    private let secondDateNumber: Int
    private let thirdDateNumber: Int

    var text: String {
        let firstText = ZodiacDateTextFromNum(dateNum: firstDateNumber).text()
        let secondText = ZodiacDateTextFromNum(dateNum: secondDateNumber).text()
        let thirdText = ZodiacDateTextFromNum(dateNum: thirdDateNumber).text()

        let totalText: String
        switch level {
        case .hard: totalText = "今年の\(firstText)の\n\(secondText)の\n\(thirdText) の干支は？"
        case .normal: totalText = "今年の\(firstText)の\n\(secondText) の干支は？"
        case .easy: totalText = "今年の\(firstText) \nの干支は？"
        }

        return totalText
    }

    init(level: ZodiacQuizLevel) {
        self.level = level

        //muranakaさんの配列の書き方の方がコード見てパッとわかるので良さげ
        var randomNumber: Int {
            Array(-12...12)
                .filter{ $0 != 0 }
                .randomElement()!
        }

        firstDateNumber = randomNumber
        secondDateNumber = randomNumber
        thirdDateNumber = randomNumber
    }

    //Test用
    init(first: Int, second: Int, third: Int, level : ZodiacQuizLevel) {
        firstDateNumber = first
        secondDateNumber = second
        thirdDateNumber = third
        self.level = level
    }

    func answer() -> Zodiac {
        let zodiac = Zodiac.set(for: today)
        // 今日の曜日に各クイズの日数を合算
        let zodiacNumber: Int
        switch level {
        case .hard:
            zodiacNumber = zodiac.rawValue + firstDateNumber + secondDateNumber + thirdDateNumber
        case .normal:
            zodiacNumber = zodiac.rawValue + firstDateNumber + secondDateNumber
        case .easy:
            zodiacNumber = zodiac.rawValue + firstDateNumber
        }
        return Zodiac(quizValue: zodiacNumber)!
    }
}

struct ZodiacGame {
    private var quiz: ZodiacQuiz
    let quizLevel: ZodiacQuizLevel
    var missCount: Int = 0
    var correctCount: Int = 0

    init(level: ZodiacQuizLevel) {
        quiz = ZodiacQuiz(level: level)
        quizLevel = level
    }

    init(testQuiz: ZodiacQuiz,level: ZodiacQuizLevel) {
        quiz = testQuiz
        quizLevel = level
    }

    func displayQuizText() -> String {
        quiz.text
    }

    mutating func reset() {
        self.quiz = ZodiacQuiz(level: quizLevel)
    }

    mutating func answer(input: Zodiac) -> Bool {
        let answer = quiz.answer()
        if answer == input {
            self.correctCount += 1
        } else {
            self.missCount += 1
        }
        return answer == input ? true : false
    }
    func answer() -> Zodiac {
        return quiz.answer()
    }
}
