//
//  Theme.swift
//  TipCalculator
//
//  Created by Deepthy on 8/16/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit
let SelectedThemeKey = "SelectedTheme"

enum Theme: Int {
    case Default, Dark
    
    var mainColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 24.0/255.0, green: 135.0/255.0, blue: 39.0/255.0, alpha: 1.0) // green

        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0) //0.094, 0.396, 0.133 //orange

        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 244.0/255.0, green: 255.0/255.0, blue: 217.0/255.0, alpha: 1.0)
        
        case .Dark:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0) //0.039, 0.039, 0.039
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .Default:
            return .default
        case .Dark:
            return .black
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 186.0/255.0, green: 255.0/255.0, blue: 151.0/255.0, alpha: 1.0)

        case .Dark:
            return UIColor(red: 197.0/255.0, green: 190.0/255.0, blue: 185.0/255.0, alpha: 1.0).withAlphaComponent(0.2)
        }
    }

}

struct ThemeManager {
    
    static func currentTheme() -> Theme {
        if let storedTheme = (UserDefaults.standard.value(forKey: SelectedThemeKey) as AnyObject).integerValue {
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
   
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.setValue(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = UIApplication.shared
        sharedApplication.delegate?.window??.tintColor = theme.mainColor
        
        //  UIStepper
        
        UIStepper.appearance().tintColor = theme.backgroundColor

        let incrementImageFromFile :UIImage = UIImage.init(named: "Up")!
        let incImgView = UIImageView.init(image: incrementImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        
        let derementImageFromFile :UIImage = UIImage.init(named: "Down")!
        let decImgView = UIImageView.init(image: derementImageFromFile.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        
        UIImageView.appearance().tintColor = ThemeManager.currentTheme().mainColor

        UIStepper.appearance().setIncrementImage(incImgView.image, for: .normal)
        UIStepper.appearance().setDecrementImage(decImgView.image, for: .normal)

        UIStepper.appearance().setBackgroundImage(UIImage.init(), for : .normal)
        UIStepper.appearance().setBackgroundImage(UIImage.init(), for : .highlighted)
        UIStepper.appearance().setDividerImage(UIImage.init(), forLeftSegmentState : .normal, rightSegmentState : .normal)

        UITextField.appearance().textColor = theme.mainColor//.withAlphaComponent(0.3)

        UILabel.appearance().textColor = theme.mainColor

        //  UISlider

        UISlider.appearance().minimumTrackTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISlider.appearance().maximumTrackTintColor = theme.secondaryColor//.withAlphaComponent(0.3)

        UISlider.appearance().thumbTintColor = theme.mainColor
        UISlider.appearance().minimumValueImage = (UIImage(named: "Dollar")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        UISlider.appearance().maximumValueImage = (UIImage(named: "Dollars")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        UISlider.appearance().tintColor = theme.mainColor
        
    }
}
