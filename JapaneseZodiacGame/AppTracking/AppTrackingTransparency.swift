//
//  AppTrackingTransparency.swift
//  CommunicationBoard
//
//  Created by 村中令 on 2022/08/13.
//

import Foundation
import AdSupport
import AppTrackingTransparency

// 参考
// https://qiita.com/koooootake/items/e467be2c4f63ff605841

struct AppTrackingTransparency {
    static func showRequestTrackingAuthorizationAlert() {
        if #available(iOS 14.5, *) {
            // .notDeterminedの場合にだけリクエスト呼び出しを行う
            guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return }

            // タイミングを遅らせる為に処理を遅延させる
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
                    // リクエスト後の状態に応じた処理を行う
                })
            }
        }
    }
}

/*
 ViewControllerでの使用方法
 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓
 if #available(iOS 14, *) {
 switch ATTrackingManager.trackingAuthorizationStatus {
 case .authorized,.denied,.restricted:
 break
 case .notDetermined:
 AppTrackingTransparency.showRequestTrackingAuthorizationAlert()
 @unknown default:
 fatalError()
 }
 }
 */
