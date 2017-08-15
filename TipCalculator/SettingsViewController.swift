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
    
    
    let defaults = UserDefaults.standard
    
    var defaultTipPercentage:Any? = nil
    var tipMinPercentage:Any? = nil
    var tipMaxPercentage:Any? = nil
    let localeSpecificFormatter = NumberFormatter()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
        if(defaults.integer(forKey: "DO_NOT_TIP_0N_TAX") == 0)
        {
            doNotTipOnTax.isOn = false
        }
        
        showTipSlider.tag = 2
        if(defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)
        {
            showTipSlider.isOn = false
            tipMinLabel.isHidden = true
            tipMinText.isHidden = true
            tipMaxLabel.isHidden = true
            tipMaxText.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        if(textField.tag == defaultTaxText.tag)
        {
            let tempPercentText = defaultTaxText.text?.replacingOccurrences(of: "%", with: "")
            
            if(numFormatter.number(from: tempPercentText!) == nil || (defaultTaxText.text?.isEmpty)!) // invalid number
            {
                defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
            }
            else
            {
                defaultTipPercentage = numFormatter.number(from: tempPercentText!)?.stringValue//defaultTaxText.text?.replacingOccurrences(of: "%", with: "")
                
                defaultTaxText.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
                
            }
        }
        else if (textField.tag == tipMinText.tag)
        {
            let tempPercentText = tipMinText.text?.replacingOccurrences(of: "%", with: "")
            
            if(numFormatter.number(from: tempPercentText!) == nil || (tipMinText.text?.isEmpty)!) // invalid number
            {
                tipMinText.text = localeSpecificFormatter.string(from: Float(tipMinPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
            }
            else
            {
                tipMinPercentage = numFormatter.number(from: tempPercentText!)?.stringValue//tipMinText.text?.replacingOccurrences(of: "%", with: "")

                tipMinText.text = localeSpecificFormatter.string(from: Float(tipMinPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

            }
        }
        else{
            
            let tempPercentText = tipMaxText.text?.replacingOccurrences(of: "%", with: "")
            
            if(numFormatter.number(from: tempPercentText!) == nil || (tipMaxText.text?.isEmpty)!) // invalid number
            {
                tipMaxText.text = localeSpecificFormatter.string(from: Float(tipMaxPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

            }
            else{
                
                tipMaxPercentage = numFormatter.number(from: tempPercentText!)?.stringValue // Locale specific display
                //tipMaxText.text?.replacingOccurrences(of: "%", with: "")

                tipMaxText.text = localeSpecificFormatter.string(from: Float(tipMaxPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
                
            }
        }
        storeTextValue(tag: textField.tag)

    }
    
    @IBAction func uiSwitchValueChange(_ sender: Any) {
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
        else
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func errorAlertActionWithStyle(msg: String)
    {
        let appColor: UIColor = UIColor.init(hue: 0.35, saturation: 0.82, brightness: 0.53, alpha: 1)
        
        let attributedTitleString = NSAttributedString(string: "Tip Calculator", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 17), //your font here,
            NSForegroundColorAttributeName : appColor])
        
        let attributedMsgString = NSMutableAttributedString(string: "", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 15), //your font here,
            NSForegroundColorAttributeName : appColor])
        
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
        
        // alertContentView.backgroundColor = UIColor.yellow()
        alertContentView.layer.cornerRadius = 12
        alertContentView.layer.borderWidth = 1
        alertContentView.layer.borderColor = appColor.cgColor
        
        alertController.view.tintColor = appColor
        
    }

}
