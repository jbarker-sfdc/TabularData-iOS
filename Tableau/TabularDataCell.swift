//
//  TabularDataCell.swift
//  Tableau
//
//  Created by Jason Barker on 8/25/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class TabularDataCell: UIView {

    @IBOutlet weak var label: UILabel!
    
    var configureUI: ((cell: TabularDataCell) -> ())?
    var configureCellWithData: ((cell: TabularDataCell, data: AnyObject) -> ())?
}
