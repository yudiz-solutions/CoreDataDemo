//
//  Constants.swift
//  manup
//
//  Created by Yudiz Solutions Pvt. Ltd. on 08/01/16.
//  Copyright © 2016 The App Developers. All rights reserved.
//

import UIKit
import Foundation

let _appName        = "CoreDataDemo"
let _screenSize     = UIScreen.main.bounds.size
let _screenFrame    = UIScreen.main.bounds

let _userDefault    = UserDefaults.standard
let _appDelegator   = UIApplication.shared.delegate! as! AppDelegate

// MARK: Global Functions
// Comment in release mode
func jprint(items: Any...) {
    for item in items {
        print(item)
    }
}

extension NSDictionary{
    func getInt32Value(key: String) -> Int32{
        if let any: Any = self.value(forKey: key){
            if let number = any as? NSNumber{
                return number.int32Value
            }else if let str = any as? NSString{
                return str.intValue
            }
        }
        return 0
    }
    
    func getStringValue(key: String) -> String{
        if let any: Any = self.value(forKey:key){
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }
}
