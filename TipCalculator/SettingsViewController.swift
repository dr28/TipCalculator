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


    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        defaultTaxText.tag = 1
        tipMinText.tag = 2
        tipMaxText.tag = 3
        
        defaultTipPercentage = defaults.object(forKey: "DEFAULT_TIP_PERCENTAGE")
        //let intValue = defaults.integerForKey("another_key_that_you_choose")
        if(defaultTipPercentage == nil)
        {
            //print("entered")
            defaultTipPercentage = "20.00" as String
        }
        else
        {
            defaultTipPercentage = (defaultTipPercentage as! String).replacingOccurrences(of: "%", with: "")
        }
        //print("------\(defaultTipPercentage as! String)")
        defaultTaxText.text = (defaultTipPercentage as! String).appending("%")

        
        tipMinPercentage = defaults.object(forKey: "TIP_MIN_PERCENTAGE")
        //print("tipMinPercentage------\(tipMinPercentage)")

        if(tipMinPercentage == nil)
        {
            //print("entered")
            tipMinPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! - 10)
        }
        else
        {
            tipMinPercentage = (tipMinPercentage as! String).replacingOccurrences(of: "%", with: "")
        }
        tipMinText.text = (tipMinPercentage as! String).appending("%")

        tipMaxPercentage = defaults.object(forKey: "TIP_MAX_PERCENTAGE")
        //print("tipMaxPercentage------\(tipMaxPercentage)")

        if(tipMaxPercentage == nil)
        {
            //print("entered")
            tipMaxPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! + 10)
        }
        else
        {
            tipMaxPercentage = (tipMaxPercentage as! String).replacingOccurrences(of: "%", with: "")
        }
        tipMaxText.text = (tipMaxPercentage as! String).appending("%")


        //print("--%^%^%^%^%^%^---\(defaults.integer(forKey: "DO_NOT_TIP_0N_TAX"))")

        doNotTipOnTax.tag = 1
        if(defaults.integer(forKey: "DO_NOT_TIP_0N_TAX") == 0)
        {
            doNotTipOnTax.isOn = false
           // defaults.set(0, forKey: "DO_NOT_TIP_0N_TAX")
           // defaults.synchronize()

        }
        showTipSlider.tag = 2

        if(defaults.integer(forKey: "SHOW_TIP_SLIDER") == 0)
        {
            showTipSlider.isOn = false
            // defaults.set(0, forKey: "DO_NOT_TIP_0N_TAX")
            // defaults.synchronize()
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
        print("clearText")
        let textField : UITextField = sender as! UITextField
        if(textField.tag == 1)
        {
            defaultTaxText.text = ""

        }
        else if (textField.tag == 2)
        {
            tipMinText.text = ""
            
        }
        else{
            tipMaxText.text = ""

        }

    }
    
    @IBAction func editingEnded(_ sender: Any) {
        print("editingEnded")
        
        let textField : UITextField = sender as! UITextField
        if(textField.tag == 1)
        {

            if(defaultTaxText.text == nil || (defaultTaxText.text?.isEmpty)!)
            {
                //print("editingEnded is == nil or empty")

                defaultTaxText.text = String(format: "%.2f", Float(defaultTipPercentage as! String)!).appending("%")
            }
            else
            {
                defaultTaxText.text = String(format: "%.2f", Float(defaultTaxText.text!)!).appending("%")

            }

        }
        else if (textField.tag == 2)
        {
            if(tipMinText.text == nil || (tipMinText.text?.isEmpty)!)
            {
                tipMinText.text = String(format: "%.2f", Float(tipMinPercentage as! String)!).appending("%")
            }
            else
            {
                tipMinText.text = String(format: "%.2f", Float(tipMinText.text!)!).appending("%")
                
            }
            //print("tipMinText.text --** \(tipMinText.text)")


        }
        else{
            if(tipMaxText.text == nil || (tipMaxText.text?.isEmpty)!)
            {
                tipMaxText.text = String(format: "%.2f", Float(tipMaxPercentage as! String)!).appending("%")
            }
            else{
                tipMaxText.text = String(format: "%.2f", Float(tipMaxText.text!)!).appending("%")

            }
            //print("tipMaxText --** \(tipMaxText.text)")


            
        }
        storeTextValue(tag: textField.tag)


        
        

    }
    
    @IBAction func uiSwitchValueChange(_ sender: Any) {
        let uiSwitch : UISwitch = sender as! UISwitch
        print("uiSwitchValueChange")
        
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
            
            if(showTipSlider.isOn)
            {
                showSlider = 1
                tipMinLabel.isHidden = false
                tipMinText.isHidden = false
                tipMaxLabel.isHidden = false
                tipMaxText.isHidden = false
                defaults.set(tipMinText.text, forKey: "TIP_MIN_PERCENTAGE" )
                defaults.set(tipMaxText.text, forKey: "TIP_MAX_PERCENTAGE" )


                
            }
            else{
                tipMinLabel.isHidden = true
                tipMinText.isHidden = true
                tipMaxLabel.isHidden = true
                tipMaxText.isHidden = true
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
        print("storeTextValue function")
        //print("defaultTaxText \(defaultTaxText.text)")


        if(tag == 1)
        {
            defaultTipPercentage = defaultTaxText.text?.replacingOccurrences(of: "%", with: "")

            defaults.set(String(format: "%.2f", Float(defaultTipPercentage as! String)!).appending("%"), forKey: "DEFAULT_TIP_PERCENTAGE" )
            
        }
        else if(tag == 2)
        {
            tipMinPercentage = tipMinText.text?.replacingOccurrences(of: "%", with: "")
            defaults.set(tipMinText.text, forKey: "TIP_MIN_PERCENTAGE" )
            
        }
        else
        {
            tipMaxPercentage = tipMaxText.text?.replacingOccurrences(of: "%", with: "")
            defaults.set(tipMaxText.text, forKey: "TIP_MAX_PERCENTAGE" )
            
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

}
