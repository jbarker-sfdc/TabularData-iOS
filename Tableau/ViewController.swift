//
//  ViewController.swift
//  Tableau
//
//  Created by Jason Barker on 8/24/16.
//  Copyright © 2016 Jason Barker. All rights reserved.
//

import UIKit

class Superhero: NSObject {
    var name: String
    var alternateIdentity: String
    var rank: Int = 0
    
    init(name: String, alternateIdentity: String, rank: Int) {
        self.name = name
        self.alternateIdentity = alternateIdentity
        self.rank = rank
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var tabularDataView: UITableView!
    
    let tabularDataViewController = TabularDataViewController()
    var data = [[AnyObject]]()
    
    private var superheroes = [Superhero]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        buildSuperheroes()
        data = generateData()
    }
    
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
        column0.title = "Superhero"
        column0.width = 0
        column0.sortable = true
        column0.selected = true
        column0.configureCellWithData = { (cell, data) in
            if let data = data as? String {
                cell.label.text = data
            }
        }
        
        let column1 = TabularDataColumnAttributes()
        column1.title = "Secret Identity"
        column1.width = 300
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
        column2.cellNibName = "NumericActionableDataCell"
        column2.title = "Rank"
        column2.width = 250
        column2.contentAlignment = .Right
        column2.sortable = true
        column2.configureCellWithData = { (cell, data) in
            if let cell = cell as? NumericActionableDataCell, data = data as? Superhero {
                cell.actionData = data
                cell.actionButton.setTitle("Promote", forState: .Normal)
                cell.actionButton.hidden = (data.rank == 1)
                cell.label.text = cell.numberFormatter.stringFromNumber(NSNumber(unsignedShort: UInt16(data.rank)))
                cell.actionHandler = { (cell, data) in
                    if let superhero = data as? Superhero {
                        self.promoteSuperhero(superhero)
                    }
                }
            }
        }
        
        return [column0, column1, column2]
    }
    
    func promoteSuperhero(superhero: Superhero) {
        if let index = superheroes.indexOf(superhero) {
            for i in 0..<index {
                superheroes[i].rank = (i + 2)
            }
            superhero.rank = 1
            superheroes.removeAtIndex(index)
            superheroes.insert(superhero, atIndex: 0)
            data = generateData()
            tabularDataView.reloadData()
        }
    }
    
    private func buildSuperheroes() {
        let batman = Superhero(name: "Batman", alternateIdentity: "Bruce Wayne", rank: 1)
        let spiderman = Superhero(name: "Spider-Man", alternateIdentity: "Peter Parker", rank: 2)
        let ironman = Superhero(name: "Iron Man", alternateIdentity: "Tony Stark", rank: 3)
        let superman = Superhero(name: "Superman", alternateIdentity: "Clark Kent", rank: 4)
        let wolverine = Superhero(name: "Wolverine", alternateIdentity: "James (Logan) Howlett", rank: 5)
        let captainAmerica = Superhero(name: "Captain America", alternateIdentity: "Steve Rogers", rank: 6)
        let hulk = Superhero(name: "Hulk", alternateIdentity: "Bruce Banner", rank: 7)
        let thor = Superhero(name: "Thor", alternateIdentity: "Thor", rank: 8)
        let flash = Superhero(name: "The Flash", alternateIdentity: "Barry Allen", rank: 9)
        let greenLantern = Superhero(name: "Green Lantern", alternateIdentity: "Alan Scott", rank: 10)
        
        superheroes = [batman, spiderman, ironman, superman, wolverine, captainAmerica, hulk, thor, flash, greenLantern]
    }
    
    func generateData() -> [[AnyObject]] {
        var data = [[AnyObject]]()
        for superhero in superheroes {
            data.append([superhero.name, superhero.alternateIdentity, superhero])
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
    func tabularDataViewController(tabularDataViewController: TabularDataViewController, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected row \(indexPath.row)")
    }
}