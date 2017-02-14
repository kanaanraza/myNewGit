//
//  ErrorModel.swift
//  MobileTopUp
//
//  Created by Rockville Developer on 10/16/15.
//  Copyright (c) 2015 Macbook Pro. All rights reserved.
//

import UIKit

enum RestError: Int {
    
    case RestErrorSessionInvalid = -1
    case RestNetworkConnectionError = -2
    case RestTimedOutError = -3
    case RestUrlNilError = -4
    case RestRequestMethodNilError = -5
    case RestPostPramasNilError = -6
    case RestInvalidUserOrPwd = 404    // user not found
    case UserCantBid = 405
};


class ErrorModel: BaseModel {
    
    var exception : String
    var error : Int
    
    required init(dictionary: Dictionary<String, AnyObject>) {
        
        fatalError("init(dictionary:) has not been implemented")
    }
    init(error: Int, exception: String ) {
        
        self.exception = exception
        self.error = error
        super.init()
        print("error -> \(self.exception)")
    }
    
}

