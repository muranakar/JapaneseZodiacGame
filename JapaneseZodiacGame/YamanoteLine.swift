//
//  WeekDayGame.swift
//  WeekDayGame
//
//  Created by 村中令 on 2022/10/06.
//

import Foundation

//曜日
enum YamanoteLine: Int, Equatable {
    case yurakutyo = 0
    case sinnbasi = 1
    case hamamatutyo = 2
    case tamachi = 3
    case takanawagateway = 4
    case shinagawa = 5
    case osaki = 6
    case gotannda = 7
    case meguro = 8
    case ebisu = 9
    case shibuya = 10
    case harazyuku = 11
    case yoyogi = 12
    case sinzyuku = 13
    case shinokubo = 14
    case takadanobaba = 15
    case meziro = 16
    case ikebukuro = 17
    case otuka = 18
    case sugamo = 19
    case komagome = 20
    case tabata = 21
    case nishinippori = 22
    case nippori = 23
    case uguisudani = 24
    case ueno = 25
    case okachimachi = 26
    case akihabara = 27
    case kanda = 28
    case tokyo = 29

    func textJapanese() -> String {
        switch self {
        case .yurakutyo:
            return "有楽町"
        case .sinnbasi:
            return "新橋"
        case .hamamatutyo:
            return "浜松町"
        case .tamachi:
            return "田町"
        case .takanawagateway:
            return "高輪ゲートウェイ"
        case .shinagawa:
            return "品川"
        case .osaki:
            return "大崎"
        case .gotannda:
            return "五反田"
        case .meguro:
            return "目黒"
        case .ebisu:
            return "恵比寿"
        case .shibuya:
            return "渋谷"
        case .harazyuku:
            return "原宿"
        case .yoyogi:
            return "代々木"
        case .sinzyuku:
            return "新宿"
        case .shinokubo:
            return "新大久保"
        case .takadanobaba:
            return "高田馬場"
        case .meziro:
            return "目白"
        case .ikebukuro:
            return "池袋"
        case .otuka:
            return "大塚"
        case .sugamo:
            return "巣鴨"
        case .komagome:
            return "駒込"
        case .tabata:
            return "田端"
        case .nishinippori:
            return "西日暮里"
        case .nippori:
            return "日暮里"
        case .uguisudani:
            return "鶯谷"
        case .ueno:
            return "上野"
        case .okachimachi:
            return "御徒町"
        case .akihabara:
            return "秋葉原"
        case .kanda:
            return "神田"
        case .tokyo:
            return "東京"
        }
    }

    //曜日の判定
    static func set(yamanoteLine: YamanoteLine) -> Self {
        return yamanoteLine
    }
    static func setRandom() -> Self {
        let randomIndex = Array(0...29).shuffled().first!
        let yamanoteLine = YamanoteLine(rawValue: randomIndex)!
        return yamanoteLine
    }
}

//Quiz用のイニシャライザ
extension YamanoteLine {
    init?(quizValue: Int) {
        var quizValue = quizValue % 29 // 7で割りきれた余りによって判定

        if quizValue < 0 { //マイナスだったら１週間分に進めて曜日を決定
            quizValue = quizValue + 29
        }

        self.init(rawValue: quizValue)
    }
}

//Quizのレベル
enum YamanoteLineQuizLevel {
    case hard
    case normal
    case easy
}

enum YamanoteLineDateTextFromNum {
    case right(dateNum: Int)
    case left(dateNum: Int)

    init(dateNum: Int) {
        if dateNum > 0 {
            self = .right(dateNum: dateNum)
        } else if dateNum < 0 {
            self = .left(dateNum: dateNum)
        } else {
            fatalError("DateTextFromNumに、引数に誤りがあります。")
        }
    }

    func text() -> String {
        switch self {
        case .right(dateNum: let dateNum):
            return "\(dateNum)駅右回り"
        case .left(dateNum: let dateNum):
            return "\(abs(dateNum))駅左回り"
        }
    }
}

struct YamanoteLineQuiz {
    private let level: YamanoteLineQuizLevel
    private let baseStation: YamanoteLine

    private let firstDateNumber: Int
    private let secondDateNumber: Int
    private let thirdDateNumber: Int

    var text: String {
        let firstText = YamanoteLineDateTextFromNum(dateNum: firstDateNumber).text()
        let secondText = YamanoteLineDateTextFromNum(dateNum: secondDateNumber).text()
        let thirdText = YamanoteLineDateTextFromNum(dateNum: thirdDateNumber).text()

        let totalText: String
        switch level {
        case .hard: totalText = "\(baseStation.textJapanese())の\(firstText) して、\(secondText)して、\(thirdText)は、何駅？"
        case .normal: totalText = "\(baseStation.textJapanese())の\(firstText)して、\(secondText)は、何駅？"
        case .easy: totalText = "\(baseStation.textJapanese())の\(firstText)は、何駅？"
        }

        return totalText
    }

    init(level: YamanoteLineQuizLevel,baseStation: YamanoteLine) {
        self.level = level
        self.baseStation = baseStation
        //muranakaさんの配列の書き方の方がコード見てパッとわかるので良さげ
        var randomNumber: Int {
            Array(-30...30)
                .filter{ $0 != 0 }
                .randomElement()!
        }

        firstDateNumber = randomNumber
        secondDateNumber = randomNumber
        thirdDateNumber = randomNumber
    }

    //Test用
    init(first: Int, second: Int, third: Int, level : YamanoteLineQuizLevel ,baseStation: YamanoteLine) {
        firstDateNumber = first
        secondDateNumber = second
        thirdDateNumber = third
        self.baseStation = baseStation
        self.level = level
    }

    func answer() -> YamanoteLine {
        let baseStationRawValue = baseStation.rawValue
        // 今日の曜日に各クイズの日数を合算
        let yamanoteLineNumber: Int
        switch level {
        case .hard:
            yamanoteLineNumber = baseStationRawValue + firstDateNumber + secondDateNumber + thirdDateNumber
        case .normal:
            yamanoteLineNumber = baseStationRawValue + firstDateNumber + secondDateNumber
        case .easy:
            yamanoteLineNumber = baseStationRawValue + firstDateNumber
        }
        return YamanoteLine(quizValue: yamanoteLineNumber)!
    }
}

struct YamanoteLineGame {
    private var quiz: YamanoteLineQuiz
    private let quizLevel: YamanoteLineQuizLevel
    var missCount: Int = 0
    var correctCount: Int = 0

    init(level: YamanoteLineQuizLevel) {
        quiz = YamanoteLineQuiz(level: level, baseStation: YamanoteLine.setRandom())
        quizLevel = level
    }

    init(testQuiz: YamanoteLineQuiz,level: YamanoteLineQuizLevel) {
        quiz = testQuiz
        quizLevel = level
    }

    func displayQuizText() -> String {
        quiz.text
    }

    mutating func reset() {
        self.quiz = YamanoteLineQuiz(level: quizLevel,baseStation: YamanoteLine.setRandom())
    }

    mutating func answer(input: YamanoteLine) -> Bool {
        let answer = quiz.answer()
        if answer == input {
            self.correctCount += 1
        } else {
            self.missCount += 1
        }
        return answer == input ? true : false
    }
    func answer() -> YamanoteLine{
        return quiz.answer()
    }
}

