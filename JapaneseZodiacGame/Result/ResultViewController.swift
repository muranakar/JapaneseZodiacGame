//
//  ResultViewController.swift
//  NumberMemoryGame
//
//  Created by 村中令 on 2022/09/14.
//

import UIKit
import GoogleMobileAds

class ResultViewController: UIViewController {
    @IBOutlet weak private var oneGameCoinLabel: UILabel!
    @IBOutlet weak private var allCoinLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    // MARK: - 広告関係のプロパティ
    @IBOutlet weak private var bannerView: GADBannerView!
    private var zodiacGame: ZodiacGame
    private var getCoinByQuizLevel: Int
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAdBannar()
        configureViewBackButton()
        configureViewOneGameCoinLabel()
        configureViewAllCoinLabel()
    }
    required init?(coder: NSCoder,zodiacGame: ZodiacGame) {
        self.zodiacGame = zodiacGame
        let multiplicationNumByQuizLevel: Int
        switch zodiacGame.quizLevel {
        case .hard:
            multiplicationNumByQuizLevel = 3
        case .normal:
            multiplicationNumByQuizLevel = 2
        case .easy:
            multiplicationNumByQuizLevel = 1
        }
        getCoinByQuizLevel = zodiacGame.correctCount * multiplicationNumByQuizLevel
        CoinRepository.add(coinNum: getCoinByQuizLevel)
        super.init(coder: coder)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - View関係
    private func configureViewBackButton() {
        backButton.layer.borderWidth = 3
        backButton.layer.borderColor = UIColor.init(named: "string")?.cgColor
        backButton.layer.cornerRadius = 10
        backButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        backButton.setTitleColor(UIColor.init(named: "string"), for: .normal)
        backButton.setTitleColor(.gray, for: .disabled)
    }
    private func configureViewOneGameCoinLabel() {
        oneGameCoinLabel.text = " × \(getCoinByQuizLevel)"
    }
    private func configureViewAllCoinLabel() {
        allCoinLabel.text = " × \(CoinRepository.load())"
    }
    // MARK: - 広告関係のメソッド
    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.resultBannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }
}
