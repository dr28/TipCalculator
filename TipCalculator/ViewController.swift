//
//  ViewController.swift
//  TipCalculator
//
//  Created by Deepthy on 8/9/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var separationView: UIView!
    
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var taxText: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    let defaults = UserDefaults.standard
   
    var doNotTipOnTax = 0
    var showSlider = 0
    
    var defaultTipPercentage:Any? = nil //Amt without %

    var tipPercentage: [String]? = nil //[0.18,0.2,0.25]
    
    let localeSpecificFormatter = NumberFormatter()

    var localeSpecificCurrencySymbol : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        // Locale specific currency and thousands separator 
        localeSpecificFormatter.numberStyle = .currency
        
        localeSpecificCurrencySymbol = (Locale.current as NSLocale).displayName(forKey: .currencySymbol, value: Locale.current.currencyCode as Any)! // .object(forKey: .countryCode)

        billText.placeholder = localeSpecificCurrencySymbol
        tipLabel.text = localeSpecificCurrencySymbol
        totalLabel.text = localeSpecificCurrencySymbol
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        billText.becomeFirstResponder()

        self.navigationItem.rightBarButtonItem?.title = NSString(string: "\u{2699}\u{0000FE0E}") as String // Gear icon
        let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        let attributes = [NSFontAttributeName : font]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)

        defaultTipPercentage = defaults.object(forKey: "DEFAULT_TIP_PERCENTAGE")

        if(defaultTipPercentage == nil)
        {
            defaultTipPercentage = "20.00" as String // First time default
        }
        
        localeSpecificFormatter.numberStyle = .decimal
        localeSpecificFormatter.minimumFractionDigits = 2
        localeSpecificFormatter.maximumFractionDigits = 2

        tipPercentageLabel.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display

        
        doNotTipOnTax = defaults.integer(forKey: "DO_NOT_TIP_0N_TAX")
        
        taxText.isHidden = (doNotTipOnTax == 0)

        if(taxText.isHidden)
        {
            taxText.text = ""
        }
      

        showSlider = defaults.integer(forKey: "SHOW_TIP_SLIDER")

        tipSegmentControl.isHidden = (showSlider == 1)
        tipSlider.isHidden = !(showSlider == 1)

        
        if(tipSegmentControl.isHidden) // Show slider
        {
            separationView.backgroundColor = UIColor.init(hue: 0.35, saturation: 0.82, brightness: 0.53, alpha: 1)
            
            let tipMinPercentage = defaults.object(forKey: "TIP_MIN_PERCENTAGE")
            
            tipSlider.minimumValue = Float(tipMinPercentage as! String)!
            
            let tipMaxPercentage = defaults.object(forKey: "TIP_MAX_PERCENTAGE")

            tipSlider.maximumValue = Float(tipMaxPercentage as! String)!
            
            tipSlider.value = Float(defaultTipPercentage as! String)!
        }
        else { // Show segmented control
            
            separationView.backgroundColor = UIColor.clear
            
            let offset : Float = 5

            let tipMinPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! - offset)
            
            let tipMaxPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! + offset)
            
            // Locale specific display

            tipPercentage = [localeSpecificFormatter.string(from: Float(tipMinPercentage as String!)! as NSNumber)!.appending("%"),
            localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%"),
            localeSpecificFormatter.string(from: Float(tipMaxPercentage as String!)! as NSNumber)!.appending("%")]
            
            tipSegmentControl.selectedSegmentIndex = 1

            tipSegmentControl.setTitle(tipPercentage?[((tipPercentage?.count)! - (tipPercentage?.count)!)], forSegmentAt: ((tipPercentage?.count)! - (tipPercentage?.count)!))
            tipSegmentControl.setTitle(tipPercentage?[tipSegmentControl.selectedSegmentIndex], forSegmentAt: tipSegmentControl.selectedSegmentIndex)
            tipSegmentControl.setTitle(tipPercentage?[((tipPercentage?.count)! - tipSegmentControl.selectedSegmentIndex)], forSegmentAt: ((tipPercentage?.count)! - tipSegmentControl.selectedSegmentIndex))

        }
        
        if(!(billText.text?.isEmpty)!)
        {
            calculateTax()
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: Any) {
        
        view.endEditing(true)
        
    }
    
    @IBAction func calculateTax(_ sender: Any) {
        
        calculateTax()
        
    }
    
    func calculateTax()
    {
        
        let numFormatter = NumberFormatter() // convert locale specific currency number to number for calculation

        var convertedNum = numFormatter.number(from: billText.text!) ?? 0

        let bill = Double.init(convertedNum)

        var tax = 0.0

        convertedNum = numFormatter.number(from: (tipPercentageLabel.text?.replacingOccurrences(of: "%", with: ""))!) ?? 0
        
        let tipPercentage = Double.init(convertedNum)
        
        if(doNotTipOnTax == 1 && !(taxText.text?.isEmpty)!)
        {
            convertedNum = numFormatter.number(from: taxText.text!) ?? 0
            
            tax = Double.init(convertedNum)

        }
        
        let tip =  (bill - tax) * tipPercentage / 100
        
        let total = bill +  tip

        tipLabel.text = localeSpecificCurrencySymbol?.appending(localeSpecificFormatter.string(from: tip as NSNumber)!)

        totalLabel.text = localeSpecificCurrencySymbol?.appending(localeSpecificFormatter.string(from: total as NSNumber)!)
        
    }
    
    @IBAction func deductTaxFromBill(_ sender: Any) {
        calculateTax()
    }

    
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
        
        tipPercentageLabel.text = localeSpecificFormatter.string(from: tipSlider.value as NSNumber)!.appending("%") // Locale specific display

        calculateTax()

    }
    
    @IBAction func tipSegmentControlValueChanged(_ sender: Any) {
        
        tipPercentageLabel.text = tipPercentage?[tipSegmentControl.selectedSegmentIndex]
        calculateTax()
        
    }

}

