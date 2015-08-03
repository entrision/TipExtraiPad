//
//  APIManager.swift
//  TipExtraiPad
//
//  Created by Hunter Whittle on 7/31/15.
//  Copyright (c) 2015 Entrision. All rights reserved.
//

import UIKit
import Alamofire

class APIManager: NSObject {
   
    static let kBaseURL = "http://104.236.73.241/api/v1/"
    
    //MARK: Orders
    
    class func getOrders(menuID: NSNumber, success: (responseStatus: Int!, responseArray: NSArray!)->(), failure: (error: NSError!)->()) {
        
        setUserToken()
        
        let url = kBaseURL + "menus/\(menuID)/orders"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON, headers: nil)
        .responseJSON { (request, response, JSON, error) -> Void in
            if error != nil {
                failure(error: error)
            } else {
                println(JSON)
                let jsonDict = JSON as! NSDictionary
                if let orderArray = jsonDict.objectForKey("menu_orders") as? NSArray {
                    let orders = NSMutableArray()
                    for var i=0; i<orderArray.count; i++ {
                        let orderDict = orderArray[i] as! [String: AnyObject]
                        let order = Order(orderDict: orderDict)
                        orders.addObject(order)
                    }
                    success(responseStatus: Utils.kSuccessStatus, responseArray: orders)
                } else {
                    if let errorMessage = jsonDict.valueForKey("message") as? String {
                        success(responseStatus: Utils.kFailureStatus, responseArray: [errorMessage])
                    } else {
                        success(responseStatus: Utils.kFailureStatus, responseArray: nil)
                    }
                }
            }
        }
    }
    
    class func getFullOrder(menuID: NSNumber, orderID: NSNumber, success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
        
        let url = kBaseURL + "menus/\(menuID)/orders/\(orderID)"
        Alamofire.request(.GET, url, parameters: nil, encoding: .JSON, headers: nil)
        .responseJSON { (request, response, JSON, error) -> Void in
            
            if error != nil {
                failure(error: error)
            } else {
                println(JSON)
                let jsonDict = JSON as! NSDictionary
                if let orderDict = jsonDict.objectForKey("order") as? NSDictionary {
                    let drinkArray = orderDict.objectForKey("line_items") as! NSArray
                    let drinks = NSMutableArray()
                    for var i=0; i<drinkArray.count; i++ {
                        let drinkDict: NSMutableDictionary = (drinkArray[i] as! NSDictionary).mutableCopy() as! NSMutableDictionary
                        let nestedDrinkDict = drinkDict["drink"] as! NSDictionary
                        drinkDict.setObject(nestedDrinkDict["name"]!, forKey: "name")
                        let nestedImageDict = nestedDrinkDict["image"] as! NSDictionary
                        drinkDict.setObject(nestedImageDict["image_url"]!, forKey: "image")
                        let responseDict = NSDictionary(dictionary: drinkDict)
                        let drink = Drink(drinkDict: responseDict as! [String : AnyObject])
                        drinks.addObject(drink)
                    }
                    success(responseStatus: Utils.kSuccessStatus, responseDict: ["order_items": drinks])
                } else {
                    //TODO: Handle failure
                }
            }
        }
    }
    
    //MARK: Menu
    
    class func toggleService(menuID: NSNumber, serviceOn: Bool, success: (responseStatus: Int!, responseDict: NSDictionary!)->(), failure: (error: NSError!)->()) {
        
        let params = ["menu": ["service_enabled": serviceOn ? "true" : "false"]]
        
        let url = kBaseURL + "menus/\(menuID)"
        Alamofire.request(.PATCH, url, parameters: params, encoding: .JSON, headers: nil)
        .responseJSON { (request, response, JSON, error) -> Void in
            println(JSON)
            let jsonDict = JSON as! NSDictionary
            if error != nil {
                failure(error: error)
            } else {
                if let errorDict = jsonDict.objectForKey(Utils.kErrorsKey) as? NSDictionary {
                    success(responseStatus: Utils.kFailureStatus, responseDict: errorDict)
                } else {
                    success(responseStatus: Utils.kSuccessStatus, responseDict: nil)
                }
            }
        }
    }
    
    //MARK: Images
    
    class func getImage(path: String, success: (theImage: UIImage!)->(), failure: (error: NSError!)->()) {
        
        //removing auth header for call to amazon servers
        removeUserToken()
        
        Alamofire.request(.GET, NSURL(string: path)!)
        .response() { (_, _, data, error) in
            self.setUserToken()
            if error != nil {
                failure(error: error)
            }
            else {
                if let image = UIImage(data: data! as NSData) {
                    success(theImage: image)
                }
            }
        }
    }
    
    //MARK: Misc methods
    
    class func setUserToken() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = [
            "Authorization": "Token token=eJ98v6TQKkzWZMVGfQqn"
        ]
    }
    
    class func removeUserToken() {
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders?.updateValue("", forKey: "Authorization")
    }
}
