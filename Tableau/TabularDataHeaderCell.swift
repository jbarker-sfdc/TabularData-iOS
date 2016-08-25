//
//  TabularDataHeaderCell.swift
//  TableSandbox
//
//  Created by Jason Barker on 8/24/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

enum SortOrder {
    case Ascending
    case Descending
}

class TabularDataHeaderCell: UIView {
    
    struct defaults {
        static var horizontalGap: CGFloat = 4
        static var leftInset: CGFloat = 8
        static var rightInset: CGFloat = 8
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var labelHorizontalPosition: NSLayoutConstraint!
    @IBOutlet weak var sortIcon: UIImageView!
    @IBOutlet weak var sortIconHorizontalPosition: NSLayoutConstraint!
    
    var textAlignment: NSTextAlignment = .Left { didSet { configureTitleLabel() } }
    var sortable: Bool = false { didSet { configureUI() } }
    var selected: Bool = false { didSet { configureUI() } }
    var sortOrder: SortOrder = .Ascending { didSet { configureSortIconImage() } }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    func toggleSortOrder() {
        switch sortOrder {
        case .Ascending:
            sortOrder = .Descending
        case .Descending:
            sortOrder = .Ascending
        }
    }
    
    func configureUI() {
        configureTitleLabel()
        configureSortIcon()
    }
    
    func configureTitleLabel() {
        var attribute: NSLayoutAttribute = .Left
        var horizontalOffset: CGFloat = defaults.leftInset
        
        if textAlignment == .Right {
            attribute = .Right
            horizontalOffset = defaults.rightInset
            if sortable && selected {
                horizontalOffset += defaults.horizontalGap + CGRectGetWidth(sortIcon.bounds)
            }
        }
        else if textAlignment == .Center {
            attribute = .CenterX
            if sortable && selected {
                horizontalOffset = (defaults.horizontalGap + CGRectGetWidth(sortIcon.bounds)) / 2
            }
            else {
                horizontalOffset = 0
            }
        }
        
        label.font = (sortable && selected) ? boldFont() : normalFont()
        
        if labelHorizontalPosition != nil {
            removeConstraint(labelHorizontalPosition!)
        }
        
        labelHorizontalPosition = NSLayoutConstraint(item: label, attribute: attribute, relatedBy: .Equal, toItem: self, attribute: attribute, multiplier: 1, constant: horizontalOffset)
        addConstraint(labelHorizontalPosition)
    }
    
    func configureSortIcon() {
        if sortable && selected {
            configureSortIconImage()
            sortIcon.hidden = false
            
            var firstAttribute: NSLayoutAttribute = .Left
            var secondItem: UIView = label
            var secondAttribute: NSLayoutAttribute = .Right
            var gap: CGFloat = defaults.horizontalGap
            
            if textAlignment == .Right {
                firstAttribute = .Right
                secondAttribute = .Left
            }
            else if textAlignment == .Center {
                firstAttribute = .CenterX
                secondItem = self
                gap = 0
            }
            
            if sortIconHorizontalPosition != nil {
                removeConstraint(sortIconHorizontalPosition)
            }
            
            sortIconHorizontalPosition = NSLayoutConstraint(item: sortIcon, attribute: firstAttribute, relatedBy: .Equal, toItem: secondItem, attribute: secondAttribute, multiplier: 1, constant: gap)
            addConstraint(sortIconHorizontalPosition)
        }
        else {
            sortIcon.hidden = true
        }
    }
    
    func configureSortIconImage() {
        sortIcon.image = getImageForSortOrder(sortOrder)
    }
    
    private func getImageForSortOrder(sortOrder: SortOrder) -> UIImage? {
        print("TabularDataHeaderCell.getImageForSortOrder(_:)    ***  NEEDS IMPLEMENTATION  ***")
        return nil
    }
    
    func boldFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(label.font.pointSize)
    }
    
    func normalFont() -> UIFont {
        return UIFont.systemFontOfSize(label.font.pointSize)
    }
}
