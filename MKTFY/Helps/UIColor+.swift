//
//  UIColor+.swift
//  MKTFY
//
//  Created by Derek Kim on 2023/01/30.
//

import UIKit

enum LPColor: String {
    case LightestPurple
    case MediumestPurple
    case DarkestPurple
    case OccasionalPurple
    case GoodGreen
    case SubtleGray
    case TextGray
    case MistakeRed
    case WarningYellow
    case VoidWhite
    case DisabledGray
    case HoverPurple
    case HoverYellow
    case TextGray40
    case TitleGray
    case VerySubtleGray
    case WarningYellow25
    case GrayButtonGray
}

extension UIColor {
    static func appColor(_ name: LPColor) -> UIColor! {
        return UIColor(named: name.rawValue)
    }
}

