//
//  BaseModel.swift
//  EOBD2
//
//  Created by Rockville Developer on 3/13/15.
//  Copyright (c) 2015 Macbook Pro. All rights reserved.
//

import UIKit

class BaseModel: NSObject {
   
    var previousKey: String = ""
    var modelId: String = ""
    var modelDescription: String = ""
    var status: Bool = false
    //var message: String = ""
    var message = ""
    var ErrorDetails: String = ""
    var resCode: Int = 0
    override init() { }
    required init(dictionary: Dictionary<String,AnyObject>) {
        
        super.init()
        self.setValuesForKeysWithDictionary(dictionary as [String : AnyObject])
    }
    
    override func setValue(value: AnyObject?, forKey key: String) {
        
        if self.previousKey == key {return }
        self.previousKey = key
        if key == "ids" {
            
            self.modelId = (value as! String)
        }
        else if key == "description" {
            
            self.modelDescription = (value as! String)
        }
            
        else if key == "Message" {
            
            self.message = (value as! String)
        }
        else {
            
            if value != nil {
                
                TryCatchHandling.`try`({ () -> Void in
                    
                    super.setValue(value,forKey: key)
                    
                    }, `catch`: { (exception) -> Void in
                        
                        print("BaseModel->setValue: \(exception.reason!)")
                        
                    }, finally: { () -> Void in
                        
                })
            } else {
                
                print("BaseModel->setValue:cannot set nil for key = \(key)")
            }
        }
    }
}
