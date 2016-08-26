//
//  TabularDataHeaderView.swift
//  Tableau
//
//  Created by Jason Barker on 8/25/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class TabularDataHeaderView: UIControl {
    
    let contentView: UIStackView!
    var selectedColumnIndex: Int?

    init(columnAttributes: [TabularDataColumnAttributes]) {
        contentView = UIStackView(frame: CGRect(x: 0, y: 0, width: 320, height: 44))
        super.init(frame: contentView.frame)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: 0))
        
        buildHeaderFromAttributes(columnAttributes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildHeaderFromAttributes(columnAttributes: [TabularDataColumnAttributes]) {
        for i in 0..<columnAttributes.count {
            let attributes = columnAttributes[i]
            
            let nibName = attributes.headerNibName ?? "TabularDataHeaderCell"
            let cell = UINib(nibName: nibName, bundle: nil).instantiateWithOwner(nil, options: nil).first! as! UIView
            if attributes.width > 0 {
                cell.translatesAutoresizingMaskIntoConstraints = false
                cell.addConstraint(NSLayoutConstraint(item: cell, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: attributes.width))
            }
            
            contentView.addArrangedSubview(cell)
            
            if let tabularDataHeaderCell = cell as? TabularDataHeaderCell {
                tabularDataHeaderCell.sortable = attributes.sortable
                tabularDataHeaderCell.selected = attributes.selected
                tabularDataHeaderCell.label.text = attributes.title
                tabularDataHeaderCell.contentAlignment = attributes.contentAlignment
                
                if tabularDataHeaderCell.sortable {
                    tabularDataHeaderCell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedColumnHeader(_:))))
                    if tabularDataHeaderCell.selected {
                        selectedColumnIndex = i
                    }
                }
            }
        }
    }
    
    func selectedColumnHeader(tap: UITapGestureRecognizer) {
        if let view = tap.view {
            let columnIndex = contentView.arrangedSubviews.indexOf(view)
            if columnIndex != nil {
                if columnIndex == selectedColumnIndex {
                    if let columnHeader = view as? TabularDataHeaderCell {
                        columnHeader.toggleSortOrder()
                        sendActionsForControlEvents(.ValueChanged)
                    }
                }
                else {
                    if let selectedColumnIndex = selectedColumnIndex {
                        if let oldColumnHeader = contentView.arrangedSubviews[selectedColumnIndex] as? TabularDataHeaderCell {
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
            let view = contentView.arrangedSubviews[columnIndex]
            if let tabularDataHeaderCell = view as? TabularDataHeaderCell {
                sortOrder = tabularDataHeaderCell.sortOrder
            }
        }
        
        return sortOrder
    }
}
