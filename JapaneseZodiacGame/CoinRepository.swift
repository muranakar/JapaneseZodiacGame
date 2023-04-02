//
//  CoinRepository.swift
//  LineConnectingGame
//
//  Created by 村中令 on 2022/06/18.
//

import Foundation

struct CoinRepository {
    static func load() -> Int {
        let key = "coin"
        let loadCoin = UserDefaults.standard.integer(forKey: key)
        return loadCoin
    }
    static func save(coinNum: Int) {
        let key = "coin"
        UserDefaults.standard.set(coinNum, forKey: key)
    }
    static func add(coinNum: Int) {
        let key = "coin"
        var loadCoin = UserDefaults.standard.integer(forKey: key)
        loadCoin += coinNum
        UserDefaults.standard.set(loadCoin, forKey: key)
    }
    static func checkMoreThan100() -> Bool {
        let key = "coin"
        let loadCoin = UserDefaults.standard.integer(forKey: key)
        if loadCoin >= 100 {
            return true
        }
        return false
    }
    static func checkMoreThan300() -> Bool {
        let key = "coin"
        let loadCoin = UserDefaults.standard.integer(forKey: key)
        if loadCoin >= 300 {
            return true
        }
        return false
    }
}
