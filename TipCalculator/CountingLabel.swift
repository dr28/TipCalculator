//
//  CountingLabel.swift
//  TipCalculator
//
//  Created by Deepthy on 8/21/17.
//  Copyright © 2017 Deepthy. All rights reserved.
//

import UIKit

class CountingLabel: UILabel {

    var startValue: Float = 0
    var endValue: Float = 0
    var progress: TimeInterval = 0
    var lastUpdate: TimeInterval = 0
    var totalTime: TimeInterval = 0

    var timer: CADisplayLink?

    var currentValue: Float {
        
        if progress >= totalTime { return endValue }
        
        return startValue + (Float(progress / totalTime) * (endValue - startValue))

    }
    
    func countFromExistingValue(to: Float) {
        
        count(from: currentValue, to: to)
    }
    
    func count(from: Float, to: Float) {
        
        startValue = from
        endValue = to
        timer?.invalidate()
        timer = nil
        progress = 0.0
        totalTime = 1.0
        lastUpdate = Date.timeIntervalSinceReferenceDate

        addDisplayLink()
    }
    
    func addDisplayLink() {
        
        timer = CADisplayLink(target: self, selector: #selector(self.updateLabel(timer:)))
        
        timer?.add(to: .main, forMode: .defaultRunLoopMode)
        timer?.add(to: .main, forMode: .UITrackingRunLoopMode)

    }
    
    func updateLabel(timer: Timer) {
        
        let now: TimeInterval = Date.timeIntervalSinceReferenceDate

        progress += now - lastUpdate
        lastUpdate = now

        if progress >= totalTime {
            self.timer?.invalidate()
            self.timer = nil
            progress = totalTime
        }
        
        setTextValue(value: currentValue)
    }

    
    func setTextValue(value: Float) {
        
        let localeSpecificCurrencySymbol : String = (Locale.current as NSLocale).displayName(forKey: .currencySymbol, value: Locale.current.currencyCode as Any)!
        
        let localeSpecificFormatter = NumberFormatter()
        
        localeSpecificFormatter.minimumFractionDigits = 2
        localeSpecificFormatter.maximumFractionDigits = 2
        text = localeSpecificCurrencySymbol.appending(localeSpecificFormatter.string(from: value as NSNumber)!)
        
    }
    


}
