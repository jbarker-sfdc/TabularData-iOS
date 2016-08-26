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
    
    @IBOutlet weak var rowView: UIStackView!
    @IBOutlet weak var bottomInset: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
    }
    
    func configureWithAttributes(columnAttributes: [TabularDataColumnAttributes]) {
        for i in 0..<columnAttributes.count {
            let attributes = columnAttributes[i]
            
            let nibName = attributes.cellNibName ?? "TabularDataCell"
            let cell = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil).first! as! UIView
            if attributes.width > 0 {
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: attributes.width))
            }
            
            rowView.addArrangedSubview(cell)
            
            if let tabularDataCell = cell as? TabularDataCell {
                tabularDataCell.label.textAlignment = attributes.contentAlignment.textAlignment()
                
                attributes.configureCellUI?(cell: tabularDataCell)
                tabularDataCell.configureCellWithData = attributes.configureCellWithData
            }
        }
    }
    
    func cellForColumnIndex(index: Int) -> UIView {
        return rowView.arrangedSubviews[index]
    }
}
