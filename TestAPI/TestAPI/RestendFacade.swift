//
//  RestendFacade.swift
//  MobileTopUp
//
//  Created by Rockville Developer on 10/16/15.
//  Copyright (c) 2015 Macbook Pro. All rights reserved.
//

import UIKit

//
//  RestendFacade.m
//  MobiStream
//
//  Created by Kanaan Raza on 10/16/15.
//  Copyright (c) 2015 ROCKVILLE TECHNOLOGIES. All rights reserved.
//

//#import "DatabaseHandler.h"

enum RequestMethod {
    
    case NONE
    case GET
    case POST
    case DELETE
}

protocol RestendDelegate {
    
    func restDidReceiveResponse(baseModel:BaseModel,requestId:Int, fromCache:Bool)
    func restDidReceiveError(error:ErrorModel,fromId:Int)
}

class RestendFacade : NSObject
{
    var responseClass : BaseModel.Type
    var requestUrl : String
    var nilUrl : String
    var requestMethod : RequestMethod
    var postParams : Dictionary<String,AnyObject>?
    //var postFuelParams : Dictionary <String, AnyObject>?
    var headerParams : Dictionary<String,String>?
    var headerParamsForPush : Dictionary<String,String>?
    var isMandatory : Bool
    var delegate : RestendDelegate?
    var requestId : Int
    
    init(responseClass: BaseModel.Type){
        
        self.responseClass = responseClass
        self.requestUrl = ""
        self.nilUrl = ""
        self.requestMethod = RequestMethod.GET
        self.isMandatory = true
        self.requestId = -1
        
    }
    
    func getModel () {
        
        if self.requestUrl.isEmpty {
            
            let error = ErrorModel(error: RestError.RestRequestMethodNilError.rawValue, exception:"Request Method cannot be nil")
            if let delegate = self.delegate {
                
                delegate.restDidReceiveError(error,fromId: self.requestId)
            }
            return
        }
        
        if self.requestMethod == RequestMethod.NONE {
            
            let error = ErrorModel(error: RestError.RestRequestMethodNilError.rawValue,exception: "Request Method cannot be nil")
            if let delegate = self.delegate {
                
                delegate.restDidReceiveError(error,fromId: self.requestId)
            }
            return
        }
        
        let url = NSURL(string: self.requestUrl)
        print(url)
        
        if url == nil {
            
            self.nilUrl = "nil"
            
        } else {
            
            let request = NSMutableURLRequest(URL: url!)
            request.setValue("application/json",forHTTPHeaderField:"Accept")
            if let headerParams = self.headerParams {
                
                for (key,value) in headerParams {
                    request.setValue(value, forHTTPHeaderField:key)
                }
            }
            request.HTTPMethod = self.requestMethod == RequestMethod.GET ? "GET" : "POST"
            request.timeoutInterval = 120
            //UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            //NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
            //[request setValue:secretAgent forHTTPHeaderField:@"User-Agent"];
            
            if self.requestMethod == RequestMethod.POST {
                
                if let params = self.postParams {
                    
                    var postParamsString = ""
                    for (key,value) in params {
                        
                        postParamsString = postParamsString + "\(key)=\(value)&"
                    }
                    let rangeOfParams = Range(start: postParamsString.startIndex,end: postParamsString.endIndex.advancedBy(-1))
                    postParamsString = postParamsString.substringWithRange(rangeOfParams)
                    request.HTTPBody = postParamsString.dataUsingEncoding(NSUTF8StringEncoding)
                    
                } else {
                    
                    let error = ErrorModel(error: RestError.RestPostPramasNilError.rawValue,exception:"Post params cannot be nil for POST request")
                    if let delegate = self.delegate {
                        
                        delegate.restDidReceiveError(error,fromId: self.requestId)
                    }
                    return
                }
            }
            //request.HTTPMethod = self.requestMethod == RequestMethod.DELETE ? "DELETE" : "DELETE"
            //request.timeoutInterval = 120
            
            if self.requestMethod == RequestMethod.DELETE {
                
                if let params = self.postParams {
                    
                    var deleteParamsString = ""
                    for (key,value) in params {
                        
                        deleteParamsString = deleteParamsString + "\(key)=\(value)&"
                    }
                    let rangeOfParams = Range(start: deleteParamsString.startIndex,end: deleteParamsString.endIndex.advancedBy(-1))
                    deleteParamsString = deleteParamsString.substringWithRange(rangeOfParams)
                    request.HTTPBody = deleteParamsString.dataUsingEncoding(NSUTF8StringEncoding)
                    
                } else {
                    
                    let error = ErrorModel(error: RestError.RestPostPramasNilError.rawValue,exception:"Post params cannot be nil for DELETE request")
                    if let delegate = self.delegate {
                        
                        delegate.restDidReceiveError(error,fromId: self.requestId)
                    }
                    return
                }
            }
            
            let config = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration:config)
            
            if self.isValidCache() && !self.isMandatory {
                
                //            var dataBaseHandler :DatabaseHandler = DatabaseHandler()
                //            var response : BaseModel = [[self.responseClass alloc] initWithDictionary:[self parseJSONData:[dataBaseHandler getModel:self.requestUrl]]];
                //            dataBaseHandler.closeDb()
                //            self.delegate.restDidReceiveResponse(response,self.requestId,true)
                
            } else {
                
                
                
                let dataTask: NSURLSessionDataTask = session.dataTaskWithRequest(request) {
                    
                    (jsonData:NSData?,response: NSURLResponse?, error: NSError?) in
                    if error == nil {
                        
                        //                    var dateFormatter : NSDateFormatter = NSDateFormatter()
                        //                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        //                    var databaseHandler: DatabaseHandler = DatabaseHandler()
                        //                    databaseHandler.add(200,request: self.requestUrl,timeStamp: dateFormatter.stringFromDate(NSDate()),model: jsonData)
                        //                    databaseHandler.closeDb()
                        let responseModel: BaseModel =  try! self.responseClass.init(dictionary: (self.parseJSONData(jsonData!) as? Dictionary)!)
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            if responseModel.status == true {
                                
                                self.delegate?.restDidReceiveResponse(responseModel,requestId:self.requestId,fromCache:false)
                            } else {
                                
                                let errorModel = ErrorModel(error: responseModel.resCode, exception: responseModel.ErrorDetails)
                                self.delegate?.restDidReceiveError(errorModel, fromId:self.requestId)
                                
                                if responseModel.previousKey == "Status" {
                                    
                                    let errorModel = ErrorModel(error: responseModel.resCode, exception: responseModel.message)
                                    self.delegate?.restDidReceiveError(errorModel, fromId:self.requestId)
                                } else {
                                    let errorModel = ErrorModel(error: responseModel.resCode, exception: responseModel.message)
                                    self.delegate?.restDidReceiveError(errorModel, fromId:self.requestId)
                                }
                            }
                        }
                    } else {
                        
                        var restError: Int = error!.code
                        var strDescription : String = error!.localizedDescription
                        if error!.code == NSURLErrorTimedOut {
                            
                            restError = RestError.RestTimedOutError.rawValue
                            
                            strDescription = "Request Time out."
                            
                        } else if error!.code == NSURLErrorCannotConnectToHost {
                            
                            restError = RestError.RestNetworkConnectionError.rawValue
                            strDescription = "Please check internet connectivity."
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            let errorModel = ErrorModel(error:restError,exception: strDescription)
                            self.delegate?.restDidReceiveError(errorModel,fromId: self.requestId)
                        }
                    }
                }
                dataTask.resume();
            }
        }
    }
    
    func isValidCache()->Bool {
        
        let dateFormatter : NSDateFormatter = NSDateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDate : NSDate  = dateFormatter.dateFromString(dateFormatter.stringFromDate(NSDate()))!
        //var previousDate : NSDate = dateFormatter.dateFromString(DatabaseHandler().getTimeStamp(self.requestUrl))!
        //return nowDate.timeIntervalSinceDate(previousDate) < 60000
        return nowDate.timeIntervalSinceDate(NSDate()) < 60000
    }
    
    func parseJSONData(jsonData:NSData)throws ->NSMutableDictionary {
        
        var _: NSError?
        var dict = NSMutableDictionary()
        var jsonObject : AnyObject!
        do {
            jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData,options: NSJSONReadingOptions.MutableContainers)
        } catch let error as NSError {
            _ = error
            jsonObject = nil
        }
        if jsonObject is NSArray {
            
            let jsonArray = jsonObject as! NSArray
            dict = jsonArray[0] as! NSMutableDictionary
        }
        else {
            
            dict = jsonObject as! NSMutableDictionary
        }
        NSLog("%@",dict);
        return dict
    }
}

