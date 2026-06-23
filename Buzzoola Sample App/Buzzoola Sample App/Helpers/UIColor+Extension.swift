//
//  UIColor+Extension.swift
//  BuzzoolaSampleApp
//

import Foundation
import UIKit

extension UIColor {

    // MARK: Initializers

    convenience init(red: Int, green: Int, blue: Int) {
        let divisor: CGFloat = 255.0
        let aRed    = CGFloat(red) / divisor
        let aGreen  = CGFloat(green) / divisor
        let aBlue   = CGFloat(blue) / divisor

        self.init(red: aRed, green: aGreen, blue: aBlue, alpha: 1.0)
    }

    convenience init(red: Int, green: Int, blue: Int, transparency: CGFloat) {
        let divisor: CGFloat = 255.0
        let aRed    = CGFloat(red) / divisor
        let aGreen  = CGFloat(green) / divisor
        let aBlue   = CGFloat(blue) / divisor

        self.init(red: aRed, green: aGreen, blue: aBlue, alpha: transparency)
    }
}
