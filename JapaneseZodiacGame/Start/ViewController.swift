//
//  ViewController.swift
//  NumberMemoryGame
//
//  Created by 村中令 on 2022/09/14.
//

import UIKit
import GoogleMobileAds
import AppTrackingTransparency
import AdSupport

class ViewController: UIViewController {
    @IBOutlet weak private var allCoinLabel: UILabel!
    // MARK: - 広告関係のプロパティ
    var rewardedAd: GADRewardedAd?
    @IBOutlet weak private var bannerView: GADBannerView!

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var gameModeEasy: UIButton!
    @IBOutlet weak private var gameModeNormal: UIButton!
    @IBOutlet weak private var gameModeHard: UIButton!
    private var selectedQuizLevel: ZodiacQuizLevel = .easy
    private var buttons: [UIButton] {
        return [gameModeEasy,gameModeNormal,gameModeHard]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initAppTracking()
        configureRewardedAd()
        configureAdBannar()
        configureViewButtons()
        configureViewTitleLabel()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureViewAllCoinLabel()
        changeButtonIsEnabled()
    }
    @IBAction func selectGameMode(_ sender: UIButton) {
        changeAllButtonsIsSelectFalse()
        changeSelectedButtonIsSelectedTrue(button: sender)
        changeQuizLevel(button: sender)
        performSegue(withIdentifier: "game", sender: nil)
    }

    private func changeAllButtonsIsSelectFalse() {
        buttons.forEach { button in
            button.isSelected = false
        }
    }
    private func changeSelectedButtonIsSelectedTrue(button: UIButton) {
        if button == gameModeEasy {
            gameModeEasy.isSelected = true
        } else if button == gameModeNormal{
            gameModeNormal.isSelected = true
        } else if button == gameModeHard{
            gameModeHard.isSelected = true
        }
    }
    private func changeButtonIsEnabled() {
        if CoinRepository.checkMoreThan300() {
            buttons.forEach { button in
                button.isEnabled = true
            }
        } else if CoinRepository.checkMoreThan100() {
            gameModeHard.isEnabled = false
            gameModeNormal.isEnabled = true
            gameModeEasy.isEnabled = true
        } else {
            gameModeNormal.isEnabled = false
            gameModeHard.isEnabled = false
            gameModeEasy.isEnabled = true
        }
    }
    private func changeQuizLevel(button: UIButton){
        if button == gameModeEasy {
            selectedQuizLevel = .easy
        } else if button == gameModeNormal{
            selectedQuizLevel = .normal
        } else if button == gameModeHard{
            selectedQuizLevel = .hard
        }
    }
    // MARK: - AppTracking Method
    private func initAppTracking() {
        if #available(iOS 14, *) {
            switch ATTrackingManager.trackingAuthorizationStatus {
            case .authorized, .denied, .restricted:
                break
            case .notDetermined:
                AppTrackingTransparency.showRequestTrackingAuthorizationAlert()
            @unknown default:
                fatalError()
            }
        }
    }
    // MARK: - 広告関係のメソッド
    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.startBannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }
    private func configureRewardedAd() {
        GADRewardedAd.load(
            withAdUnitID: "\(GoogleAdID.startScreenRewardAdID)", request: GADRequest()
        ) { (ad, error) in
            if let error = error {
                print("Rewarded ad failed to load with error: \(error.localizedDescription)")
                return
            }
            print("Loading Succeeded")
            self.rewardedAd = ad
            self.rewardedAd?.fullScreenContentDelegate = self
        }
    }
    // MARK: - View関係
    private func configureViewAllCoinLabel() {
        allCoinLabel.text = " × \(CoinRepository.load())"
    }
    private func configureViewTitleLabel() {
        if DeviceType.isIPhone() {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 40.0)
        } else {
            titleLabel.font = UIFont.boldSystemFont(ofSize: 70.0)
        }
    }
    private func configureViewButtons() {
        buttons.forEach { button in
            button.layer.borderWidth = 3
            button.layer.borderColor = UIColor.init(named: "string")?.cgColor
            button.layer.cornerRadius = 10
            button.setTitleColor(UIColor.init(named: "string"), for: .normal)
            button.setTitleColor(.gray, for: .disabled)
            if DeviceType.isIPhone() {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
            } else {
                button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
            }

        }
    }
}

extension ViewController {
    @IBSegueAction
    func makeGameVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> GameViewController? {
        return GameViewController(coder: coder,level: selectedQuizLevel)
    }

    @IBAction
    func backToViewController(segue: UIStoryboardSegue) {
    }
}

extension ViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        configureRewardedAd()
        // 報酬の表示が必要。
    }
}
