//
//  TabularDataView.swift
//  Tableau
//
//  Created by Jason Barker on 8/24/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

protocol TabularDataDelegate: class {
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, didChangeSortOrder sortOrder: SortOrder, forColumnAtIndex index: Int)
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, numberOfRowsInSection section: Int) -> Int
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, dataForItemAtIndexPath indexPath: NSIndexPath) -> AnyObject?
}

class TabularDataViewController: UITableViewController {
    
    weak var delegate: TabularDataDelegate?
    
    var numberOfColumns: Int { return columnAttributes.count }
    var columnAttributes = [TabularDataColumnAttributes]() { didSet { resetTableHeader() } }
    var headerView: UIView?
    
    func resetTableHeader() {
        let tabularDataHeaderView = TabularDataHeaderView(columnAttributes: columnAttributes)
        tabularDataHeaderView.addTarget(self, action: #selector(sortOrderChanged(_:)), forControlEvents: .ValueChanged)
        headerView = tabularDataHeaderView
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return delegate?.tabularDataViewController(self, numberOfRowsInSection: section) ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var row: TabularDataRowView? = tableView.dequeueReusableCellWithIdentifier(TabularDataRowView.cellIdentifier) as? TabularDataRowView
        if row == nil {
            row = NSBundle.mainBundle().loadNibNamed("TabularDataRowView", owner: self, options: [:]).first as? TabularDataRowView
            row!.configureWithAttributes(columnAttributes)
        }
        
        for i in 0..<numberOfColumns {
            configureColumnInRow(row!, forIndexPath: indexPath.indexPathWithColumn(i))
        }
        
        return row!
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGRectGetHeight(headerView?.frame ?? CGRectZero)
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func configureColumnInRow(row: TabularDataRowView, forIndexPath indexPath: NSIndexPath) {
        let columnCell = row.cellForColumnIndex(indexPath.column)
        if let tabularDataCell = columnCell as? TabularDataCell {
            let data = delegate?.tabularDataViewController(self, dataForItemAtIndexPath: indexPath)
            tabularDataCell.configureCellWithData?(cell: tabularDataCell, data: data)
        }
    }
    
    func sortOrderChanged(sender: AnyObject) {
        if let tabularDataHeaderView = headerView as? TabularDataHeaderView {
            if let sortColumnIndex = tabularDataHeaderView.selectedColumnIndex {
                let sortOrder = tabularDataHeaderView.sortOrderForSelectedColumn()
                delegate?.tabularDataViewController(self, didChangeSortOrder: sortOrder, forColumnAtIndex: sortColumnIndex)
            }
        }
    }
}

// MARK: -

enum TabularDataContentAlignment {
    case Left, Center, Right
    func textAlignment() -> NSTextAlignment {
        switch self {
        case .Left:
            return NSTextAlignment.Left
        case .Center:
            return NSTextAlignment.Center
        case .Right:
            return NSTextAlignment.Right
        }
    }
}

// MARK: -

class TabularDataColumnAttributes {
    
    var width: CGFloat = 0
    var title: String?
    var headerNibName: String?
    var sortable: Bool = false
    var selected: Bool = false
    var sortOrder: SortOrder = .Ascending
    
    var contentAlignment = TabularDataContentAlignment.Left
    
    var cellNibName: String?
    var configureCellUI: ((cell: TabularDataCell) -> ())?
    var configureCellWithData: ((cell: TabularDataCell, data: AnyObject?) -> ())?
}