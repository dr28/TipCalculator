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
            // return UIColor(red: 87.0/255.0, green: 188.0/255.0, blue: 95.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0) //orange /*UIColor(white: 0.9, alpha: 1.0)*/
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .Default:
            return UIColor(red: 244.0/255.0, green: 255.0/255.0, blue: 217.0/255.0, alpha: 1.0)//UIColor(red: 139.0/255.0, green: 255.0/255.0, blue: 140.0/255.0, alpha: 1.0)

            //return UIColor(white: 0.9, alpha: 1.0)
        case .Dark:
            return UIColor(red: 10.0/255.0, green: 10.0/255.0, blue: 10.0/255.0, alpha: 1.0)
            //return UIColor.black//UIColor(white: 0.8, alpha: 1.0)
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
            return UIColor(red: 242.0/255.0, green: 101.0/255.0, blue: 34.0/255.0, alpha: 1.0)
        case .Dark:
            return UIColor(red: 34.0/255.0, green: 128.0/255.0, blue: 66.0/255.0, alpha: 1.0)
            //return UIColor(red: 140.0/255.0, green: 50.0/255.0, blue: 48.0/255.0, alpha: 1.0)
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
        
        //UINavigationBar.appearance().barStyle = theme.barStyle
        
        UITextField.appearance().textColor = theme.mainColor//.withAlphaComponent(0.3)

        //let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        //let attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : theme.mainColor]
        //UIBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)

        // UIBarButtonItem.titleTextAttributes(<#T##UIBarItem#>)

        //let customFont = UIFont.systemFont(ofSize: 28)//UIFont(name: "Verdana", size: 16)!  //note we're force unwrapping here
        
        
        //var fontAttributes: [String: Any]
        //fontAttributes = [NSForegroundColorAttributeName: theme.mainColor, NSFontAttributeName: customFont]
        //UINavigationBar.appearance().titleTextAttributes = fontAttributes

        //UINavigationBar.appearance().barTintColor = theme.mainColor
        
        //UIBarButtonItem.appearance().setTitleTextAttributes(fontAttributes, for: .normal)
        
        UILabel.appearance().textColor = theme.mainColor//.withAlphaComponent(0.1)
        UILabel.appearance(whenContainedInInstancesOf: [UIView.self]).tintColor = ThemeManager.currentTheme().mainColor

        UIImageView.appearance().tintColor = theme.mainColor
        
        UISwitch.appearance().onTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISwitch.appearance().thumbTintColor = theme.mainColor
        
        UISlider.appearance().minimumTrackTintColor = theme.mainColor.withAlphaComponent(0.3)
        UISlider.appearance().thumbTintColor = theme.mainColor
        UISlider.appearance().backgroundColor = UIColor.clear
        //UISlider.appearance().setThumbImage(UIImage(named: "Thumb"), for: UIControlState())


        UISlider.appearance().minimumValueImage = (UIImage(named: "Dollar")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        UISlider.appearance().maximumValueImage = (UIImage(named: "Dollars")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))
        UISlider.appearance().tintColor = theme.mainColor


        UISegmentedControl.appearance().tintColor = theme.mainColor//.withAlphaComponent(0.3)
        
        UISegmentedControl.appearance().backgroundColor = theme.backgroundColor//.withAlphaComponent(0.3)

        UISwitch.appearance().thumbTintColor = theme.mainColor        
    }
}
