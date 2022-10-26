//
//  UIColor+Utility.swift
//  MoviesApp
//
//  Created by Jorge Garay on 24/10/22.
//

import Foundation
import UIKit

enum AppColor: String {
    case background = "BackgroundApp"
    case darkBlue = "DarkBlue"
    case darkGray = "DarkGray"
    case backgroundNavigationBar = "NavigationBarBackground"
}

extension UIColor {
    static func appColor(_ color: AppColor) -> UIColor {
        // return white to indicate a color is missing from asset catalog
        return UIColor(named: color.rawValue) ?? UIColor.white
    }
}
