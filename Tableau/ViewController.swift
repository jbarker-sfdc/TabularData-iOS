//
//  ViewController.swift
//  Tableau
//
//  Created by Jason Barker on 8/24/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tabularDataView: UITableView!
    
    let tabularDataViewController = TabularDataViewController()
    var data: [[AnyObject]] = ViewController.generateMoreData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabularDataView.reloadData()
    }
    
    func configureTableView() {
        tabularDataViewController.view = tabularDataView
        tabularDataView.dataSource = tabularDataViewController
        tabularDataView.delegate = tabularDataViewController
        tabularDataView.backgroundColor = UIColor.clearColor()
        tabularDataViewController.delegate = self
        tabularDataViewController.columnAttributes = getColumnAttributes()
    }
    
    func getColumnAttributes() -> [TabularDataColumnAttributes] {
        let column0 = TabularDataColumnAttributes()
        column0.title = "Column 0"
        column0.width = 0
        column0.sortable = true
        column0.selected = true
        column0.configureCellWithData = { (cell, data) in
            if let data = data as? String {
                cell.label.text = data
            }
        }
        
        let column1 = TabularDataColumnAttributes()
        column1.title = "Column 1"
        column1.width = 100
        column1.sortable = true
        column1.contentAlignment = .Center
//        column1.configureCellUI = { (cell) in
//            cell.label.textAlignment = .Right
//        }
        column1.configureCellWithData = { (cell, data) in
            if let data = data as? String {
                cell.label.text = data
            }
        }
        
        let column2 = TabularDataColumnAttributes()
        column2.cellNibName = "NumericDataCell"
        column2.title = "Column 2"
        column2.width = 250
        column2.contentAlignment = .Right
        column2.sortable = true
        column2.configureCellWithData = { (cell, data) in
            if let data = data as? Double, cell = cell as? NumericDataCell {
                cell.label.text = cell.numberFormatter.stringFromNumber(NSNumber(double: data))
            }
        }
        
        return [column0, column1, column2]
    }
    
    class func generateData() -> [[AnyObject]] {
        let d0: [AnyObject] = ["User 1", "Green", Double(0.0)]
        let d1: [AnyObject] = ["User 2", "Orange", Double(32)]
        let d2: [AnyObject] = ["User 3", "Pink", Double(27)]
        let d3: [AnyObject] = ["User 4", "Blue", Double(299)]
        let d4: [AnyObject] = ["User 5", "Yellow", Double(0)]
        let d5: [AnyObject] = ["User 6", "Red", Double(45)]
        
        return [d0, d1, d2, d3, d4, d5]
    }
    
    class func generateMoreData() -> [[AnyObject]] {
        var data = [[AnyObject]]()
        for _ in 0...20 {
            data.appendContentsOf(generateData())
        }
        
        return data
    }
}


extension ViewController: TabularDataDelegate {
    
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, didChangeSortOrder sortOrder: SortOrder, forColumnAtIndex index: Int) {
        print("You selected column \(index) [sortOrder=\(sortOrder)]")
    }
    
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, dataForItemAtIndexPath indexPath: NSIndexPath) -> AnyObject? {
        let item = data[indexPath.row] as [AnyObject]
        return item[indexPath.column]
    }
}