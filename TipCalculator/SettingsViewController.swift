//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Deepthy on 8/10/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var doNotTipOnTax: UISwitch!
    @IBOutlet weak var defaultTaxText: UITextField!
    
    @IBOutlet weak var showTipSlider: UISwitch!
    
    @IBOutlet weak var tipMinLabel: UILabel!
    @IBOutlet weak var tipMinText: UITextField!
    
    
    @IBOutlet weak var tipMaxLabel: UILabel!
    @IBOutlet weak var tipMaxText: UITextField!
    
    @IBOutlet weak var themeSelector: UISwitch!
    
    let defaults = UserDefaults.standard
    
    var defaultTipPercentage:Any? = nil
    var tipMinPercentage:Any? = nil
    var tipMaxPercentage:Any? = nil
    let localeSpecificFormatter = NumberFormatter()
    var errMsg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       // self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        
        UIView.animate(withDuration: 1, animations: {
            self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor
        }, completion: nil)
        
        self.view.subviews.forEach { (view) in
            if(view.isKind(of: UILabel.self))
            {
                let label : UILabel = view as! UILabel

                label.textColor = ThemeManager.currentTheme().mainColor

            }
            else if(view.isKind(of: UITextField.self))
            {
                let textfield : UITextField = view as! UITextField
                textfield.textColor = ThemeManager.currentTheme().mainColor
                
            }
            else
            {
                if(view.isKind(of: UISwitch.self))
                {
                    let allSwitch : UISwitch = view as! UISwitch
                    allSwitch.thumbTintColor = ThemeManager.currentTheme().mainColor
                    allSwitch.onTintColor = ThemeManager.currentTheme().mainColor.withAlphaComponent(0.3)

                }
            }

        }
        
        
        defaultTaxText.tag = 1
        tipMinText.tag = 2
        tipMaxText.tag = 3
        
        defaultTipPercentage = defaults.object(forKey: "DEFAULT_TIP_PERCENTAGE")

        if(defaultTipPercentage == nil || (defaultTipPercentage as! String).compare("0.00").rawValue == 0)
        {
            defaultTipPercentage = "20.00" as String
        }
        
        localeSpecificFormatter.numberStyle = .decimal
        localeSpecificFormatter.minimumFractionDigits = 2
        localeSpecificFormatter.maximumFractionDigits = 2

        defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

        tipMinPercentage = defaults.object(forKey: "TIP_MIN_PERCENTAGE")

        if(tipMinPercentage == nil)
        {
            tipMinPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! - 10)
        }
        
        tipMinText.text = localeSpecificFormatter.string(from: Float(tipMinPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

        tipMaxPercentage = defaults.object(forKey: "TIP_MAX_PERCENTAGE")

        if(tipMaxPercentage == nil)
        {
            tipMaxPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! + 10)
        }
        
        tipMaxText.text = localeSpecificFormatter.string(from: Float(tipMaxPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

        doNotTipOnTax.tag = 1
    
        doNotTipOnTax.isOn = !(defaults.integer(forKey: "DO_NOT_TIP_0N_TAX") == 0)
        
        
        showTipSlider.tag = 2
       
        showTipSlider.isOn = !(defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)//false
        tipMinLabel.isHidden = (defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)//true
        tipMinText.isHidden = (defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)//true
        tipMaxLabel.isHidden = (defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)//true
        tipMaxText.isHidden = (defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)//true
                
        themeSelector.tag = 3
        
        themeSelector.isOn = !(defaults.integer(forKey: "DARK_THEME") == 0)
        
        
    }

    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func clearText(_ sender: Any) {

        let textField : UITextField = sender as! UITextField
        
        if(textField.tag == defaultTaxText.tag)
        {
            defaultTaxText.text = ""

        }
        else if (textField.tag == tipMinText.tag)
        {
            tipMinText.text = ""
            
        }
        else{
            tipMaxText.text = ""

        }

    }
    
    @IBAction func editingEnded(_ sender: Any) {
        
        let textField : UITextField = sender as! UITextField
        
        let numFormatter = NumberFormatter() // convert locale specific currency number to number for calculation
        //numFormatter.numberStyle = .decimal
        
        var temp : String = ""

        if(textField.tag == defaultTaxText.tag)
        {
            let tempPercentText = defaultTaxText.text?.replacingOccurrences(of: "%", with: "")
            
            if(!(numFormatter.number(from: tempPercentText!) == nil || (defaultTaxText.text?.isEmpty)!)) // invalid number
            {
                //defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
            //}
            //else
            //{
                temp = defaultTipPercentage as! String

                defaultTipPercentage = numFormatter.number(from: tempPercentText!)?.stringValue//defaultTaxText.text?.replacingOccurrences(of: "%", with: "")
                
                if(!validatePercentageValues())
                {
                    defaultTipPercentage = temp
                    
                    if(errMsg.isEmpty)
                    {
                        errMsg = "Default Tip should be between Tip Max and Tip Min"
                        
                    }
                    errorAlertActionWithStyle(msg: errMsg)
                    
                }
                
                //defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
                
            }
            defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

        }
        else if (textField.tag == tipMinText.tag)
        {
            let tempPercentText = tipMinText.text?.replacingOccurrences(of: "%", with: "")
            
            if(!(numFormatter.number(from: tempPercentText!) == nil || (tipMinText.text?.isEmpty)!)) // invalid number
            {
                temp = tipMinPercentage as! String

                tipMinPercentage = numFormatter.number(from: tempPercentText!)?.stringValue//tipMinText.text?.replacingOccurrences(of: "%", with: "")
                
                if(!validatePercentageValues())
                {
                    tipMinPercentage = temp
                    if(errMsg.isEmpty)
                    {
                        errMsg = "Tip Min cannot be greater than Default Tip or Max Tip"

                    }
                    errorAlertActionWithStyle(msg: errMsg)
                    
                }
            }
            tipMinText.text = localeSpecificFormatter.string(from: Float(tipMinPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

        }
        else{
            
            let tempPercentText = tipMaxText.text?.replacingOccurrences(of: "%", with: "")
            
            if(!(numFormatter.number(from: tempPercentText!) == nil || (tipMaxText.text?.isEmpty)!)) // invalid number
            {

                temp = tipMaxPercentage as! String
                
                tipMaxPercentage = numFormatter.number(from: tempPercentText!)?.stringValue // Locale specific display
                //tipMaxText.text?.replacingOccurrences(of: "%", with: "")

                if(!validatePercentageValues())
                {
                    tipMaxPercentage = temp
                    
                    if(errMsg.isEmpty)
                    {
                        errMsg = "Tip Max cannot be less than Default Tip or Min Tip "
                    }
                    errorAlertActionWithStyle(msg: errMsg)

                    
                }

            }
            tipMaxText.text = localeSpecificFormatter.string(from: Float(tipMaxPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
        }
        errMsg = ""
        storeTextValue(tag: textField.tag)

    }
    
    func validatePercentageValues() -> Bool
    {
        var flag : Bool = true
        
        if (  !((Float(tipMaxPercentage as! String)!).subtracting(Float(tipMinPercentage as! String)!) == 0  ))
        {
            if ( !( (Float(tipMaxPercentage as! String)!).subtracting(Float(defaultTipPercentage as! String)!) >= 0   &&  (Float(defaultTipPercentage as! String)!).subtracting(Float(tipMinPercentage as! String)!) >= 0  ) )
            {
                flag = false
            }
        }
        else {
            errMsg = "Tip Max and Tip Min cannot be the same"
            flag = false

        }
        return flag
    }
    
    @IBAction func uiSwitchValueChange(_ sender: Any) {
        print("uiSwitchValueChange")
        
        let uiSwitch : UISwitch = sender as! UISwitch
        
        self.view.endEditing(true)

        if(uiSwitch.tag == 1)
        {
            var tipOnTaxValue = 0
        
            if(doNotTipOnTax.isOn)
            {
                tipOnTaxValue = 1
            }
            
            defaults.set(tipOnTaxValue, forKey: "DO_NOT_TIP_0N_TAX")
            defaults.synchronize()
        }
        else if(uiSwitch.tag == 2)
        {
            var showSlider = 0
            
            tipMinLabel.isHidden = !showTipSlider.isOn
            tipMinText.isHidden = !showTipSlider.isOn
            tipMaxLabel.isHidden = !showTipSlider.isOn
            tipMaxText.isHidden = !showTipSlider.isOn
            
            if(showTipSlider.isOn)
            {
                showSlider = 1
                
                tipMinPercentage = tipMinText.text?.replacingOccurrences(of: "%", with: "")
                tipMaxPercentage = tipMaxText.text?.replacingOccurrences(of: "%", with: "")
                
                let numFormatter = NumberFormatter() // convert locale specific number to number for calculation
                
                var convertedNum = numFormatter.number(from: tipMinPercentage! as! String) ?? 0
                
                var convertedNum2Double = Double.init(convertedNum)
                
                defaults.set(String(format: "%.2f", convertedNum2Double), forKey: "TIP_MIN_PERCENTAGE" )
                
                convertedNum = numFormatter.number(from: tipMaxPercentage! as! String) ?? 0
                
                convertedNum2Double = Double.init(convertedNum)
                
                defaults.set(String(format: "%.2f", convertedNum2Double), forKey: "TIP_MAX_PERCENTAGE" )

            }
            defaults.set(showSlider, forKey: "SHOW_TIP_SLIDER")
            defaults.synchronize()
        }
        else{
            var darkTheme = 0
            
            if(themeSelector.isOn)
            {
                darkTheme = 1
            }
            
            defaults.set(darkTheme, forKey: "DARK_THEME")
            defaults.synchronize()
            
            self.viewWillAppear(false)

        }
    }
    
    @IBAction func minTipTextEditingChanged(_ sender: Any) {
        
        let textField : UITextField = sender as! UITextField
        
        storeTextValue(tag: textField.tag)

    }
    
    @IBAction func maxTipTextEditingChanged(_ sender: Any) {

        let textField : UITextField = sender as! UITextField

        storeTextValue(tag: textField.tag)

    }
    @IBAction func defaultTipTextEditingChanged(_ sender: Any) {
        
        let textField : UITextField = sender as! UITextField
        
        storeTextValue(tag: textField.tag)

    }
    
    
    func storeTextValue(tag:Int)
    {
        let numFormatter = NumberFormatter() // convert locale specific currency number to number for calculation

        if(tag == defaultTaxText.tag)
        {
            
            let tempPercentText = defaultTaxText.text?.replacingOccurrences(of: "%", with: "")
            
            
            
            let convertedNum = numFormatter.number(from: tempPercentText!) ?? Float(defaultTipPercentage! as! String)! as NSNumber
            
            if(numFormatter.number(from: tempPercentText!) == nil) // invalid number
            {
                if(!tempPercentText!.isEmpty)
                {
                    defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

                    defaults.set(defaultTipPercentage as! String, forKey: "DEFAULT_TIP_PERCENTAGE" )
                    
                    errorAlertActionWithStyle(msg: "Invalid number")
                }

            }
            else {
                
                let tipDefault = Double.init(convertedNum)
                
                defaults.set(String(format: "%.2f", tipDefault), forKey: "DEFAULT_TIP_PERCENTAGE" )
                
            }
            
        }
        else if(tag == tipMinText.tag)
        {
            let tempPercentText = tipMinText.text?.replacingOccurrences(of: "%", with: "")
            
            let convertedNum = numFormatter.number(from: tempPercentText!) ?? numFormatter.number(from: tipMinPercentage! as! String) //Float(tipMinPercentage! as! String)! as NSNumber

            if(numFormatter.number(from: tempPercentText!) == nil) // invalid number
            {
                if(!tempPercentText!.isEmpty)
                {
                    tipMinText.endEditing(true)
                    
                    tipMinPercentage = String(format: "%.2f", Double(tipMinPercentage as! String)!)
                    tipMinText.text = (tipMinPercentage as! String).appending("%")
                    defaults.set(tipMinPercentage as! String, forKey: "TIP_MIN_PERCENTAGE" )

                    errorAlertActionWithStyle(msg: "Invalid number")
                }
                
            }
            else {
                
                let tipMin = Double.init(convertedNum!)
                
                defaults.set(String(format: "%.2f", tipMin), forKey: "TIP_MIN_PERCENTAGE" )

            }

        }
        else
        {
            let tempPercentText = tipMaxText.text?.replacingOccurrences(of: "%", with: "")
            
            let convertedNum = numFormatter.number(from: tempPercentText!) ?? numFormatter.number(from: tipMinPercentage! as! String) //Float(tipMinPercentage! as! String)! as NSNumber


            if(numFormatter.number(from: tempPercentText! ) == nil) // invalid number
            {
                if(!tempPercentText!.isEmpty)
                {
                    
                    tipMaxText.endEditing(true) //if this is added then, the textbox wont be cleared after message
                    
                    tipMaxPercentage = String(format: "%.2f", Double(tipMaxPercentage as! String)!)
                    
                    tipMaxText.text = (tipMaxPercentage as! String).appending("%")
                    defaults.set(tipMaxPercentage as! String, forKey: "TIP_MAX_PERCENTAGE" )
                
                    errorAlertActionWithStyle(msg: "Invalid number")
                }
            }
            else {

                let tipMax = Double.init(convertedNum!)
                
                defaults.set(String(format: "%.2f", tipMax), forKey: "TIP_MAX_PERCENTAGE" )
                
            }

        }
        defaults.synchronize()

    }
 
    
    func errorAlertActionWithStyle(msg: String)
    {
        let attributedTitleString = NSAttributedString(string: "Tip Calculator", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 17), //your font here,
            NSForegroundColorAttributeName : ThemeManager.currentTheme().mainColor])
        
        let attributedMsgString = NSMutableAttributedString(string: "", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15), //your font here,
            NSForegroundColorAttributeName : ThemeManager.currentTheme().mainColor])
        
        if(msg.isEmpty != true)
        {
            let attributedErrMsgString = NSAttributedString(string: "\n".appending(msg), attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 15), //your font here,
                NSForegroundColorAttributeName : UIColor.red])
            attributedMsgString.append(attributedErrMsgString)
            
        }
        
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alertController.setValue(attributedTitleString, forKey: "attributedTitle")
        alertController.setValue(attributedMsgString, forKey: "attributedMessage")
        
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Pressed OK button");
        }
        alertController.addAction(OKAction)
        
        present(alertController, animated: true, completion:nil)
        
        let subview = alertController.view.subviews.first! as UIView
        //subview.backgroundColor = UIColor.orange()
        
        let alertContentView = subview.subviews.first! as UIView
        
        //alertContentView.backgroundColor = ThemeManager.currentTheme().secondaryColor
        alertContentView.layer.cornerRadius = 12
        alertContentView.layer.borderWidth = 1
        alertContentView.layer.borderColor = ThemeManager.currentTheme().mainColor.cgColor
        
        alertController.view.tintColor = ThemeManager.currentTheme().mainColor
        
    }
    
    
    @IBAction func applyTheme(_ sender: Any) {
        
        if let selectedTheme = Theme(rawValue: themeSelector.isOn.hashValue) {
            ThemeManager.applyTheme(theme: selectedTheme)

        }

    }
    
   
    

}
