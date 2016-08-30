//
//  NumericDataCell.swift
//  Tableau
//
//  Created by Jason Barker on 8/29/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class NumericActionableDataCell: TabularDataCell {
    
    let numberFormatter = NSNumberFormatter()
    
    var actionHandler: ((cell: NumericActionableDataCell, data: AnyObject?) -> ())?
    var actionData: AnyObject?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        numberFormatter.numberStyle = .OrdinalStyle
        numberFormatter.generatesDecimalNumbers = false
        numberFormatter.maximumFractionDigits = 0
    }
    
    @IBOutlet weak var actionButton: UIButton!

    @IBAction func performAction(sender: AnyObject) {
        if actionHandler != nil {
            actionHandler!(cell: self, data: actionData)
        }
    }
}
