//
//  PRPBMasterViewController.swift
//  Point Buddy
//
//  Created by admin mac on 5/24/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import UIKit
import SwiftyJSON


class PRPBMasterViewController: UITableViewController, MenuSelectionDelegate {
    
    // MARK: PRPBMasterViewController properties
    var menuJSON: JSON?
    weak var menuDelegate: MenuSelectionDelegate?
    weak var orderEditDelegate: OrderEditDelegate?
    var currPriceSettings = PRPBConfigManager.sharedInstance.activeSettings
    enum MenuItemType: Int {
        case pizza
        case toppings
        case drinks
    }

    // MARK: PRPBMasterViewController methods
    func instantiateMenuModelFromFile(_ filePath: String, type: String) -> JSON? {
        var localMenuJSON: JSON?
        
        if let path = Bundle.main.path(forResource: filePath, ofType:type) {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions.mappedIfSafe)
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
        self.tableView.register(menuItemCellXib, forCellReuseIdentifier: "menuItemTableViewCell")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: UITableViewDataSource methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        var numberOfSections = 0
        
        if let menuObj = self.menuJSON {
            numberOfSections = menuObj["Menu"].count
        }
        
        return numberOfSections
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numRowsForSection = 0
        var currMenuItemType:MenuItemType
        
        if let itemType = MenuItemType(rawValue: section), let menuObj = self.menuJSON {
            currMenuItemType = itemType

            switch currMenuItemType {
            case .pizza:
                numRowsForSection = menuObj["Menu"]["Pizza"].count
            case .toppings:
                numRowsForSection = menuObj["Menu"]["Toppings"].count
            case .drinks:
                numRowsForSection = menuObj["Menu"]["Drinks"].count
            }
            
        }
        
        return numRowsForSection
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuItemCell = UITableViewCell()
        if let menuItemCell = tableView.dequeueReusableCell(withIdentifier: "menuItemTableViewCell", for: indexPath) as? PRPBMenuItemTableViewCell {
            var menuItemTitle = ""
            var menuItemPrice = ""
            var currMenuItemType:MenuItemType
            
            if let itemType = MenuItemType(rawValue: indexPath.section), let menuObj = self.menuJSON {
                currMenuItemType = itemType
                
                switch currMenuItemType {
                case .pizza:
                    menuItemTitle = (menuObj["Menu"]["Pizza"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
                    menuItemPrice = PRPBConfigManager.sharedInstance.valueForConfigSetting("pizzaPrice") as! String
                    //menuItemPrice = (menuObj["Menu"]["Pizza"][indexPath.row].dictionaryValue["price"]?.stringValue)!
                case .toppings:
                    menuItemTitle = (menuObj["Menu"]["Toppings"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
                    menuItemPrice = PRPBConfigManager.sharedInstance.valueForConfigSetting("toppingPrice") as! String
                    //menuItemPrice = (menuObj["Menu"]["Toppings"][indexPath.row].dictionaryValue["price"]?.stringValue)!
                case .drinks:
                    menuItemTitle = (menuObj["Menu"]["Drinks"][indexPath.row].dictionaryValue["kind"]?.stringValue)!
                    menuItemPrice = PRPBConfigManager.sharedInstance.valueForConfigSetting("drinkPrice") as! String
                    //menuItemPrice = (menuObj["Menu"]["Drinks"][indexPath.row].dictionaryValue["price"]?.stringValue)!
                }
            }
            
            menuItemCell.menuItemLabel.text = menuItemTitle
            menuItemCell.menuItemPriceLabel.text = menuItemPrice
            menuItemCell.menuDelegate = self
        }
        
        return menuItemCell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var titleForSection = "Section \(section)"
        var currMenuItemType:MenuItemType
        
        if let _ = self.menuJSON, let itemType = MenuItemType(rawValue: section) {
            currMenuItemType = itemType
            
            switch currMenuItemType {
            case .pizza:
                titleForSection = "Pizza"
            case .toppings:
                titleForSection = "Toppings"
            case .drinks:
                titleForSection = "Drinks"
            }
        }
        
        return titleForSection
    }

    
    // MARK: UITableViewDelegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
    }

}


// MARK: PRPBMasterViewController extension
extension PRPBMasterViewController {
    
    func menuItemSelected(_ menuItem: String) {
        self.showDetailIfNecessary()
        print("Selected \(menuItem)")
    }
    
    
    func menuItemAdded(_ menuItem: String, menuPrice: String) {
        self.showDetailIfNecessary()
        self.orderEditDelegate?.addedOrderItem(menuItem, orderItemPrice: menuPrice)
        print("Added \(menuItem)")
    }
    
    
    func menuItemRemoved(_ menuItem: String, menuPrice: String) {
        self.showDetailIfNecessary()
        print("Removed \(menuItem)")
    }
    
    
    func showDetailIfNecessary() {
        if let orderTableVC = self.orderEditDelegate as? PRPBOrderTableViewController {
            splitViewController?.showDetailViewController(orderTableVC.orderParentVC!.navigationController!, sender: nil)
        }
    }
}
