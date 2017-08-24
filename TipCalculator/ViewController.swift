//
//  ViewController.swift
//  TipCalculator
//
//  Created by Deepthy on 8/9/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import AVFoundation

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var separationView: UIView!
    @IBOutlet weak var seperationView2: UIView!
    
    @IBOutlet weak var tipSegmentControl: UISegmentedControl!
    @IBOutlet weak var tipSlider: UISlider!
    
    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var taxText: UITextField!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var noOfPeople: UIStepper!
    
    @IBOutlet weak var noPeopleLabel: UILabel!
    @IBOutlet weak var totalPerPerson: CountingLabel!
    @IBOutlet weak var tipPerPerson: CountingLabel!
    
    @IBOutlet weak var thumbImg: UIImageView!
    
    @IBOutlet weak var tipTextLabel: UILabel!
    @IBOutlet weak var totalTextLabel: UILabel!
    @IBOutlet weak var noOfPeopleTextLabel: UILabel!
    @IBOutlet weak var tipPerPersonTextLabel: UILabel!
    @IBOutlet weak var totalPerPersonTextLabel: UILabel!
    @IBOutlet weak var RoundedText: UILabel!
    @IBOutlet weak var RoundedTipText: UILabel!
    
    let defaults = UserDefaults.standard
   
    var doNotTipOnTax = 0
    var showSlider = 0
    var darkTheme = 0
    var roundTotal = 0
    var roundTip = 0

    var defaultTipPercentage:Any? = nil //Amt without %

    var tipPercentage: [String]? = nil //[0.18,0.2,0.25]
    
    let localeSpecificFormatter = NumberFormatter()

    var localeSpecificCurrencySymbol : String?
    
    var appStartTime : NSDate? = nil
    var inActivityStartTime : Any? = nil
    
    var soundPlayer: AVAudioPlayer? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let soundPath = Bundle.main.path(forResource: "ChaChing", ofType: "caf")
        let soundURL = URL(fileURLWithPath: soundPath!)
        
        soundPlayer = try! AVAudioPlayer(contentsOf: soundURL, fileTypeHint: nil)
        
        // Locale specific currency and thousands separator 
        self.navigationItem.rightBarButtonItem?.title = NSString(string: "\u{2699}\u{0000FE0E}") as String // Gear icon
        self.navigationItem.title = "Tip Calculator"

        
        localeSpecificFormatter.numberStyle = .decimal
        localeSpecificFormatter.minimumFractionDigits = 2
        localeSpecificFormatter.maximumFractionDigits = 2
        
        localeSpecificCurrencySymbol = (Locale.current as NSLocale).displayName(forKey: .currencySymbol, value: Locale.current.currencyCode as Any)! // .object(forKey: .countryCode)

        billText.placeholder = localeSpecificCurrencySymbol
        tipLabel.text = localeSpecificCurrencySymbol?.appending("0.00")
        totalLabel.text = localeSpecificCurrencySymbol?.appending("0.00")
        totalPerPerson.text = localeSpecificCurrencySymbol?.appending("0.00")
        tipPerPerson.text = localeSpecificCurrencySymbol?.appending("0.00")
        
        noOfPeople.maximumValue = 100
        noOfPeople.minimumValue = 1
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = ThemeManager.currentTheme().backgroundColor

        self.separationView.backgroundColor = ThemeManager.currentTheme().mainColor.withAlphaComponent(0.6)
        self.seperationView2.backgroundColor = ThemeManager.currentTheme().mainColor.withAlphaComponent(0.6)

        tipPercentageLabel.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        tipTextLabel.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        totalTextLabel.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        noOfPeopleTextLabel.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        tipPerPersonTextLabel.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        totalPerPersonTextLabel.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        RoundedText.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        RoundedTipText.backgroundColor  = ThemeManager.currentTheme().secondaryColor
        
        let font = UIFont.systemFont(ofSize: 28) // adjust the size as required
        var attributes = [NSFontAttributeName : font, NSForegroundColorAttributeName : ThemeManager.currentTheme().mainColor]
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
        
        attributes = [NSForegroundColorAttributeName : ThemeManager.currentTheme().mainColor]
        self.navigationController?.navigationBar.titleTextAttributes = attributes

        billText.becomeFirstResponder()

        defaultTipPercentage = defaults.object(forKey: "DEFAULT_TIP_PERCENTAGE")
        
        if(defaultTipPercentage == nil)
        {
            defaultTipPercentage = "20.00" as String // First time default
        }
        
       
        tipPercentageLabel.text = localeSpecificFormatter.string(from: Float(defaultTipPercentage as! String!)! as NSNumber)!.appending("%") // Locale specific display
        
        doNotTipOnTax = defaults.integer(forKey: "DO_NOT_TIP_0N_TAX")
        
        taxText.isHidden = (doNotTipOnTax == 0)
        
        if(taxText.isHidden)
        {
            taxText.text = ""
        }
      
        darkTheme = defaults.integer(forKey: "DARK_THEME")

        roundTotal = defaults.integer(forKey: "ROUND_TOTAL")

        RoundedText.isHidden = (roundTotal == 0)
        
        roundTip = defaults.integer(forKey: "ROUND_TIP")
        
        RoundedTipText.isHidden = (roundTip == 0)

        showSlider = defaults.integer(forKey: "SHOW_TIP_SLIDER")

        tipSegmentControl.isHidden = (showSlider == 1)
        tipSlider.isHidden = !(showSlider == 1)
        thumbImg.isHidden = !(showSlider == 1)

        
        if(tipSegmentControl.isHidden) // Show slider
        {            
            separationView.isHidden = false
            
            let tipMinPercentage = defaults.object(forKey: "TIP_MIN_PERCENTAGE")
            
            tipSlider.minimumValue = Float(tipMinPercentage as! String)!

            let tipMaxPercentage = defaults.object(forKey: "TIP_MAX_PERCENTAGE")

            tipSlider.maximumValue = Float(tipMaxPercentage as! String)!
            
            tipSlider.value = Float(defaultTipPercentage as! String)!
            
            thumbImg.image = thumbImg.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            
            thumbImg.transform = CGAffineTransform(rotationAngle: (CGFloat((((90/(tipSlider.maximumValue - tipSlider.minimumValue))*(tipSlider.value - tipSlider.minimumValue))*(0.0174))-(90*0.0174))))

            
        }
        else { // Show segmented control
            
            separationView.isHidden = true

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

    @IBAction func onTap(_ sender: Any) {
        
        view.endEditing(true)
        
    }
    
    @IBAction func calculateTax(_ sender: Any) {

        if(NumberFormatter().number(from: billText.text!) == nil) // invalid number
        {
            print("\(NumberFormatter().number(from: billText.text!))")
            if(!(billText.text?.isEmpty)!)
            {
                let errMsg = "Not a valid number"
                errorAlertActionWithStyle(msg: errMsg)
                billText.text = ""

            }
            
            tipLabel.text = localeSpecificCurrencySymbol?.appending("0.00")
            totalLabel.text = localeSpecificCurrencySymbol?.appending("0.00")
            
            totalPerPerson.timer?.invalidate()
            tipPerPerson.timer?.invalidate()

            totalPerPerson.text = localeSpecificCurrencySymbol?.appending("0.00")
            tipPerPerson.text = localeSpecificCurrencySymbol?.appending("0.00")

        }
        else{
            
            calculateTax()

        }
        
    }
    
    func calculateTax()
    {
        
        let numFormatter = NumberFormatter() // convert locale specific currency number to number for calculation

        var convertedNum = numFormatter.number(from: billText.text!) ?? 0

        let bill = Double.init(convertedNum)
        
        if(bill != 0)
        {

            var tax = 0.0

            convertedNum = numFormatter.number(from: (tipPercentageLabel.text?.replacingOccurrences(of: "%", with: ""))!) ?? 0
        
            let tipPercentage = Double.init(convertedNum)
        
            if(doNotTipOnTax == 1 && !(taxText.text?.isEmpty)!)
            {
                convertedNum = numFormatter.number(from: taxText.text!) ?? 0
            
                tax = Double.init(convertedNum)

            }
        
            
            var tip =  (bill - tax) * tipPercentage / 100
        
            print("tip  b4 rounded  \tip")

            if(roundTip == 1)
            {
                tip = rounded(no: tip, toPlaces: 0)
                print("tip rounded  \(tip)")
                
            }
        
            var total = bill +  tip
            
            print("total  b4 rounded  \(total)")

            if(roundTotal == 1)
            {
           
                total = rounded(no: total, toPlaces: 0)
        
                print("total rounded  \(total)")

            }

            tipLabel.text = localeSpecificCurrencySymbol?.appending(localeSpecificFormatter.string(from: tip as NSNumber)!)

            totalLabel.text = localeSpecificCurrencySymbol?.appending(localeSpecificFormatter.string(from: total as NSNumber)!)
            
            calculateTotalPerPerson()
            calculateTipPerPerson()
            print("total \(total)")

        }
    }
    
    func rounded(no : Double, toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (no * divisor).rounded() / divisor
    }
    
    @IBAction func deductTaxFromBill(_ sender: Any) {
        
        let numFormatter = NumberFormatter()
        let tempPercentText = taxText.text

        
        if(!(taxText.text?.isEmpty)! && numFormatter.number(from: tempPercentText!) == nil) // invalid number
        {
            if(numFormatter.number(from: tempPercentText!) != 0)
            {
                let errMsg = "Not a valid number"
                errorAlertActionWithStyle(msg: errMsg)
                taxText.text = ""

            }
            
        }
        
        calculateTax()
    }

    
    
    @IBAction func onSliderValueChanged(_ sender: Any) {

        tipPercentageLabel.text = localeSpecificFormatter.string(from: tipSlider.value as NSNumber)!.appending("%") // Locale specific display
        rotateImg()
        calculateTax()
        
    }
    
    @IBAction func tipSegmentControlValueChanged(_ sender: Any) {
        
        tipPercentageLabel.text = tipPercentage?[tipSegmentControl.selectedSegmentIndex]
        calculateTax()
        
        if(!(billText.text?.isEmpty)!)
        {
            soundPlayer?.play()
        }

        
    }
    
    func rotateImg()
    {
        thumbImg.transform = CGAffineTransform(rotationAngle: (CGFloat((((90/(tipSlider.maximumValue - tipSlider.minimumValue))*(tipSlider.value - tipSlider.minimumValue))*(0.0174))-(90*0.0174))))

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
        
        let subview = alertController.view.subviews.first! as UIView
        
        let alertContentView = subview.subviews.first! as UIView
        
        alertContentView.layer.cornerRadius = 12
        alertContentView.layer.borderWidth = 1
        alertContentView.layer.borderColor = ThemeManager.currentTheme().mainColor.cgColor
        
        alertController.view.tintColor = ThemeManager.currentTheme().mainColor
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            print("Pressed OK button");
        }
        alertController.addAction(OKAction)

        present(alertController, animated: true, completion:nil)
        
        
        
    }
    
    func calculateTotalPerPerson()
    {

        var totalBill = totalLabel.text?.replacingOccurrences(of: localeSpecificCurrencySymbol!, with: "")
        
        totalBill = totalBill?.replacingOccurrences(of: localeSpecificFormatter.currencyGroupingSeparator!, with: "")
        
        if(!(totalBill?.isEmpty)! )
        {
            let nPeople = NumberFormatter().number(from: noPeopleLabel.text!)

            let tBill = NumberFormatter().number(from: totalBill!)
            
            let billPerPerson = Double(tBill!).divided(by: nPeople as! Double)

            totalPerPerson.countFromExistingValue(to: Float(billPerPerson))

        }

    }
    
    func calculateTipPerPerson()
    {
        
        var tip = tipLabel.text?.replacingOccurrences(of: localeSpecificCurrencySymbol!, with: "")
        
        tip = tip?.replacingOccurrences(of: localeSpecificFormatter.currencyGroupingSeparator!, with: "")
        
        if(!(tip?.isEmpty)! )
        {
            let nPeople = NumberFormatter().number(from: noPeopleLabel.text!)
            
            let ntip = NumberFormatter().number(from: tip!)
            
            let ntipPerPerson = Double(ntip!).divided(by: nPeople as! Double)
            
            tipPerPerson.countFromExistingValue(to: Float(ntipPerPerson))//.countFromExistingValue(to: Float(ntipPerPerson))
            
        }
        
    }


    @IBAction func updateNoOfPeople(_ sender: Any) {
        
        noPeopleLabel.text = String.init(Int.init((sender as! UIStepper).value))
        
        let convertedNum = NumberFormatter().number(from: billText.text!) ?? 0
        
        let bill = Double.init(convertedNum)
        
        if(bill != 0)
        {
            calculateTotalPerPerson()
            calculateTipPerPerson()
        }
    }

}

