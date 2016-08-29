//
//  NumericDataCell.swift
//  Tableau
//
//  Created by Jason Barker on 8/29/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class NumericDataCell: TabularDataCell {
    
    let numberFormatter = NSNumberFormatter()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        numberFormatter.numberStyle = .CurrencyStyle
        numberFormatter.generatesDecimalNumbers = false
        numberFormatter.currencySymbol = "$"
        numberFormatter.currencyCode = "USD"
    }
    
    @IBOutlet weak var actionButton: UIButton!

    @IBAction func performAction(sender: AnyObject) {
        print("You tapped me")
    }
}
