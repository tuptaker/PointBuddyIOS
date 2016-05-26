//
//  PRPBMasterViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/24/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import SwiftyJSON


class PRPBMasterViewController: UITableViewController {
    
    // MARK: PRPBMasterViewController properties
    var menuJSON: JSON?
    weak var menuDelegate: MenuSelectionDelegate?
    
    enum MenuItemType: Int {
        case Pizza
        case Toppings
        case Drinks
    }

    // MARK: PRPBMasterViewController methods
    func instantiateMenuModelFromFile(filePath: String, type: String) -> JSON? {
        var localMenuJSON: JSON?
        
        if let path = NSBundle.mainBundle().pathForResource(filePath, ofType:type) {
            do {
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                localMenuJSON = JSON(data: data)
                if localMenuJSON != JSON.null {
                    print("jsonData:\(localMenuJSON)")
                } else {
                    print("could not get json from file, make sure that file contains valid json.")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        } else {
            print("Invalid filename/path.")
        }
        
        return localMenuJSON
    }
    
    
    // MARK: UIViewController overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuJSON = self.instantiateMenuModelFromFile("Menu", type: "json")
        let menuItemCellXib = UINib(nibName: "PRPBMenuItemTableViewCell", bundle: nil)
        self.tableView.registerNib(menuItemCellXib, forCellReuseIdentifier: "menuItemTableViewCell")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UITableViewDataSource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var numberOfSections = 0
        
        if let menuObj = self.menuJSON {
            numberOfSections = menuObj["Menu"].count
        }
        
        return numberOfSections
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numRowsForSection = 0
        var currMenuItemType:MenuItemType
        
        if let itemType = MenuItemType(rawValue: section), menuObj = self.menuJSON {
            currMenuItemType = itemType

            switch currMenuItemType {
            case .Pizza:
                numRowsForSection = menuObj["Menu"]["Pizza"].count
            case .Toppings:
                numRowsForSection = menuObj["Menu"]["Toppings"].count
            case .Drinks:
                numRowsForSection = menuObj["Menu"]["Drinks"].count
            }
            
        }
        
        return numRowsForSection
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let menuItemCell = UITableViewCell()
        if let menuItemCell = tableView.dequeueReusableCellWithIdentifier("menuItemTableViewCell", forIndexPath: indexPath) as? PRPBMenuItemTableViewCell {
            var menuItemTitle = ""
            var menuItemPrice = ""
            var currMenuItemType:MenuItemType
            
            if let itemType = MenuItemType(rawValue: indexPath.section), menuObj = self.menuJSON {
                currMenuItemType = itemType
                
                switch currMenuItemType {
                case .Pizza:
                    menuItemTitle = (menuObj["Menu"]["Pizza"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
                    menuItemPrice = (menuObj["Menu"]["Pizza"][indexPath.row].dictionaryValue["price"]?.stringValue)!
                case .Toppings:
                    menuItemTitle = (menuObj["Menu"]["Toppings"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
                    menuItemPrice = (menuObj["Menu"]["Toppings"][indexPath.row].dictionaryValue["price"]?.stringValue)!
                case .Drinks:
                    menuItemTitle = (menuObj["Menu"]["Drinks"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
                    menuItemPrice = (menuObj["Menu"]["Drinks"][indexPath.row].dictionaryValue["price"]?.stringValue)!
                }
            }
            
            menuItemCell.menuItemLabel.text = menuItemTitle
            menuItemCell.menuItemPriceLabel.text = menuItemPrice
            menuItemCell.menuDelegate = self
        }
        
        return menuItemCell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleForSection = "Section \(section)"
        var currMenuItemType:MenuItemType
        
        if let _ = self.menuJSON, itemType = MenuItemType(rawValue: section) {
            currMenuItemType = itemType
            
            switch currMenuItemType {
            case .Pizza:
                titleForSection = "Pizza"
            case .Toppings:
                titleForSection = "Toppings"
            case .Drinks:
                titleForSection = "Drinks"
            }
        }
        
        return titleForSection
    }

    
    // MARK: UITableViewDelegate methods
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var menuItem = "section:\(indexPath.section), row:\(indexPath.row)"
        if let menuObj = self.menuJSON, itemType = MenuItemType(rawValue: indexPath.section) {
            
            switch itemType {
            case .Pizza:
                menuItem = (menuObj["Menu"]["Pizza"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
            case .Toppings:
                menuItem = (menuObj["Menu"]["Toppings"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
            case .Drinks:
                menuItem = (menuObj["Menu"]["Drinks"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
            }
        }

        self.menuDelegate?.menuItemSelected(menuItem)
        
        if let detailViewController = self.menuDelegate as? PRPBOrderDetailViewController {
            splitViewController?.showDetailViewController(detailViewController.navigationController!, sender: nil)
        }
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if let menuItemCell = cell as? PRPBMenuItemTableViewCell {
            
        }
    }

}

 
extension PRPBMasterViewController: MenuSelectionDelegate {
    func menuItemSelected(menuItem: String) {
        print("Selected \(menuItem)")
    }
    
    func menuItemAdded(menuItem: String, menuPrice: String) {
        print("Added \(menuItem)")
    }
    
    func menuItemRemoved(menuItem: String, menuPrice: String) {
        print("Removed \(menuItem)")
    }
}
