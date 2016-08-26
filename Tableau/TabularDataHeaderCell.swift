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
        static var leftInset: CGFloat = 8
        static var rightInset: CGFloat = -8
    }

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var leftSortIcon: UIImageView!
    @IBOutlet weak var rightSortIcon: UIImageView!
    @IBOutlet weak var contentView: UIStackView!
    
    var contentAlignment: TabularDataContentAlignment = .Left { didSet { configureUI() } }
    var sortable: Bool = false { didSet { configureUI() } }
    var selected: Bool = false { didSet { configureUI() } }
    var sortOrder: SortOrder = .Ascending { didSet { configureUI() } }
    
    private var temporaryConstraints = [NSLayoutConstraint]()
    
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
        var font = normalFont()
        var hideLeftIcon = true
        var hideRightIcon = true
        
        if sortable && selected {
            font = boldFont()
            configureSortIconImage()
            
            switch contentAlignment {
            case .Left:
                hideRightIcon = false
            case .Center:
                hideRightIcon = false
            case .Right:
                hideLeftIcon = false
            }
        }
        
        removeConstraints(temporaryConstraints)
        temporaryConstraints.removeAll()
        
        if contentAlignment == .Left {
            temporaryConstraints.append(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: defaults.leftInset))
//            temporaryConstraints.append(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Right, multiplier: 1, constant: defaults.rightInset))
        }
        else if contentAlignment == .Center {
            temporaryConstraints.append(NSLayoutConstraint(item: contentView, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        }
        else if contentAlignment == .Right {
//            temporaryConstraints.append(NSLayoutConstraint(item: contentView, attribute: .Left, relatedBy: .GreaterThanOrEqual, toItem: self, attribute: .Left, multiplier: 1, constant: defaults.leftInset))
            temporaryConstraints.append(NSLayoutConstraint(item: contentView, attribute: .Right, relatedBy: .Equal, toItem: self, attribute: .Right, multiplier: 1, constant: defaults.rightInset))
        }
        
        addConstraints(temporaryConstraints)
        
        label.font = font
        leftSortIcon.hidden = hideLeftIcon
        rightSortIcon.hidden = hideRightIcon
    }
    
    func configureSortIconImage() {
        let image = getImageForSortOrder(sortOrder)
        leftSortIcon.image = image
        rightSortIcon.image = image
    }
    
    private func getImageForSortOrder(sortOrder: SortOrder) -> UIImage? {
        var imageName: String?
        switch sortOrder {
        case .Ascending:
            imageName = "arrow_small_white_up"
        case .Descending:
            imageName = "arrow_small_white_down"
        }
        
        return UIImage(named: imageName!)
    }
    
    func boldFont() -> UIFont {
        return UIFont.boldSystemFontOfSize(label.font.pointSize)
    }
    
    func normalFont() -> UIFont {
        return UIFont.systemFontOfSize(label.font.pointSize)
    }
}
