//
//  MCFonts.swift
//  MarsCamera
//
//  Created by Olha Pylypiv on 18.08.2024.
//

import UIKit

extension UIFont {
    static var customLargeTitle: UIFont {
        return UIFont(name: "SFPro-Bold", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .bold)
    }

    static var customTitle2: UIFont {
        return UIFont(name: "SFPro-Bold", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .bold)
    }

    static var customTitle: UIFont {
        return UIFont(name: "SFPro-Regular", size: 22) ?? UIFont.systemFont(ofSize: 22, weight: .regular)
    }

    static var customBody2: UIFont {
        return UIFont(name: "SFPro-Bold", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .bold)
    }

    static var customBody: UIFont {
        return UIFont(name: "SFPro-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular)
    }
}
