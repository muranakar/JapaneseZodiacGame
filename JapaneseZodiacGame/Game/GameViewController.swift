//
//  GameViewController.swift
//  NumberMemoryGame
//
//  Created by 村中令 on 2022/09/14.
//

import UIKit
import AVFoundation
import GoogleMobileAds

class GameViewController: UIViewController {
    private var zodiacGame: ZodiacGame

    @IBOutlet weak var answerTimerProgressView: UIProgressView!
    @IBOutlet weak private var quizTextLabel: UILabel!

    @IBOutlet weak private var zodiacAnswerButton1: UIButton!
    @IBOutlet weak private var zodiacAnswerButton2: UIButton!
    @IBOutlet weak private var zodiacAnswerButton3: UIButton!
    @IBOutlet weak private var zodiacAnswerButton4: UIButton!
    @IBOutlet weak private var zodiacAnswerButton5: UIButton!
    @IBOutlet weak private var zodiacAnswerButton6: UIButton!
    @IBOutlet weak private var zodiacAnswerButton7: UIButton!
    @IBOutlet weak private var zodiacAnswerButton8: UIButton!
    @IBOutlet weak private var zodiacAnswerButton9: UIButton!
    @IBOutlet weak private var zodiacAnswerButton10: UIButton!
    @IBOutlet weak private var zodiacAnswerButton11: UIButton!
    @IBOutlet weak private var zodiacAnswerButton12: UIButton!

    private var AllZodiacAnswerButtons: [UIButton] {
        return [
        zodiacAnswerButton1,
        zodiacAnswerButton2,
        zodiacAnswerButton3,
        zodiacAnswerButton4,
        zodiacAnswerButton5,
        zodiacAnswerButton6,
        zodiacAnswerButton7,
        zodiacAnswerButton8,
        zodiacAnswerButton9,
        zodiacAnswerButton10,
        zodiacAnswerButton11,
        zodiacAnswerButton12
        ]
    }
    private var shuffledAllZodiacAnswerButtons: [UIButton] = []
    private var dictionaryUIButtonAndZodiac: [UIButton: Zodiac] = [:]
    //MARK: - progress
    var progressDuration: Float = 1
    var progressTimer:Timer!
    // MARK: - 音声再生プロパティ
        var audioPlayer: AVAudioPlayer!

    // MARK: - 広告関係のプロパティ
    @IBOutlet weak private var bannerView: GADBannerView!
    private var interstitial: GADInterstitialAd?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAdBannar()
        configureInterstitialAd()
        initializeProgress()
        startProgressTimer()
        resetAllArrayAndDictionary()
        configureViewQuizTextLabel()
        configureViewButton()
    }
    required init?(coder: NSCoder,level: ZodiacQuizLevel) {
        zodiacGame = ZodiacGame(level: level)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func answerWeekDay(_ sender: UIButton) {
        let selectedZodiac = dictionaryUIButtonAndZodiac[sender]!
        if zodiacGame.answer(input: selectedZodiac) {
            playSound(name: "correct")
            zodiacGame.reset()
            resetAllArrayAndDictionary()
            configureViewQuizTextLabel()
            configureViewButton()
        } else {
            playSound(name: "miss")
            if zodiacGame.missCount == 5 {
                audioPlayer.stop()
                showGoogleIntitialAdAndPerformSegue()
            }
        }
    }

    private func resetAllArrayAndDictionary() {
        var randomZodiacRawValue = Array(0...11).shuffled()
        var randomZodiac : [Zodiac] = []
        randomZodiacRawValue.forEach { num in
            randomZodiac.append(Zodiac(rawValue: num)!)
        }

        shuffledAllZodiacAnswerButtons = []
        shuffledAllZodiacAnswerButtons = AllZodiacAnswerButtons.shuffled()

        dictionaryUIButtonAndZodiac.removeAll()
        var arrayIndexCount = 0
        let maxIndexArrayButtonAndZodiac = randomZodiac.count - 1
        while arrayIndexCount <= maxIndexArrayButtonAndZodiac {
            dictionaryUIButtonAndZodiac.updateValue(
                randomZodiac[arrayIndexCount],
                forKey: shuffledAllZodiacAnswerButtons[arrayIndexCount]
            )
            arrayIndexCount += 1
        }
    }

    private func configureViewQuizTextLabel() {
        quizTextLabel.text = zodiacGame.displayQuizText()
        if DeviceType.isIPhone() {
            quizTextLabel.font = UIFont.boldSystemFont(ofSize: 35.0)
        } else {
            quizTextLabel.font = UIFont.boldSystemFont(ofSize: 70.0)
        }
    }
    private func configureViewButton() {
        AllZodiacAnswerButtons.forEach { button in
            let buttonTitle = dictionaryUIButtonAndZodiac[button]?.textJapanese()
            button.setTitle(buttonTitle, for: .normal)
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


    // MARK: - 広告関係のメソッド
    private func configureAdBannar() {
        // GADBannerViewのプロパティを設定
        bannerView.adUnitID = "\(GoogleAdID.gameBannerID)"
        bannerView.rootViewController = self
        // 広告読み込み
        bannerView.load(GADRequest())
    }
    private func configureInterstitialAd() {
        // インタースティシャル広告
        let request = GADRequest()
        GADInterstitialAd.load(
            withAdUnitID: GoogleAdID.gameScreenInterstitialID,
            request: request,
            completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
            }
        )
    }
    //　Google広告を1回に表示するメソッド
    func showGoogleIntitialAdAndPerformSegue() {
        if interstitial != nil {
            interstitial?.present(fromRootViewController: self)
        } else {
            performSegue(withIdentifier: "result", sender: nil)
        }
    }
    //MARK: - progress
    private func initializeProgress() {
        progressDuration = 1.0
        answerTimerProgressView.tintColor = .black
        answerTimerProgressView.setProgress(progressDuration, animated: false)
    }
    private func startProgressTimer() {
        progressTimer
        = Timer
            .scheduledTimer(
                withTimeInterval: 0.01,
                repeats: true) { [weak self] _ in
                    self?.doneProgress()
                }
    }

    private func doneProgress() {
        let milliSecondProgress = 0.0001666
        progressDuration -= Float(milliSecondProgress)
        answerTimerProgressView.setProgress(progressDuration, animated: true)
        if progressDuration <= 0.0 {
            stopProgressTimer()
            guard let audioPlayer = audioPlayer else {
                showGoogleIntitialAdAndPerformSegue()
                return
            }
            audioPlayer.stop()
            showGoogleIntitialAdAndPerformSegue()
        }
    }

    private func stopProgressTimer(){
        progressTimer.invalidate()
    }
}
private extension GameViewController {
    @IBSegueAction
    func makeResultVC(coder: NSCoder, sender: Any?, segueIdentifier: String?) -> ResultViewController? {
        return ResultViewController(
            coder: coder,zodiacGame: zodiacGame
        )
    }

    @IBAction
    func backToGameViewController(segue: UIStoryboardSegue) {
    }
}

extension GameViewController: GADFullScreenContentDelegate {
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        performSegue(withIdentifier: "result", sender: nil)
    }
    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        performSegue(withIdentifier: "result", sender: nil)
    }
}

extension GameViewController: AVAudioPlayerDelegate {
    func playSound(name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音源ファイルが見つかりません")
            return
        }
        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))

            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self

            audioPlayer.prepareToPlay()
            if audioPlayer.isPlaying {
                        audioPlayer.stop()
                        audioPlayer.currentTime = 0
            }
            // 音声の再生
            audioPlayer.play()
        } catch {
        }
    }
}
