//
//  Keys.swift
//  3rdplanet
//
//  Created by zeus on 3/9/17.
//  Copyright © 2017 justzeus. All rights reserved.
//

import Foundation
import UIKit

class Keys {
    
    static let shared = Keys()
    
    // earth
    let schemeColor1 = UIColor(colorLiteralRed: 30 / 255, green: 166 / 255, blue: 255 / 255, alpha: 1)
    // water
    let schemeColor2 = UIColor(colorLiteralRed: 255 / 255, green: 97 / 255, blue: 94 / 255, alpha: 1)
    // wind
    let schemeColor3 = UIColor(colorLiteralRed: 79 / 255, green: 210 / 255, blue: 194 / 255, alpha: 1)
    // fire
    let schemeColor4 = UIColor(colorLiteralRed: 152 / 255, green: 145 / 255, blue: 255 / 255, alpha: 1)
    // electric
    let schemeColor5 = UIColor(colorLiteralRed: 255 / 255, green: 145 / 255, blue: 223 / 255, alpha: 1)
    // space
    let schemeColor6 = UIColor(colorLiteralRed: 255 / 255, green: 219 / 255, blue: 143 / 255, alpha: 1)
    // void
    let schemeColor7 = UIColor(colorLiteralRed: 255 / 255, green: 156 / 255, blue: 105 / 255, alpha: 1)
    
    func colorFrom(colorKey: String) -> UIColor {
        switch colorKey {
        case "schemeColor1":
            return Keys.shared.schemeColor1
        case "schemeColor2" :
            return Keys.shared.schemeColor2
        case "schemeColor3" :
            return Keys.shared.schemeColor3
        case "schemeColor4" :
            return Keys.shared.schemeColor4
        case "schemeColor5" :
            return Keys.shared.schemeColor5
        case "schemeColor6" :
            return Keys.shared.schemeColor6
        default:
            return Keys.shared.schemeColor7
        }
    }
    
    //extra colors
    let schemeColor8 = UIColor(colorLiteralRed: 112/255, green: 166/255, blue: 255/255, alpha: 1)
    let schemeColor9 = UIColor(colorLiteralRed: 94/255, green: 209/255, blue: 195/255, alpha: 1)
    
    
    // textStyle? celltextStyle?
    let textColor = UIColor(colorLiteralRed: 3 / 255, green: 3 / 255, blue: 3 / 255, alpha: 1)
    let font = UIFont(name: "Avenir", size: 17)
    
    
   // let iconNames = []
    
}
