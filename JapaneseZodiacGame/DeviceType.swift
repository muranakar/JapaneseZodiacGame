//
//  DeviceType.swift
//  MojiSagashi
//
//  Created by 村中令 on 2022/08/24.
//

import Foundation
import UIKit

struct DeviceType {
    static func isIPhone() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    static func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
