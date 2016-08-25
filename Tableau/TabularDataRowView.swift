//
//  TabularDataRowView.swift
//  Tableau
//
//  Created by Jason Barker on 8/24/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class TabularDataRowView: UITableViewCell {
    
    static var cellIdentifier: String = "TabularDataRowViewIdentifier"
    
    @IBOutlet weak var rowView: UIView!
    @IBOutlet weak var bottomInset: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
    }
    
    func configureWithAttributes(columnAttributes: [TabularDataColumnAttributes]) {
        var adjacentView = rowView
        for i in 0..<columnAttributes.count {
            let attributes = columnAttributes[i]
            
            let nibName = attributes.cellNibName ?? "TabularDataCell"
            let cell = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil).first! as! UIView
            cell.translatesAutoresizingMaskIntoConstraints = false
            if attributes.width > 0 {
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: attributes.width))
            }
            
            rowView.addSubview(cell)
            rowView.addConstraint(NSLayoutConstraint(item: cell, attribute: .Top, relatedBy: .Equal, toItem: rowView, attribute: .Top, multiplier: 1, constant: 0))
            rowView.addConstraint(NSLayoutConstraint(item: cell, attribute: .Left, relatedBy: .Equal, toItem: adjacentView, attribute: (adjacentView == rowView ? .Left : .Right), multiplier: 1, constant: 0))
            rowView.addConstraint(NSLayoutConstraint(item: cell, attribute: .Bottom, relatedBy: .Equal, toItem: rowView, attribute: .Bottom, multiplier: 1, constant: 0))
            adjacentView = cell
            
            if let tabularDataCell = cell as? TabularDataCell {
                tabularDataCell.label.textAlignment = attributes.contentAlignment.textAlignment()
                
                attributes.configureCellUI?(cell: tabularDataCell)
                tabularDataCell.configureCellWithData = attributes.configureCellWithData
            }
        }
        
        if columnAttributes.count > 0 {
            rowView.addConstraint(NSLayoutConstraint(item: adjacentView, attribute: .Right, relatedBy: .Equal, toItem: rowView, attribute: .Right, multiplier: 1, constant: 0))
        }
    }
    
    func cellForColumnIndex(index: Int) -> UIView {
        return rowView.subviews[index]
    }
}
