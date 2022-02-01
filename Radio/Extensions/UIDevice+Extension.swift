//
//  UIDevice+Extension.swift
//  Radio
//
//  Created by Andrii on 30.01.2022.
//

import UIKit

extension UIDevice {
    static var hasNotch: Bool {
        let bottom = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
