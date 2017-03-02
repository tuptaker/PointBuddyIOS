//
//  PRPBConfigManager.swift
//  Point Buddy
//
//  Created by admin mac on 6/9/16.
//  Copyright © 2016 tuptake. All rights reserved.
//

import Foundation

protocol ConfigManager {
    init()
    func loadSettingsFromBundle()
    func valueForConfigSetting(_ configKey: String) -> AnyObject
    func cacheConfigSettings() -> [String: AnyObject]
}

class PRPBConfigManager: NSObject, ConfigManager {
    static let sharedInstance = PRPBConfigManager()
    var activeSettings: [String: AnyObject] = [String: AnyObject]()
    
    override required init() {
        super.init()
        self.loadSettingsFromBundle()
        self.activeSettings = self.cacheConfigSettings()
    }
    
    func loadSettingsFromBundle() {
        var defaultsToRegister: [String: AnyObject] = [String: AnyObject]()
        var url: URL?
        if let path = Bundle.main.path(forResource: "Settings", ofType: "bundle") {
            url = URL(fileURLWithPath: path)
        }
        
        if let pathURL = url, let settingsDict = NSDictionary(contentsOf: pathURL.appendingPathComponent("Root.plist")) as? [String: AnyObject] {
            let prefObj = settingsDict["PreferenceSpecifiers"]
            if let preferencesArray = prefObj as? Array<Dictionary<String, AnyObject>> {
                let count: Int = preferencesArray.count
                defaultsToRegister = Dictionary(minimumCapacity: count)
                UserDefaults.resetStandardUserDefaults()
                for preferencesSpec in preferencesArray {
                    if let key = preferencesSpec["Key"] as? String {
                        defaultsToRegister[key] = preferencesSpec["DefaultValue"]
                    }
                }
            }
        }
        UserDefaults.standard.register(defaults: defaultsToRegister)
    }
    
    func valueForConfigSetting(_ configKey: String) -> AnyObject {
        return self.activeSettings[configKey]!
    }
    
    func cacheConfigSettings() -> [String: AnyObject] {
        var settings = Dictionary<String, String>()
        settings["pizzaPrice"] = UserDefaults.standard.string(forKey: "pizzaPrice")
        settings["toppingPrice"] = UserDefaults.standard.string(forKey: "toppingPrice")
        settings["drinkPrice"] = UserDefaults.standard.string(forKey: "drinkPrice")
        settings["taxRate"] = UserDefaults.standard.string(forKey: "taxRate")
        
        return settings as [String : AnyObject]
    }
    
}
