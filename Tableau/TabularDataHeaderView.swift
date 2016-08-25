//
//  TabularDataHeaderView.swift
//  Tableau
//
//  Created by Jason Barker on 8/25/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class TabularDataHeaderView: UIControl {
    
    var selectedColumnIndex: Int?

    init(columnAttributes: [TabularDataColumnAttributes]) {
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        buildHeaderFromAttributes(columnAttributes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildHeaderFromAttributes(columnAttributes: [TabularDataColumnAttributes]) {
        var adjacentView: UIView = self
        for i in 0..<columnAttributes.count {
            let attributes = columnAttributes[i]
            
            let nibName = attributes.headerNibName ?? "TabularDataHeaderCell"
            let cell = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil).first! as! UIView
            cell.translatesAutoresizingMaskIntoConstraints = false
            if attributes.width > 0 {
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: attributes.width))
            }
            
            addSubview(cell)
            addConstraint(NSLayoutConstraint(item: cell, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: cell, attribute: .Left, relatedBy: .Equal, toItem: adjacentView, attribute: (adjacentView == self ? .Left : .Right), multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: cell, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
            adjacentView = cell
            
            if let tabularDataHeaderCell = cell as? TabularDataHeaderCell {
                tabularDataHeaderCell.sortable = attributes.sortable
                tabularDataHeaderCell.selected = attributes.selected
                tabularDataHeaderCell.label.text = attributes.title
                tabularDataHeaderCell.label.textAlignment = attributes.contentAlignment.textAlignment()
                
                if tabularDataHeaderCell.sortable {
                    tabularDataHeaderCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedColumnHeader(_:))))
                    if tabularDataHeaderCell.selected {
                        selectedColumnIndex = i
                    }
                }
            }
        }
        
        if columnAttributes.count > 0 {
            addConstraint(NSLayoutConstraint(item: adjacentView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        }
    }
    
    func selectedColumnHeader(tap: UITapGestureRecognizer) {
        if let view = tap.view {
            let columnIndex = subviews.indexOf(view)
            if columnIndex != nil {
                if columnIndex == selectedColumnIndex {
                    if let columnHeader = view as? TabularDataHeaderCell {
                        columnHeader.toggleSortOrder()
                        sendActionsForControlEvents(.ValueChanged)
                    }
                }
                else {
                    if let selectedColumnIndex = selectedColumnIndex {
                        if let oldColumnHeader = subviews[selectedColumnIndex] as? TabularDataHeaderCell {
                            oldColumnHeader.selected = false
                        }
                    }
                    
                    if let columnHeader = view as? TabularDataHeaderCell {
                        columnHeader.selected = true
                    }
                    selectedColumnIndex = columnIndex
                    sendActionsForControlEvents(.ValueChanged)
                }
            }
        }
    }
    
    func sortOrderForSelectedColumn() -> SortOrder {
        var sortOrder: SortOrder = .Ascending
        
        if let columnIndex = selectedColumnIndex {
            let view = subviews[columnIndex]
            if let tabularDataHeaderCell = view as? TabularDataHeaderCell {
                sortOrder = tabularDataHeaderCell.sortOrder
            }
        }
        
        return sortOrder
    }
}
