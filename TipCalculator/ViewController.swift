//
//  ViewController.swift
//  TipCalculator
//
//  Created by Deepthy on 8/9/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let steps: Float = 1.0

    @IBOutlet weak var separationView: UIView!
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!
    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var taxText: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var defaultTipPercentage:Any? = nil
    var doNotTipOnTax = 0
    var showSlider = 0
    var tipPercentage: [String]? = nil //[0.18,0.2,0.25]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        taxText.isHidden = true
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        billText.becomeFirstResponder()

        self.navigationItem.rightBarButtonItem?.title = NSString(string: "\u{2699}\u{0000FE0E}") as String
        let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        let attributes = [NSFontAttributeName : font]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)        //

        defaultTipPercentage = defaults.object(forKey: "DEFAULT_TIP_PERCENTAGE")

        if(defaultTipPercentage == nil)
        {
            defaultTipPercentage = "20.00" as String
        }
        else
        {
            defaultTipPercentage = (defaultTipPercentage as! String).replacingOccurrences(of: "%", with: "")
        }

        tipPercentageLabel.text = (defaultTipPercentage as! String).appending("%")

        //print("------\(defaultTipPercentage as! String)")
        
        doNotTipOnTax = defaults.integer(forKey: "DO_NOT_TIP_0N_TAX")
        
        if(doNotTipOnTax == 1)
        {
            taxText.isHidden = false
        }
        else{
            taxText.text = ""
            taxText.isHidden = true

        }

        
        if(!(billText.text?.isEmpty)!)
        {
            calculateTax()
        }
        
        showSlider = defaults.integer(forKey: "SHOW_TIP_SLIDER")
        if(showSlider == 1)
        {
            separationView.backgroundColor = UIColor.init(hue: 0.35, saturation: 0.82, brightness: 0.53, alpha: 1)

            tipSegmentControl.isHidden = true
            tipSlider.isHidden = false
            
            var tipMinPercentage = defaults.object(forKey: "TIP_MIN_PERCENTAGE")
            //print("tipMinPercentage \(tipMinPercentage)")

            tipMinPercentage = (tipMinPercentage! as! String).replacingOccurrences(of: "%", with: "")

            tipSlider.minimumValue = Float(tipMinPercentage as! String)!
            
            //print("tipSlider.minimumValue \(tipSlider.minimumValue)")
            
            var tipMaxPercentage = defaults.object(forKey: "TIP_MAX_PERCENTAGE")
            //print("tipMaxPercentage \(tipMaxPercentage)")
            
            tipMaxPercentage = (tipMaxPercentage! as! String).replacingOccurrences(of: "%", with: "")
            

            tipSlider.maximumValue = Float(tipMaxPercentage as! String)!
            
            //print("maximumValue \(tipSlider.maximumValue)")

            tipSlider.value = Float((defaultTipPercentage as! String).replacingOccurrences(of: "%", with: ""))!
        }
        else{
            
            tipSlider.isHidden = true
            separationView.backgroundColor = UIColor.clear
            tipSegmentControl.isHidden = false
            
            let tipMinPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! - 5)
            let tipMaxPercentage = String(format: "%.2f", Float(defaultTipPercentage as! String)! + 5)

            tipPercentage = [tipMinPercentage.appending("%"),(defaultTipPercentage as! String).appending("%"),tipMaxPercentage.appending("%")]

            tipSegmentControl.setTitle(tipMinPercentage.appending("%"), forSegmentAt: 0)
            tipSegmentControl.setTitle((defaultTipPercentage as! String).appending("%"), forSegmentAt: 1)
            tipSegmentControl.setTitle(tipMaxPercentage.appending("%"), forSegmentAt: 2)
            tipSegmentControl.selectedSegmentIndex = 1

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
        //print("calculateTax")
        var bill = Double(billText.text!) ?? 0
        var tax = 0.0
        //print(bill)
        
        let tipPercentage = Double((tipPercentageLabel.text?.replacingOccurrences(of: "%", with: ""))!) ?? 0
        
        //print("tipPercentage --- \(tipPercentage)")
        
        if(doNotTipOnTax == 1)
        {
            tax = Double(taxText.text!) ?? 0

        }
        
        let tip =  (bill - tax) * tipPercentage / 100
        
        //print(tip)
        
        let total = bill +  tip
        //print(total)
        
        tipLabel.text = String(format: "$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
    }
    
    @IBAction func deductTaxFromBill(_ sender: Any) {
        calculateTax()
    }

    
    
    @IBAction func onSliderValueChanged(_ sender: Any) {
       
        //print("\(tipSlider.value)")
        tipPercentageLabel.text = String(format: "%.2f", tipSlider.value).appending("%")
        calculateTax()

    }
    
    @IBAction func tipSegmentControlValueChanged(_ sender: Any) {
        
        tipPercentageLabel.text = tipPercentage?[tipSegmentControl.selectedSegmentIndex]
        calculateTax()

        
    }
   
    

}

